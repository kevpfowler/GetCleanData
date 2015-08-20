## run_analysis.R
##
## Performs the cleaning/tidying and analysis of the UCI HAR Dataset as
## described in the Getting and Cleaning Data course Project description.
##
## Use setwd() to set to proper directory containing the 
## "unzipped UCI HAR Dataset" directory
##
## Source this file. It will produce two data frames:
##   tidy_df: The table meeting the tidying requirements in Steps 1-4
##   mean_df: The table containing the means of all measurements for Step 5
## 
## The mean_df contains the wide format result, e.g.:
#    subject           activity timeBodyLinearMeanX timeBodyLinearMeanY timeBodyLinearMeanZ
# 1        1            WALKING           0.2773308        -0.017383819          -0.1111481
# 2        1   WALKING_UPSTAIRS           0.2554617        -0.023953149          -0.0973020
# 3        1 WALKING_DOWNSTAIRS           0.2891883        -0.009918505          -0.1075662
# 4        1            SITTING           0.2612376        -0.001308288          -0.1045442
# 5        1           STANDING           0.2789176        -0.016137590          -0.1106018
# 6        1             LAYING           0.2215982        -0.040513953          -0.1132036
# 7        2            WALKING           0.2764266        -0.018594920          -0.1055004
# 8        2   WALKING_UPSTAIRS           0.2471648        -0.021412113          -0.1525139
# ....

## Required libraries
library(dplyr)

## combine_har_datasets:
##   - Combines three related files (type = train or test) into a single data frame
##   - Returns the single combined data frame
combine_har_datasets <- function(type) {
    if (type != "train" && type != "test") {
        stop("type must be wither 'train' or 'test'")
    }
    
    ## features file (These are the labels for the 561 cols in X_*.txt datasets)
    fdata <- "UCI HAR Dataset/features.txt"   
    
    ## Read in the features file - these are the column names for the main
    ## training and testing data files
    ftbl <- read.table(fdata)
    features <- ftbl[,2]
    
    ## Define necessary dataset file names
    tdata <- paste0("UCI HAR Dataset/", type, "/X_", type, ".txt")
    sdata <- paste0("UCI HAR Dataset/", type, "/subject_", type, ".txt")
    adata <- paste0("UCI HAR Dataset/", type, "/y_", type, ".txt")
    
    ## Read in the datasets into tables
    ttbl <- read.table(tdata, col.names = features)
    stbl <- read.table(sdata, col.names = "subject")
    atbl <- read.table(adata, col.names = "activity")
    
    ## Combine the three tables
    ttbl <- cbind(stbl, atbl, ttbl) 
    
    return(ttbl)
}

## convert_har_colnames:
##   - Convert measurement variable names in the merged data frame to 
##     more descriptive/readable names
##   - Returns the converted data frane
convert_har_colnames <- function(DF) {
    DF <- DF %>% 
        # Remove the repeated word typo: BodyBody -> Body
        setNames(gsub("BodyBody", "Body", names(.))) %>%
        # Change "Acc" to "Linear"
        setNames(gsub("Acc", "Linear", names(.))) %>%
        # Change "Gyro" to "Angular"
        setNames(gsub("Gyro", "Angular", names(.))) %>%
        # Change "Mag" to "Magnitude"
        setNames(gsub("Mag", "Magnitude", names(.))) %>%
        # Change "mean" to "Mean"
        setNames(gsub("mean", "Mean", names(.))) %>%
        # Change "std" to "StdDev"
        setNames(gsub("std", "StdDev", names(.))) %>%
        # Dump those dots!
        setNames(gsub("\\.", "", names(.))) %>%
        # Change "MagnitudeMean" to "MeanMagnitude" to align with "Mean[XYZ]"
        setNames(gsub("MagnitudeMean", "MeanMagnitude", names(.))) %>%
        # Change "MagnitudeStdDev" to "StdDevMagnitude" to align with "StdDev[XYZ]"
        setNames(gsub("MagnitudeStdDev", "StdDevMagnitude", names(.))) %>%
        # Change leading "t" to "time"
        setNames(gsub("^t", "time", names(.))) %>%
        # Change leading "f" to "freq"
        setNames(gsub("^f", "freq", names(.)))
    
    return(DF)
}

## clean_har_data():
##   - Main workhorse cleaning up the data per Steps 1-4. Calls the
##     combine_har_datasets() and convert_har_columns() along the way.
##   - Returns the cleaned/tidy data.table
clean_har_data <- function() {
    ## Read in activity labels from file to a vector, for use in mutate below
    activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                                  stringsAsFactors=FALSE)[,2]
    
    ## Build the "test" data.table
    test_tbl <- combine_har_datasets("test")
    
    ## Build the "train" data.table
    train_tbl <- combine_har_datasets("train")
    
    ## Combine the training and testing tables into one data frame 
    ## (same column structure in both), and process to desired form/format
    har_tbl <- bind_rows(train_tbl, test_tbl) %>%
        
        ## Just for clarity, arrange the rows by subject and activity
        arrange(subject, activity) %>%
    
        ## Keep only the columns with mean and standard deviation measurements.
        ## Excluding the "meanFreq" columns because that isn't relevant to this
        ## analysis
        select(subject, activity, 
               contains("mean.", ignore.case=FALSE), 
               contains("std.", ignore.case=FALSE))  %>%
        
        ## Mutate the values in the activity column from integers to 
        ## descriptive labels
        mutate(activity = activity_labels[activity]) %>%
        
        ## Convert measurement variable names to more descriptive/readable names
        convert_har_colnames()

    ## Convert subject ids to factors in natural order
    har_tbl$subject <- factor(har_tbl$subject)
    ## Convert activity strings to factors in same order as activity index
    ## Is there a dplyr way to do this - don't' think so right now
    har_tbl$activity <- factor(har_tbl$activity, levels = activity_labels)
    
    ## Return the tidy dataset
    return(har_tbl)
}

## mean_har_columns():
##   - This does the Step 5 analysis of the previously cleaned/tidied dataset. 
##     Calcs the mean of every measurement column 
##     for each group of subject/activity
##   - Returns the by-group summarized mean data table.This is in wide form,
##     which makes more sense to me in the absence of any additional analysis
##     needs.
mean_har_columns <- function(DF) {
    DF <- DF %>%
        group_by(subject, activity) %>%
        ## Take mean of all measurement columns for each subject/activity group
        summarise_each(funs(mean))
    
    return(ungroup(DF))
}

## ------------------------------------------------------------------------
## These is the main part of the script"
##
## Produce the tidy dataset (Steps 1 - 4)
tidy_df <- clean_har_data()
    
## Do the grouped column means (Step 5)
mean_df <- mean_har_columns(tidy_df)

## Write both datasets to txt files
write.table(tidy_df, "tidy_har_data.txt", row.names=FALSE)
write.table(mean_df, "mean_har_data.txt", row.names= FALSE)