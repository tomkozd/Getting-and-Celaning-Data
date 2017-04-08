library(plyr)

# Step 1
# Downloading, unzipping and merging the training and test sets to create one data set
###############################################################################

# checking if /data directory exists, if not then create and download file to /data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# unziping dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# reading train tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# reading test tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

# Step 2
# Extracting only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table('./data/UCI HAR Dataset/features.txt')

# getting only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subsetting the desired columns
x_data <- x_data[, mean_and_std_features]

# correcting the column names
names(x_data) <- features[mean_and_std_features, 2]

# Step 3
# Using descriptive activity names to name the activities in the data set
###############################################################################

# reading activity labels:
activities <- read.table('./data/UCI HAR Dataset/activity_labels.txt')

# updating values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correcting column name
names(y_data) <- "activity"

# Step 4
# Appropriately labeling the data set with descriptive variable names
###############################################################################

# correcting column name
names(subject_data) <- "subject"

# merging all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# Step 5
# Creating a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
tidy <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy, "tidy.txt", row.name=FALSE)