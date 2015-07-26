##Kyle Dawson
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for 
##    each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each 
##    variable for each activity and each subject

# Loads activity labels
activity_labels <- read.table("C:/Users/kyled_000/Documents/JHU Data Science/UCI HAR Dataset/activity_labels.txt")[,2]

# Loads column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extracts the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

# Processes both X_test data and y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Extracts the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]

# Loads activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Binds data from y and X tests
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Processes both X_train and y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extracts the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Loads activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Binds data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Uses dcast function to calculate mean.
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)