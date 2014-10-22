ERIC KIRKLAND
COURSERA -GETTING AND CLEANING DATA PROJECT
CODEBOOK

October 19, 2014


VARIABLES

Subject := identifies the subject

Activity := identifies the activity

V1:V561 := These are 561 variables that were collected data. There may be better names, but I do not know what they might be.

Code := identifies if data was from "train" or "test", the only two values: 
1 := train 
2 := test 

These Activity and Code variables are recoded to be more descriptive by the analysis script.

The run_analysis.R script has extensive comments.

The final data frame, aggDF, has the means and SD of the variables. 