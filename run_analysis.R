
# Setup environment -------------------------------------------------------

# load package data.table. if not installed, install it.
if (!require("data.table")) install.packages("data.table")



# Download and extract data -----------------------------------------------

dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("data.zip")) download.file(dataurl, "data.zip")

if(!dir.exists("UCI HAR Dataset")) unzip("data.zip")



# Load data -----------------------------------------------

# list of all features
features <- fread("UCI HAR Dataset/features.txt", col.names = c("num","fun"))

# link class labels to their activivty name
activity_labels <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("classlabel", "activity"))

# sets
train_set <- fread("UCI HAR Dataset/train/X_train.txt", col.names = features$fun)
test_set <- fread("UCI HAR Dataset/test/X_test.txt", col.names = features$fun)

# labels
train_labels <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "classlabel")
test_labels <- fread("UCI HAR Dataset/test/y_test.txt", col.names = "classlabel")

# subject who performed the activity
train_subject <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
test_subject <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")



# Task 1 ------------------------------------------------------------------
# Merges the training and the test sets to create one data set.

sets <- rbind(train_set, test_set)
labels <- rbind(train_labels, test_labels)
subject <- rbind(train_subject, test_subject)

merged_data <- cbind(subject, labels, sets)




# Task 2 ------------------------------------------------------------------
# Extracts only the measurements on the mean and standard deviation for each measurement.

mean_std <- merged_data[
  , 
  c("subject", "classlabel", grep("mean\\(\\)|std\\(\\)", names(merged_data), value = T)),
  with = FALSE
]



# Task 3 ------------------------------------------------------------------
# Uses descriptive activity names to name the activities in the data set.

mean_std <- merge(activity_labels, mean_std, by = "classlabel")



# Task 4 ------------------------------------------------------------------
# Appropriately labels the data set with descriptive variable names.

cols <- names(mean_std)
cols <- gsub("^t", "Time", cols)
cols <- gsub("^f", "Frequency", cols)
cols <- gsub("Acc", "Accelerometer", cols)
cols <- gsub("Gyro", "Gyroscope", cols)
cols <- gsub("Mag", "Magnitude", cols)
cols <- gsub("-mean\\(\\)", "Mean", cols)
cols <- gsub("-std\\(\\)", "STD", cols)
cols <- gsub("BodyBody", "Body", cols)

colnames(mean_std) <- cols


# Task 5 ------------------------------------------------------------------
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

# covert data.table from "wide" to "long" using melt function
tidydata <- melt(mean_std, measure.vars = 4:ncol(mean_std),
                 variable.name = "feature", value.name = "measurement")

# get the average of each feaure, activity and subject
tidydata <- tidydata[
  ,
  .("measurement" = mean(measurement)),
  by = .(classlabel, activity, subject, feature)
]


# Export data -------------------------------------------------------------

fwrite(tidydata, "tidydata.txt", sep = "\t")

