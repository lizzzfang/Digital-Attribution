library(ChannelAttribution)

data(PathData)


# Auto run Markov Chains
auto_markov_model(Data, "path", "total_conversions", "total_null")


# Choose the initial order
# Find the minimum Markov Model order that gives a good representation of customers' behaviour
# for data considered. 
res=choose_order(Data, var_path="path", var_conv="total_conversions",
                 var_null="total_null")
#plot auc and penalized auc
#It requires paths that do not lead to conversion as input. Minimum order is
# found maximizing a penalized area under ROC curve.
plot(res$auc$order,res$auc$auc,type="l",xlab="order",ylab="pauc",main="AUC")
lines(res$auc$order,res$auc$pauc,col="red")
legend("right", legend=c("auc","penalized auc"),
       col=c("black","red"),lty=1)


# Estimate three heuristic models (first-touch, last-touch, linear) from customer journey data.
heuristic_models(Data,"path","total_conversions")
heuristic_models(Data,"path","total_conversions",var_value="total_conversion_value")


# Estimate number of conversions and conversion value attributed to each channel
markov_model(Data, "path", "total_conversions", order = res$suggested_order,
             var_null="total_null")

markov_model(Data, "path", "total_conversions", var_value="total_conversion_value",
             var_null="total_null", out_more=TRUE)

# Trasnstion_Matrix
transition_matrix(Data, var_path="path", var_conv="total_conversions",
                  var_null="total_null", order=3, sep=">", flg_equal=TRUE)
