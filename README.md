Data Science Specialisation
===================================================================================================
Getting and Cleaning Data - Peer Assessment
---------------------------------------------------------------------------------------------------

This repo contains the files for Getting and Cleaning Data peer assessment.

The files are the following:
* **CodeBook.md** A code book describing the tidy_dataset.csv
* **README.md** This file
* **run_analysis.R** The R source code with the functions needed to perform the tasks

### Pre-requesites
* Pull this repo
* Make the repo's directory the working directory (setwd('path'))
* Download the datasets from <a>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>

### To create the merged dataset
* Run the command source("run_analysis.R")
* Call the function MergeDatasets()

This will create a merged_dataset.csv in the working directory.

### To create the tidy (means) dataset
* Create the merged dataset if you haven't done so already
* Call the function GetAverages()

This will create a tidy_dataset.csv in the working directory.