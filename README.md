Getting-Data-Project
====================
README.md

October 21, 2014

This project was developed as part of the Coursera "Getting and Cleaning Data" course by Eric Kirkland.

DATA EXTRACTION AND CLEANING PROCEDURE

The assignment required extracting and merging data from a collection of datasets in a zip file. Unzipping the file produced a folder structure that contained a root folder named: UCI HAR Dataset. The relevant subfolders were /train and /test. Each
contained a subfolder that was not used in the assignment. 

Each file was inspected visually, revealing no headers. The data files were plain text with variables separated by spaces (blanks). 

The files in the ./train directory included:
(a) X_train.txt, in which each row is a list of 561 training measurements
(b) y_train.text, which is a list of activity labels (1-6) for each training data row
(c) subject_train.txt, which is the subject number for each training data row.

The files in the ./test directory were the same format. Of course, the word "test" substituted for the word "train" in the filenames.

X_train.txt data were loaded using the R read.table function. This function separated the variables as follows:  V1, V2, ..., V561.  Not having any better names to apply, these were left intact.  After using setwd() to identify the working director to
the R console, the loading commands used were:
traindata <- read.table("./X_train.txt", header=FALSE)
trainlabels <- read.table("./y_train.txt", header=FALSE)
trainsubjects <- read.table("./subject_test.tst", header=FALSE)

The trainlabels data frame (DF) had a single variable which defaulted to the name "V1". It was renamed "Activity" using the rename() function:
trainlabels <- rename(trainlabels,replace=c("V1" = "Activity"))

Activity takes on a range of values from 1 to 6:
1 := Walking
2 := Walking_Upstairs
3 := Walking_Downstairs
4 := Sitting
5 := Standing
6 := Laying  [sic]

The trainsubjects DF also had a single variable that defaulted to "V1". 
This was renamed "Subject". 

The same steps were taken for the testlabels and testsubjects data frames, creating DF for each.

Then test data frame was created using the R cbind() function:
testdatadf <-cbind(testsubjects, testlabels, testdata)
The resulting DF has variables: Subject Activity V1 V2..V561. The same procedure was applied to the train data.

Merging these two data frames as is would result in the loss of information on which data were test and which were train.  Therefore, a "code" column was added to each DF.

These two data frames then were combined using the R merge() function:
combinedDF <- merge(traindf, testdf, all=TRUE)

The combinedDF has 10299 rows, which means each row from test and train were preserved. This was confirmed using the R nrow() function:
> nrow(testdf) 
[1] 2947
> nrow(traindf)
[1] 7352
> nrow(combinedDF)
[1] 10299
> nrow(testdf) + nrow(traindf)
[1] 10299

Next aggregate() was used to create an aggMEAN data frame and an aggSD data frame. These were then combined using merge() and saved to disk using write.table().

The run_analysis.R file contains extensive commentary on the step by step process.
