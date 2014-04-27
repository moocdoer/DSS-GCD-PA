Code Book
===================================================================================================
Human Activity Recognition Using Smartphones
---------------------------------------------------------------------------------------------------

### Raw Data

The original datasets were manually download from the link <a>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>, available in the Peer Assessement page.

### Wrangling

The raw data goes through two stages:

1. An initial merged dataset of the training and test raw data is created. This merged dataset also includes a subject ID variable and an activity variable. The measurement variables include mean and standard deviation variables excluding all others. These were subsetted from the raw data by choosing the variables that had 'mean()' and 'std()' in the variable name. The column names were renamed to capitalise the words Mean and Std (standing for mean and standard deviation) and remove the paranthesis and dashes with the exception of the dash separating the axis X, Y and Z.

2. A second dataset is created from the first. This dataset has the mean of each variable, per subject and activity.

### Variables

Both datasets include the following variables:
* **subject** A integer, 1 to 30, that identifies each subject
* **activity** The activity being performed when the measures were collected
	* LAYING
	* STANDING
	* SITTING
	* WALKING
	* WALKING_DOWNSTAIRS
	* WALKING_UPSTAIRS

Read feature_info.txt in the original dataset for variable description of the measurements.