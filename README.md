# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `tidy_analysis.R`, does the following:

1. Load the activity labels
2. Load the features
3. Subset the features to only include those columns that deal with mean or 
   standard deviation
4. Edit variable names to make the more readable
5. Load both the train and test datasets
6. Merge the datasets
7. Transform characters into factors where applicable
8. Create the tidy dataset that includes the mean value of each
   variable for each subject and activity duple
   
The end result is saved in the 'tidy.txt' file.

