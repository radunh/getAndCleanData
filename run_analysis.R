## run_analysis.R

## You should create one R script called run_analysis.R that does the following. 

## the data can be found here
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.

require("reshape2") 

##This should be standard in all files that pull data
#"Ensuring the data path exists..."
dataPath <- "./data" 
if (!file.exists(dataPath)) { dir.create(dataPath) } 

#download dataset 
fileName <- "Dataset.zip" 
filePath <- paste(dataPath,fileName,sep="/") 
if (!file.exists(filePath)) {  
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
  download.file(url=fileURL,destfile=filePath,method="curl") 
} 

#Timestamping the data set archive file with when it wad downloaded
fileConn <- file(paste(filePath,".timestamp",sep="")) 
writeLines(date(), fileConn) 
close(fileConn) 


#Extracting the data set files from the archive
unzip(zipfile=filePath, exdir=dataPath) 


# Set the data path of the extracted archive files... 
dataSetPath <- paste(dataPath,"UCI HAR Dataset",sep="/") 


#Reading training & test column files 
xTrain <- read.table(file=paste(dataSetPath,"/train/","X_train.txt",sep=""),header=FALSE) 
xTest  <- read.table(file=paste(dataSetPath,"/test/","X_test.txt",sep=""),header=FALSE) 
yTrain <- read.table(file=paste(dataSetPath,"/train/","y_train.txt",sep=""),header=FALSE) 
yTest  <- read.table(file=paste(dataSetPath,"/test/","y_test.txt",sep=""),header=FALSE) 
sTrain <- read.table(file=paste(dataSetPath,"/train/","subject_train.txt",sep=""),header=FALSE) 
sTest  <- read.table(file=paste(dataSetPath,"/test/","subject_test.txt",sep=""),header=FALSE) 


#Reading the features file and naming the columns with it
features <- read.table(file=paste(dataSetPath,"features.txt",sep="/"),header=FALSE) 
names(xTrain) <- features[,2] 
names(xTest)  <- features[,2] 
names(yTrain) <- "ActivityID" 
names(yTest)  <- "ActivityID" 
names(sTest)  <- "SubjectID" 
names(sTrain) <- "SubjectID" 


#Merging (appending) the training and test data set 
xData <- rbind(xTrain, xTest) 
yData <- rbind(yTrain, yTest) 
sData <- rbind(sTrain, sTest) 
data <- cbind(xData, yData, sData) 


#Extracting measurements on mean & standard deviation
matchingCols <- grep("mean|std|Activity|Subject", names(data)) 
data <- data[,matchingCols] 


activityNames <- read.table(file=paste(dataSetPath,"activity_labels.txt",sep="/"),header=FALSE) 
names(activityNames) <- c("ActivityID", "Activity_Name") 
data <- merge(x=data, y=activityNames, by.x="ActivityID", by.y="ActivityID" ) 


#Set column names, remove ()
names(data) <- gsub(pattern="[()]", replacement="", names(data)) 


#Replace hyphens with underscores 
names(data) <- gsub(pattern="[-]", replacement="_", names(data)) 


#Removing columns used only for tidying up the data set
data <- data[,!(names(data) %in% c("ActivityID"))] 


#Melting the data set
meltdataset <- melt(data=data, id=c("SubjectID", "Activity_Name")) 


#Create the tidy data
tidyData <- dcast(data=meltdataset, SubjectID + Activity_Name ~ variable, mean) 


# write data 
tidyFilePath <- paste(".","TidyData.txt",sep="/") 
write.csv(tidyData, file=tidyFilePath, row.names=FALSE) 
