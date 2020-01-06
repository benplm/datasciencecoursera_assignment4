# About this code book

This code book describe the content of the script run_analysis.R and the output tidydata.txt


# Code description

The code performs the following tasks:

1. load required packages, and install them if not already installed.

2. if not present in the working directory, download compressed data. If not already extracted, extract data.

3. load all relevant data in data tables using `fread()` function and assigning appropriate column names.

4. Merges the training and the test sets to create one data set.

5. Extracts only the measurements on the mean and standard deviation for each measurement.

6. Add descriptive activity names to name the activities in the data set.

7. Appropriately labels the data set with descriptive variable names, using `gsub()` function to replace regex patterns of strings.

8. Create a second data table from the previous one, convert it from *wide* to *long* format using data.table's `melt()` function and report only the average for each subject, activity and function using built-in data.table syntax.

9. Export the data table obtained in step 8 in a tab-separated text file named *tidydata.txt*


# Description of tidydata.txt

The table contains a summary (i.e. average values) of means and standard devaitions measurements
from the dataset [*Human Activity Recognition Using Smartphones Data Set*](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## 1. classlabel
This variable contains an integer identifier for the kind of activity that has been measured.

## 2. activtiy
This variable contains a descriptive name for the measured activity.

## 3. subject
An integer identifier for the human subject of the experiment.

## 4. feature
The measured feature.  
Features identify either *time* or *frequency* domain signals, with the prefix **TimeBody**
or **FrequencyBody**, respectively.  
The instrument used for the measurement is reported right after the prefix, and can be
one of **Accelerometer**, **Gyroscope** or **Magnitude**.  
The value represent the mean or the standard deviations, reported as **Mean** or **STD**,
respectively.  
Lastly, a suffix denoting the direction is reported with an hyphen followed by **X**, **Y** or **Z**.

## 5. measurement
Average of numeric values obtained from multiple measurements of the reported feature, activity and subject.

