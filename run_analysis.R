# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

ReadFromFile = function(x) {
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
	activities = rbind(dataframes$activities.test , dataframes$activities.train)
	activities = dataframes$activity.names[activities[,1], 2]
	# Merge and name feature columns
	features = rbind(dataframes$features.test, dataframes$features.train)
	colnames(features) = dataframes$features.names[,2]
	# Merge subjects IDs
	subjects = rbind(dataframes$subjects.test, dataframes$subjects.train)
	colnames(subjects) = 'subject'
	# Create the merged dataset
	merged.df = data.frame(
		subject = subjects,
		activity = activities,
		features
	)
	# Writes the CSV file
	write.csv(merged.df, 'merged_dataset.csv', row.names = FALSE)
}

GetAverages = function(){
	# Loads the dataset
	ds = read.csv('merged_dataset.csv', stringsAsFactors = FALSE)
	# Create an index of columns to keep and subsets the data set with it
	i = c(1, 2, grep('mean()', colnames(ds)), grep('std()', colnames(ds)))
	ds = ds[,i]
	# Create the averages dataframe
	averages = data.frame()
	for(subject in unique(ds$subject)){
		for(activity in unique(ds$activity[ds$subject == subject])){
			averages = rbind(
 				averages,
 				data.frame(
 					subject = subject,
 					activity = activity,
 					colMeans(ds[ds$subject == subject & ds$activity == activity, -c(1,2)])
 				)
 			)
		}
	}
	return(averages)
}

# 