# NOTE:
# This script assumes that all necessary files 
# - activity_labels.txt
# - features.txt
# - /test/X_test.txt, Y_test.txt, subject_test.txt
# - /train/X_train.txt, Y_train.txt, subject_train.txt
# are in the same folder as the script.

# ---- Import training data and merge into a single data.frame ---- 
# Import training measurements into a data.frame
x_data = read.table("train/X_train.txt")
# Import training activity IDs into a data.frame
y_data = read.table("train/Y_train.txt")
# Import training subject IDs into a data.frame
subj_data = read.table("train/subject_train.txt")

# Merge the 3 training data.frames into a new variable
train_data <- x_data
# Append the subjects IDs to the training data frame 
# and name the column accordingly
train_data <- cbind(train_data, subj_data)
colnames(train_data)[562] = "Subject"
# Append the activity index to the training data frame
# and name the column accordingly
train_data <- cbind(train_data, y_data)
colnames(train_data)[563] = "Activity"

# ---- import testing data and merge into a single data.frame ---- 
# Import test measurements in a data.frame
x_data = read.table("test/X_test.txt")
# import test activity IDs into a data.frame
y_data = read.table("test/Y_test.txt")
# Import test subject IDs into a data.frame
subj_data = read.table("test/subject_test.txt")

# Merge the 3 test data.frames into a new variable
test_data <- x_data
# Append the subjects IDs to the test data.frame
# and name it accordingly
test_data <- cbind(test_data, subj_data)
colnames(test_data)[562] = "Subject"
# Append the activity IDs to the test data.frame
# and name it accordingly
test_data <- cbind(test_data, y_data)
colnames(test_data)[563] = "Activity"

# ---- Merge train_data & test_data data.frames ----
merged_data <- rbind(train_data, test_data)
# ------------------------------------ end of task 1

# ---- Extracting the mean and std columns ----
# Getting the list of measurements names from "features.txt"
column_names <- read.table("features.txt")
column_names <- as.vector(column_names$V2)
# Add the Subject and Activity to the original list, 
# in order to match the number of columns in the merged_data variable
column_names <- append(column_names, "Subject")
column_names <- append(column_names, "Activity")
# Make the column names more readable by removing the parantheses
column_names <- gsub("\\(\\)", "", column_names)

# Set column names to merged_data data frame based on the column names in features.txt file
colnames(merged_data) <- column_names
# ------------------------------------------------------- end of task 4

# Extract only the column names with mean or std in their name 
# from the column_name vector and the "Subject" and "Activity" column.
# When selecting the column names containing "mean", do not
# include the ones that contain "meanFreq".
column_names <- (column_names[(grepl("mean()",column_names) 
                               != grepl("meanFreq()", column_names)
                               | grepl("std()",column_names) 
                               | grepl("Subject",column_names) 
                               | grepl("Activity",column_names)
                               ) == TRUE])

# Extract only columns in "column_names" vector from "merged_data"
mean_std_measurments <- merged_data[,column_names]
# ----------------------------------------------------- end of task 2

# Read activity labels and extract activity labels names.
activity_labels <- read.table("activity_labels.txt")
activity_labels <- as.vector(activity_labels$V2)

# Add a column named Activity.Label to the "mean_std_measurments" 
# containing the activity names.
# Use the Activity column in "mean_std_measurments" and 
# the activity_label's vector index in order to match the activities.
mean_std_measurments <- mutate(mean_std_measurments, Activity.Labels=activity_labels[Activity])
# ---------------------------------------------------- end of task 3

# Use ddply to group columns by Subject and Activity, 
# and use numcolwise to apply mean on the columns
tidy_data <- ddply(mean_std_measurments, .(Subject, Activity), numcolwise(mean))
# Add back the Activity lables
tidy_data <- mutate(tidy_data, Activity.Labels=activity_labels[Activity])
# ---------------------------------------------------- end of task 5
