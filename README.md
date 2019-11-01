# Digital-Attribution
This project is a start in the digital attribution field. It will include implementation of Data-Driven Attribution Models: Markov Chains and Shapley Values.

### Simple Example
The jupyter notebook script is a single path attribuion built on the Shapley theory.

### R Folder
The test data set is a customer journeys data attached in R library.
PathData is a data.frame with 10.000 rows and 4 columns: 
- "path" containing customer paths
- "total_conversions" containing total number of conversions
- "total_conversion_value" containing total conversion value 
- "total_null" containing total number of paths that do not lead to conversion.
|path                     |total_conversions	|total_conversion_value	|total_null	|
|---                      |---			          |---			              |---		    |
|eta > iota > alpha > eta	|1	                |0.244	                |3          |
|iota > iota > iota > iota|2	                |3.195	                |6          |

| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |

#### Markov Chains
The script is based on R library [ChannelAttribution](https://cran.r-project.org/web/packages/ChannelAttribution/ChannelAttribution.pdf).
The library includes First-touch, Last-touch, Linear Attibution Models and Markov Chains.
#### Shapley Values
###### Reference for the script: [TREVOR PAULSEN](http://datafeedtoolbox.com/attribution-theory-the-two-best-models-for-algorithmic-marketing-attribution-implemented-in-apache-spark-and-r/)
Many codes within the script came from the above reference. Due to many unobserved coalitions, the characteristic function is not robust. The output result is biased obviously.

![Image of Output](https://github.com/lizzzfang/Digital-Attribution/blob/master/R/Model_Comparison_Plot.png)
