ERIC KIRKLAND
COURSERA -GETTING AND CLEANING DATA PROJECT
CODEBOOK

October 19, 2014


DATA EXTRACTION AND CLEANING PROCEDURE

The assignment required extracting and merging data from a collection of datasets
in a zip file. Unzipping the file produced a folder structure that contained a root
folder named: UCI HAR Dataset. The relevant subfolders were /train and /test. Each
contained a subfolder that was not used in the assignment. 

Each file was inspected visually, revealing no headers. The data files were plain
text with variables separated by spaces (blanks). 

The files in the ./train directory included:
(a) X_train.txt, in which each row is a list of 561 training measurements
(b) y_train.text, which is a list of activity labels (1-6) for each training data row
(c) subject_test.txt, which is the subject number for each training data row.

The files in the ./test directory were the same format. Of course, the word "test" 
substituted for the word "train" in the filenames.

X_train.txt data were loaded using the R read.table function. This function separated 
the variables as follows:  V1, V2, ..., V561.  Not having any better names to apply,
these were left intact.  After using setwd() to identify the working director to
the R console, the loading commands used were:
traindata <- read.table("./X_train.txt", header=FALSE)
trainlabels <- read.table("./y_train.txt", header=FALSE)
trainsubjects <- read.table("./subject_test.tst", header=FALSE)

The trainlabels data frame (DF) had a single variable which defaulted to "V1". 
It was renamed "Activity" using the R rename() function:
trainlabels <- rename(trainlabels,replace=c("V1" = "Activity"))

Activity takes on a range of values from 1 to 6:
1 := Walking
2 := Walking_Upstairs
3 := Walking_Downstairs
4 := Sitting
5 := Standing
6 := Laying  [sic]

The trainsubjects DF also had a single variable that defaulted to "V1". 
This was renamed "CaseNbr". 
It was reported in the datasets README file to have data for 30 subjects.  
It did not, as was revealed by visual inspection and by using the R function count().

The same steps were taken for the testlabels and testsubjects data frames, creating
DF for each.

Then test data frame was created using the R cbind() function:
testdatadf <-cbind(testsubjects, testlabels, testdata)
The resulting DF has variables CaseNbr Activity V1 V2..V561.  

The same procedure was applied to the train data.

Merging these two data frames as is would result in the loss of information on which
data were test and which were train.  Therefore, a "code" column was added to each DF:
testdf$code <- "test"
traindf$code <- "train"

These two data frames then were combined using the R merge() function:
combinedDF <- merge(traindf, testdf, all=TRUE)

The combinedDF has 10299 rows, which means each row from test and train were preserved.
This was confirmed using the R nrow() function:
> nrow(testdf) 
[1] 2947
> nrow(traindf)
[1] 7352
> nrow(combinedDF)
[1] 10299
> nrow(testdf) + nrow(traindf)
[1] 10299

These three data frames were saved as CSV using the R write.csv() function:
write.csv(testdf, file="testDF.csv")   # note change from "df" to "DF"
write.csv(traindf, file="trainDF.csv")   # ditto
write.csv(combinedDF, file="combinedDF.csv)  #already using capital "DF"

Each of these datasets are tidy.

VARIABLES

CaseNbr := identifies the subject

Activity := identifies the activity

V1:V561 := These are 561 variables that were collected data. There may be
better names, but I do not know what they might be.

code := identifies if data was from "train" or "test", the only two values: 
1 := train 
2 := test 

These Activity and code variables are recoded to be more descriptive by 
the analysis script.

PROJECT REQUIREMENTS

1) Merge test and training data.  YES: combinedDF.

2) Extract only means and standard deviations.
2.1) aggMEAN <- aggregate(combinedDF, by=list(combinedDF$CaseNbr,combinedDF$code,
    combinedDF$Actvity), FUN=mean, na.rm =TRUE)
2.2) aggSD <- aggregate(combinedDF, by=list(combinedDF$CaseNbr,combinedDF$code,
    combinedDF$Activity), FUN=sd, na.rm =TRUE)

3) Uses descriptive activity names.  YES.

4) Appropriately labels variables.  YES.

5) Creates a second, independent data with the average for each activity and subject.
aggDF <- merge(aggMean, aggSD, all=TRUE)  # YES.

