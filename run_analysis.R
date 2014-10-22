# AUTHOR:    Eric Kirkland
# COURSERA:  Getting and Cleaning Data Project 
# SCRIPT:    run_analysis.R
# DATE:      October 21, 2014
# 
# Read data files, assuming these are in the working directory.
#
trainData <- read.table("./X_train.txt", header=FALSE)
trainLabels <- read.table("./y_train.txt", header=FALSE)
trainSubjects <- read.table("./subject_train.txt", header=FALSE)
#
# Require plyr package.
#
require(plyr)
# 
# Assign descriptive names to subjects and activities.
#
trainLabels <- rename(trainLabels,replace=c("V1" = "Activity"))
trainSubjects <- rename(trainSubjects,replace=c("V1" = "Subject"))
#
# Use cbind() to create a train data frame.
#
trainDF <-cbind(trainSubjects, trainLabels, trainData)
#
# Add a code variable to indicate these are train data.
#
trainDF$Code <- 1
#
# Repeat for test data.
#
testData <- read.table("./X_test.txt", header=FALSE)
testLabels <- read.table("./y_test.txt", header=FALSE)
testSubjects <- read.table("./subject_test.txt", header=FALSE)
testLabels <- rename(testLabels,replace=c("V1" = "Activity"))
testSubjects <- rename(testSubjects,replace=c("V1" = "Subject"))
testDF <-cbind(testSubjects, testLabels, testData)
testDF$Code <- 2
#
# Merge these to create a combined data file.
#
combinedDF <- merge(trainDF, testDF, all=TRUE)
#
# Update variables to have descriptive names.
#
combinedDF$Activity[combinedDF$Activity==1] <- "Walking"
combinedDF$Activity[combinedDF$Activity==2] <- "Walking_Upstairs"
combinedDF$Activity[combinedDF$Activity==3] <- "Walking_Downstairs"
combinedDF$Activity[combinedDF$Activity==4] <- "Sitting"
combinedDF$Activity[combinedDF$Activity==5] <- "Standing"
combinedDF$Activity[combinedDF$Activity==6] <- "Lying"
combinedDF$Code[combinedDF$Code==1] <- "Train"
combinedDF$Code[combinedDF$Code==2] <- "Test"
#
# Ignore warnings.
# 
options(warn = -1)
#
# Create a new data frame containing means by case and activity
#
aggMEAN <- aggregate(combinedDF, 
  by = list(combinedDF$Subject, combinedDF$Code, combinedDF$Activity),
  FUN = mean, na.rm = TRUE)
#
# Create a new data frame containing sd by case and activity
#
aggSD <- aggregate(combinedDF, 
  by = list(combinedDF$Subject, combinedDF$Code, combinedDF$Activity),
  FUN = sd, na.rm = TRUE)
#
# Add a type indicator to each data frame to indicate "Mean" or "SD".
#
aggMEAN$Type <- "Mean"
aggSD$Type <- "SD"
#
# Combine these to create a new, independent data frame.
#
aggDF <- merge(aggMEAN, aggSD, all=TRUE)
#
# Save to a text file using write.table() with row.names=FALSE.
#
write.table(aggDF, file="./aggDF.txt", row.names=FALSE)
#
# End Script