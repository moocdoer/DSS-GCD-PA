# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

require('plyr')

ReadFromFile = function(x) {
	# Check if pre-reqs are met
	if(!file.exists(x)) {
		cat(x, 'not found! Aborting!\n')
	} else {
		cat('Loading', x, '\n')
	}
	# Creates a dataframe from the txt file
	df = read.table(
		file = x,
		header = FALSE,
		blank.lines.skip = TRUE,
		stringsAsFactors = FALSE
	)
	# Returns the dataframe
	return(df)
}

MergeDatasets = function() {
	# Check if all requesites are met
	if(!file.exists('UCI HAR Dataset/')){
		stop('UCI HAR Dataset directory must exist in the working directory.')
	} else {
		cat('Merging training and test data sets.\n')
	}
	# List of all files to be wrangled
	files = list(
		activity.names = 'UCI HAR Dataset/activity_labels.txt',
		activities.test = 'UCI HAR Dataset/test/y_test.txt',
		activities.train = 'UCI HAR Dataset/train/y_train.txt',
		features.names = 'UCI HAR Dataset/features.txt',
		features.test = 'UCI HAR Dataset/test/X_test.txt',
		features.train = 'UCI HAR Dataset/train/X_train.txt',
		subjects.test = 'UCI HAR Dataset/test/subject_test.txt',
		subjects.train = 'UCI HAR Dataset/train/subject_train.txt'
	)
	# Get dataframes for each file
	dataframes = lapply(files, ReadFromFile)
	# Merge and label activity names
	cat('Merge and label activities...\n')
	activities = rbind(dataframes$activities.test , dataframes$activities.train)
	activities = dataframes$activity.names[activities[,1], 2]
	# Merge and name feature columns
	cat('Merge and name features...\n')
	features = rbind(dataframes$features.test, dataframes$features.train)
	colnames(features) = dataframes$features.names[,2]
	# Merge subjects IDs
	cat('Merge subject IDs...\n')
	subjects = rbind(dataframes$subjects.test, dataframes$subjects.train)
	# Create the merged dataset
	cat('Create data frame...\n')
	merged.df = data.frame(
		subject = subjects,
		activity = activities,
		features
	)
	# Rename the columns
	# -- !! For some reason 'subject' isn't saved. This section avoids it. !! -- #
	cat('Rename the columns...\n')
	names = c('subject', 'activity', dataframes$features.names[,2])
	colnames(merged.df) = names
	# Extracts the mean and standard deviation from each measurement
	index = c(1, 2, grep('mean()', colnames(merged.df)), grep('std()', colnames(merged.df)))
	merged.df = merged.df[,index]
	# Make names pretty
	colnames(merged.df) = gsub('\\-std', 'Std', colnames(merged.df))
	colnames(merged.df) = gsub('\\-mean', 'Mean', colnames(merged.df))
	colnames(merged.df) = gsub('\\(\\)', '', colnames(merged.df))
	# Writes the CSV file
	cat('Save CSV file...\n')
	write.csv(merged.df, 'merged_dataset.csv', row.names = FALSE)
	cat('Finished merging datasets!\n')
}

GetAverages = function(){
	# Loads the dataset
	if(!file.exists('merged_dataset.csv')){
		stop('merged_dataset.csv does not exist.\nCall MergeDatasets() to create it.')
	} else {
		cat('Load merged dataset CSV...\n')
	}
	merged.df = read.csv('merged_dataset.csv', stringsAsFactors = FALSE)
	# Create the tidy data frame with the means of the numeric variables
	cat('Creating tidy dataset...\n')
	tidy.df = ddply(merged.df, .(subject, activity), numcolwise(mean))
	# Write the CSV file
	cat('Save CSV file...\n')
	write.csv(tidy.df, 'tidy_dataset.csv', row.names = FALSE)
}