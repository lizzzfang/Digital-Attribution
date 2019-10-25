library("GameTheoryAllocation")
library(tidyverse)
library(reshape2)
library(ChannelAttribution)

# Load the data
data(PathData)


# Fetch unique number of channels for coalitions purpose
channels <- unique(Data %>% select(path) %>% separate_rows(path, sep = ' > '))
number_of_channels <- length(channels[[1]])


###Create the characteristic function###
# Transform the path into a binary data frame (duplicated touch points are removed here)

# change to binary data frame
binary <- Data %>% mutate(id = row_number()) %>%  # create a unique ID
      separate_rows(path, sep = ' > ') %>%
      mutate(Y = 1) %>%
      group_by(id) %>% 
      distinct(path, .keep_all = TRUE) %>%         # distinct touch-point in the path
      spread(path, Y, fill = 0) %>%
      ungroup()  %>% select(-id)      # ungroup and remove id column


# aggregate the binary data frame and compute the number of sequences
# in the belonged group
# for each combination of marketing channels
conv_rates = binary %>%
  group_by_at(vars(alpha:zeta)) %>%
  summarize(
    total_conversions = sum(total_conversions),
    total_sequences = n()
  ) %>% collect


# Coalitions (Powerset of possible combinition)
touch_combos = as.data.frame(coalitions(number_of_channels)$Binary)
names(touch_combos) = c(channels$path)


# Now I'll join my previous summary results with the binary matrix
# the GameTheoryAllocation library built for me.
touch_combo_conv_rate = left_join(touch_combos, conv_rates, by = c(channels$path))
# Finally, I'll fill in any NAs with 0
touch_combo_conv_rate = touch_combo_conv_rate %>%
  mutate_all(funs(ifelse(is.na(.),0,.))) %>%
  mutate(
    conv_rate = ifelse(total_sequences > 0, total_conversions/total_sequences, 0)
  )

# Building Shapley Values for each channel combination
shap_vals = touch_combos
coalition_mat = shap_vals

# Compute the attribution for the last raw in the matrix
shap_vals[2^number_of_channels,] = Shapley_value(touch_combo_conv_rate$conv_rate, game="profit")
# Loop over the previous combinition
for(i in 2:(2^number_of_channels-1)){
  if(sum(coalition_mat[i,]) == 1){
    shap_vals[i,which(shap_vals[i,]==1)] = touch_combo_conv_rate[i,"conv_rate"]
  }else if(sum(coalition_mat[i,]) > 1){
    if(sum(coalition_mat[i,]) < number_of_channels){
      channels_of_interest = which(coalition_mat[i,] == 1)
      char_func = data.frame(rates = touch_combo_conv_rate[1,"conv_rate"])
      for(j in 2:i){
        if(sum(coalition_mat[j,channels_of_interest])>0 & 
           sum(coalition_mat[j,-channels_of_interest])==0)
          char_func = rbind(char_func,touch_combo_conv_rate[j,"conv_rate"])
      }
      shap_vals[i,channels_of_interest] = 
        Shapley_value(char_func$rates, game="profit")
    }
  }
}

# Apply Shapley Values as attribution weighting
order_distribution = shap_vals * touch_combo_conv_rate$total_sequences
shapley_value_orders = t(t(round(colSums(order_distribution))))
shapley_value_orders = data.frame(mid_campaign = row.names(shapley_value_orders), 
                                  orders = as.numeric(shapley_value_orders))
