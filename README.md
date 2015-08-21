---
title: "README.md"
author: "Kevin Fowler"
date: "August 21, 2015"
output:
    html_document:
        toc: true
---

## Project Description
The purpose of this project was to produce a tidy dataset from a real-world
example (messy) dataset, and then to perform a simple analysis step on the tidy data variables within a number of groups. The original dataset is from a wearables technology study:
```
"Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors."
```
The required steps in this project are:
```
You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```

This README describes the run_analysis.R script.

## R Script Design Objectives
The run_analysis.R script was developed based on the following design criteria. These were not required for the project; rather, they were chosen based on both personal interest and while iterating through various approaches:

* Use only the dplyr (and System) library functions to tidy/analyze the data
* Use chaining wherever possible to make the code readable
* Encapsulate all the behavior in functions to make the main part of the script as simple as possible and to allow reuse
    * Make the new functions support the %>% chaining capability of dplyr functions
* Use the same column headers in both the tidied data set and the analyzed dataset
    * Simpler for reader/reviewer to understand
* Make the column naming format consistent across all variables

##R Script Overview
The run_analysis.R script contains several functions. The main part of the script calls one function that returns the tidy dataset (per Steps 1-4), and then a second function that takes the tidy dataset and returns the analyzed dataset (per Step 5).

The function that returns the tidy dataset calls two other functions defined in this script file: one to combine the three files in the train and test subdirectories (this function is called twice) and one to convert the selected column's names to a consistent and tidy format.

The other functions called are either functions from System libraries (paste0, read.table, cbind, factor, gsub, setNames, names) or dplyr library functions (bind_rows, arrange, select, mutate, group_by, summarise_each, %>%). 

###Description of added functions
This describes at a high level the functions defined in the run_analysis R script

* clean_har_data():
    + Main workhorse cleaning up the data per Steps 1-4. 
    + Calls the combine_har_datasets() function for each of *train* and *test* 
    + Binds the combined *train* and *test* data frames into one 
    + Chains several functions to clean/tidy the dataframe, including:
        + arrange(), select(), mutate() dplyr functions
        + convert_har_columns() function to rename the columns
    + Returns the cleaned/tidy data.table

* combine_har_datasets(type):
    + **type** = *train* or *test*
    + Combines into a single data frame the following three related files:
        + X_***type***.txt
        + subject_***type***.txt
        + y_***type***.txt
    + Returns the single combined data frame

* convert_har_colnames(DF):
    + Convert measurement variable names in the merged data frame to more descriptive/readable names
    + Uses chained set of setNames(gsub(..)) function calls
    + Returns the converted data frame

* mean_har_columns(DF):
    * This does the Step 5 analysis of the previously cleaned/tidied dataset. 
    * Calcs the mean of every measurement column for each group of subject/activity
        + Uses chained group_by() and summarize() function calls
    * Returns the by-group mean-summary data table.
        + This is in wide form, which makes more sense to me in the absence of any additional analysis needs.

The "main" part of the R script is then simply the following:
```
## Produce the tidy dataset (Steps 1 - 4)
tidy_df <- clean_har_data()
    
## Do the grouped column means (Step 5)
mean_df <- mean_har_columns(tidy_df)

## Write both datasets to txt files
write.table(tidy_df, "tidy_har_data.txt", row.names=FALSE)
write.table(mean_df, "mean_har_data.txt", row.names= FALSE)
```

##R Script Output
The script generates two data.frame objects:

* tidy_df:  this is the tidy dataset satisfying Project Steps 1-4. Because of the use of the dplyr library, this has a class of: 
```
    [1] "tbl_df"     "tbl"        "data.frame"
```
The tidy_df object has 10299 rows and 68 columns. 

* mean_df:  this is the grouped mean dataset satisfying Project Step 5. Because of the use of the dplyr library, this also has a class of: 
```
    [1] "tbl_df"     "tbl"        "data.frame"
```
The mean_df object has 180 rows and 68 columns. 

Both objects have the same set of columns and column names. 

The script also writes both objects to txt files:

* tidy_df -->  "./tidy_har_data.txt"
* mean_df -->  "./mean_har_data.txt"

This is done both to allow the mean_har_data.txt file to be submitted as part of the assignment, and for completeness.

###Data frame table format
The script produces datasets in the "wide" format, ordered by subject and then activity.
For example, the first few rows of the mean_df data frame object are (only the first few variable columns are shown):
```
> head(mean_df, 10)
Source: local data frame [10 x 68]

   subject           activity timeBodyLinearMeanX timeBodyLinearMeanY timeBodyLinearMeanZ
1        1            WALKING           0.2773308        -0.017383819          -0.1111481
2        1   WALKING_UPSTAIRS           0.2554617        -0.023953149          -0.0973020
3        1 WALKING_DOWNSTAIRS           0.2891883        -0.009918505          -0.1075662
4        1            SITTING           0.2612376        -0.001308288          -0.1045442
5        1           STANDING           0.2789176        -0.016137590          -0.1106018
6        1             LAYING           0.2215982        -0.040513953          -0.1132036
7        2            WALKING           0.2764266        -0.018594920          -0.1055004
8        2   WALKING_UPSTAIRS           0.2471648        -0.021412113          -0.1525139
9        2 WALKING_DOWNSTAIRS           0.2776153        -0.022661416          -0.1168129
10       2            SITTING           0.2770874        -0.015687994          -0.1092183
...
```