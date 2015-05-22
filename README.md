# getAndCleanData
this is for the Getting and Cleaning data class project at John Hopkins

This project creates one R script called run_analysis.R that does the following. 

the data can be found here https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Instructions

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. From the data set in step 4, creates a second, independent tidy data set with 

6. the average of each variable for each activity and each subject.


What the run_analysis.R file does

require("reshape2") 
Ensuring the data path exists..."
download dataset 
Timestamp the data set archive file with when it wad downloaded
Extracting the data set files from the archive
Set the data path of the extracted archive files... 
Read training & test column files 
Read the features file and name the columns with it
Mergethe training and test data set 
Extract measurements on mean & standard deviation
merge the data with the Activity Names table
Set column names, remove ()
Replace hyphens with underscores 
Remove columns used only for tidying up the data set
Melt the data set
Create the tidy data
write data 

