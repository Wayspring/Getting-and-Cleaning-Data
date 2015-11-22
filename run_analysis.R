setwd("~/Samsung/UCI HAR Dataset")
getwd()
#[1] "C:/Users/SPRINGLE FAMILY/Documents/Samsung/UCI HAR Dataset"
## Create one R script run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set. 
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
if (!require("data.table"))
     data.table
if (!require("reshape2"))
     reshape2
require("data.table")
require("reshape2")

# load: activity labels
activity_labels <- read.table("~/Samsung/UCI HAR Dataset/activity_labels.txt")[,2]
# load: data column names
features <- read.table("~/Samsung/UCI HAR Dataset/features.txt")[,2]
# Extract only the mean and standard deviation for each measurement.
 extract_features <- grepl("mean|std", features)
 
# load and process x_test & y_test data.
x_test <- read.table("~/Samsung/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("~/Samsung/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("~/Samsung/UCI HAR Dataset/test/subject_test.txt")
names(x_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
x_test = x_test[,extract_features]
 
# load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
 
# Bind data
test_data <- cbind(as.data.table(subject_test), y_test, x_test)
 
#load and process x_train & y_train data.
x_train <- read.table("~/Samsung/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("~/Samsung/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("~/Samsung/UCI HAR Dataset/train/subject_train.txt")
names(x_train) = features
# load activity data
# Extract only the measurements on the mean and standard deviation for each measurement.
x_train = x_train[,extract_features]
 
# load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Labels")
names(subject_train) = "subject"
 
# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, x_train)
 
# Merge test and train data

data = rbind(test_data, train_data, fill=TRUE)
 
id_labels  = c("subject", "Activity_ID", "Activity_label")
data_labels = setdiff(colnames(data), id_labels)
melt_data   = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to data set using dcast function
tidy_data  = dcast(melt_data, subject + Activity_label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")


  