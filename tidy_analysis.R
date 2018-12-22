library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

#Assuming the user is already in the correct working directory containing
#the unzipped UCI HAR Dataset folder

#Load the activity labels
activitylabels <- read.table('./UCI HAR Dataset/activity_labels.txt')
activitylabels[,2] <- activitylabels[,2] %>% as.character()

#load features
features <- read.table('./UCI HAR Dataset/features.txt')
features[,2] <- features[,2] %>% as.character()

#subset features into those that include mean and standard deviation
#'mean' or 'std' can appear at any point in the feature name
features_keep <- grep('.*mean.*|.*std.*', features[,2])
features_keep.names <- features[features_keep,2]

#Make the variable names more readable
features_keep.names <- features_keep.names %>%
  {gsub('-mean','Mean', .)} %>% 
  {gsub('-std','Std',.)} %>%
  {gsub('[()-]', '',.)} %>%
  {gsub('^f','frequencyDomain', .)} %>%
  {gsub('^t','timeDomain',.)} %>%
  {gsub('Acc','Accelerometer',.)} %>%
  {gsub('Gyro','Gyroscope',.)} %>%
  {gsub('Mag','Magnitude',.)} %>%
  {gsub('Freq','Frequency',.)}

#load the datasets
train <- read.table('./UCI HAR Dataset//train/X_train.txt')
train <- train[,features_keep]
train_labels <- read.table('./UCI HAR Dataset/train/y_train.txt')
train_subjects <- read.table('./UCI HAR Dataset/train/subject_train.txt')
train_table <- cbind(train_subjects,train_labels,train)

test <- read.table('./UCI HAR Dataset/test/X_test.txt')
test <- test[,features_keep]
test_labels <- read.table('./UCI HAR Dataset/test/y_test.txt')
test_subjects <- read.table('./UCI HAR Dataset/test/subject_test.txt')
test_table <- cbind(test_subjects, test_labels, test)

#Merging the two tables simply requires row binding the train and test tables
all_table <- rbind(train_table, test_table)
names(all_table) <- c('subject','activity', features_keep.names)
all_table <- all_table %>% 
  mutate(activity = activitylabels[,2][activity])

#create factors where applicable
all_table$subject <- as.factor(all_table$subject)
all_table$activity <- factor(all_table$activity,
                             levels = activitylabels[,2],
                             labels = activitylabels[,2])

#create data set with average of each variable for each activity and each subject
all_table.mean <- all_table %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

#write the table to a txt file for submission
write.table(all_table.mean, 'tidy.txt', row.names = FALSE, quote = FALSE)





