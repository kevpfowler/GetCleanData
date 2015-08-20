---
title: "Get-Clean-Data Project Codebook"
author: "Kevin Fowler"
date: "August 19, 2015"
output: html_document
---

## Project Description
The purpose of this project was to produce a tidy dataset from a real-world
example (messy) dataset, and then to perform a simple analysis step on the tidy data variables within a number of groups. The original dataset is a 

>"Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors."

##Study design and data processing
The Human Activity Recognition study and data set is described at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

###Collection of the raw data
The original data is located at:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The zip file is downloaded to the local working directory and unzipped, which results in 
the subdirectory *"UCI HAR Dataset"*. The R script developed to tidy and analyze
the data assumes this directory is present in the R working directory.

###Notes on the original (raw) data 
The raw data in the *UCI HAR Dataset* is spread over multiple files. The 
README.txt file provides a summary of these files and is recommended as a 
complete reference. Below, the essential files for this project are described.

At the top
level are *test* and *train* directories, which simply separated the test 
subjects to provide some data to train the machine learning algorithms and other
data to test those algorithms. This is not of interest to this project so all
the *test* and *train* data will be consolidated into a single dataset.

Within each of the *test* and *train* subdirectories are three files, each with 
the same number of rows. They constitute three parts of a single observation and
will need to be consolidated into a sinlge row of a tidy dataset:

+ subject_test.txt: These are the subject identifiers (1-30) indicating which subject was being measured during the observation

+ y_test.txt: These are the activity identifiers (1-6) each subject was performing during each observation

+ X_test.txt: These are the normalized data for the acceleration vector measurments taken during each observation

The *Inertial Signals* subdirectory in each of the *test* and *train* directories is ignored for this project.

The other raw files needed for this project are in the top-level *UCR HAR Dataset* directory. These include:

+ README.txt: Summary of the study design and raw files provided

+ activity_labels.txt: Maps the 6 activity indicies in the y_train.txt and y_test.txt files to human understandable activity terms

+ features_info.txt: Describes the 561 measurments (features) for each observation. These are both raw and derived measurements.

+ features.txt: Maps the 561 measurment indicies to technical labels

##Creating the tidy datafiles
By executing the provided R script on the raw data directory described above, two tidy datasets and datafiles are produced. The instructions for executing the script are provided next.

###Guide to create the tidy data files
1. Clone the GitHub repo to some directory. This contains the R-script run_analysis.R, and the README.md and Codebook.md files.
2. Make the cloned repo directory the working R directory using setwd() from the R console
```
    > setwd("%YourBaseDir%/GetCleanData")
```
3. Download the raw data directory by clicking on the following link and save the zip file to the working R directory
    * https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
4. Unzip the compressed file  getdata-projectfiles-UCI HAR Dataset.zip using the appropriate tools for your system/. The *UCI Har Dataset* should now be a subdirectory of the working R directory.
5. At the R console, source the run_analysis.R script:

```
    > source("run_analysis.R")
```    

###Cleaning of the data
Short, high-level description of what the cleaning script does. [link to the readme document that describes the code in greater detail]()

Produces two data sets:

+ tidy_data.txt: The results of Steps 1-4 of the project. This has 10299 observations(rows) and 68 variables(columns).

+ mean_data.txt: The results of Step5 of the project, where the mean is 
calculated for each numeric variable over each subject-activity subgroup. This
has 180 observations(rows) corresponding to the (30 subjects)x(6 activities) dimension, and 68 variables(columns)

The column names for both data sets are the same. It is implied (without eplicitly renaming the variable column names) that the mean of each numeric variable has been calculated in the summary data set.

##Description of the variables in the output files
As described above the run_analysis.R script produces two data sets and writes
them to txt files. Both have the same variable names (column names):

The first two columns are the experiment **factors**:

* subject: The subjects participating in the study, numbered 1-30

* activity: The activity each subject was performing for a given observation: one of:
    + WALKING 
    + WALKING_UPSTAIRS
    + WALKING_DOWNSTAIRS
    + SITTING
    + STANDING
    + LAYING

The remaining 66 columns are the measurements for each observation(row). The measured variables described below for each subject/activity are:

* normalized to the range[-1, 1], for their subsequent use by machine learning algorithms

* of class "numeric"

* unit-less -- ***A normalized variable has no units***. 

The measured variable column names follow a consistent camelCase format:

**domainSourceType[Jerk][Mean|StdDev][XYZ|Magnitude]**

These label parts (or fields) are each described here:

+ **domain**: Indicating *time* for time-domain or *freq* for frequency-domain measurement

+ **Source**: Indicating *Body* or *Gravity* as the source of the force producing the acceleration. *Gravity* can only generate linear acceleration, while the *Body* can generate both linear and angular(rotational) accelerations

+ **Type**: Indicating the type of acceleration as either *Linear* (measured by the accelerometer) or *Angular* (measured by the gyroscope)

+ **\[Jerk]**: Indicating whether the acceleration is normal/smooth or a sudden *Jerk*. If not a *Jerk*, then this field is missing from the column name

+ **[Mean|StdDev]**: Indicating whether this is the *Mean* or the *StdDev* (standard deviation) numerical summary of the raw acceleration data for this measurement

+ **[XYZ|Magnitude]**: Indicating whether this is a numerical summary of:
    + the measurement of a single component (*X*, *Y* or *Z*) of an acceleration vector, or
    + the measurement of the *Magnitude* of an acceleration vector  

For example:

+ *timeBodyLinearJerkStdDevY* is the standard deviation of the Y-component of the time-domain measurement of the body's linear jerk(sudden, or high frequency) acceleration vector

+ *freqBodyAngularMeanMagnitude* is the mean of the magnitude of the frequency-domain measurement of the body's angular acceleration vector.

For the sake of completeness, the complete set of variables is listed below

Column Name  |  Class  | Range
------------ | ------- | ---------------------------
subject | Factor  | 1..30
activity | Factor | WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
timeBodyLinearMeanX | numeric | [-1,1]
timeBodyLinearMeanY | numeric | [-1,1]
timeBodyLinearMeanZ | numeric | [-1,1]
timeGravityLinearMeanX | numeric | [-1,1]
timeGravityLinearMeanY | numeric | [-1,1]
timeGravityLinearMeanZ | numeric | [-1,1]
timeBodyLinearJerkMeanX | numeric | [-1,1]
timeBodyLinearJerkMeanY | numeric | [-1,1]
timeBodyLinearJerkMeanZ | numeric | [-1,1]
timeBodyAngularMeanX | numeric | [-1,1]
timeBodyAngularMeanY | numeric | [-1,1]
timeBodyAngularMeanZ | numeric | [-1,1]
timeBodyAngularJerkMeanX | numeric | [-1,1]
timeBodyAngularJerkMeanY | numeric | [-1,1]
timeBodyAngularJerkMeanZ | numeric | [-1,1]
timeBodyLinearMeanMagnitude | numeric | [-1,1]
timeGravityLinearMeanMagnitude | numeric | [-1,1]
timeBodyLinearJerkMeanMagnitude | numeric | [-1,1]
timeBodyAngularMeanMagnitude | numeric | [-1,1]
timeBodyAngularJerkMeanMagnitude | numeric | [-1,1]
freqBodyLinearMeanX | numeric | [-1,1]
freqBodyLinearMeanY | numeric | [-1,1]
freqBodyLinearMeanZ | numeric | [-1,1]
freqBodyLinearJerkMeanX | numeric | [-1,1]
freqBodyLinearJerkMeanY | numeric | [-1,1]
freqBodyLinearJerkMeanZ | numeric | [-1,1]
freqBodyAngularMeanX | numeric | [-1,1]
freqBodyAngularMeanY | numeric | [-1,1]
freqBodyAngularMeanZ | numeric | [-1,1]
freqBodyLinearMeanMagnitude | numeric | [-1,1]
freqBodyLinearJerkMeanMagnitude | numeric | [-1,1]
freqBodyAngularMeanMagnitude | numeric | [-1,1]
freqBodyAngularJerkMeanMagnitude | numeric | [-1,1]
timeBodyLinearStdDevX | numeric | [-1,1]
timeBodyLinearStdDevY | numeric | [-1,1]
timeBodyLinearStdDevZ | numeric | [-1,1]
timeGravityLinearStdDevX | numeric | [-1,1]
timeGravityLinearStdDevY | numeric | [-1,1]
timeGravityLinearStdDevZ | numeric | [-1,1]
timeBodyLinearJerkStdDevX | numeric | [-1,1]
timeBodyLinearJerkStdDevY | numeric | [-1,1]
timeBodyLinearJerkStdDevZ | numeric | [-1,1]
timeBodyAngularStdDevX | numeric | [-1,1]
timeBodyAngularStdDevY | numeric | [-1,1]
timeBodyAngularStdDevZ | numeric | [-1,1]
timeBodyAngularJerkStdDevX | numeric | [-1,1]
timeBodyAngularJerkStdDevY | numeric | [-1,1]
timeBodyAngularJerkStdDevZ | numeric | [-1,1]
timeBodyLinearStdDevMagnitude | numeric | [-1,1]
timeGravityLinearStdDevMagnitude | numeric | [-1,1]
timeBodyLinearJerkStdDevMagnitude | numeric | [-1,1]
timeBodyAngularStdDevMagnitude | numeric | [-1,1]
timeBodyAngularJerkStdDevMagnitude | numeric | [-1,1]
freqBodyLinearStdDevX | numeric | [-1,1]
freqBodyLinearStdDevY | numeric | [-1,1]
freqBodyLinearStdDevZ | numeric | [-1,1]
freqBodyLinearJerkStdDevX | numeric | [-1,1]
freqBodyLinearJerkStdDevY | numeric | [-1,1]
freqBodyLinearJerkStdDevZ | numeric | [-1,1]
freqBodyAngularStdDevX | numeric | [-1,1]
freqBodyAngularStdDevY | numeric | [-1,1]
freqBodyAngularStdDevZ | numeric | [-1,1]
freqBodyLinearStdDevMagnitude | numeric | [-1,1]
freqBodyLinearJerkStdDevMagnitude | numeric | [-1,1]
freqBodyAngularStdDevMagnitude | numeric | [-1,1]
freqBodyAngularJerkStdDevMagnitude | numeric | [-1,1]

##Sources
>Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 
