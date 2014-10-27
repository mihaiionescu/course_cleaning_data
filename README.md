course_cleaning_data
====================

This repo consists of 2 files

- codebook.md - The code book describing the variables of the output file.
- course_script.R - the script for generating the output file.

The `course_script.R` script assumes that all necessary files

- activity_labels.txt
- features.txt
- /test/X_test.txt, Y_test.txt, subject_test.txt
- /train/X_train.txt, Y_train.txt, subject_train.txt

are in the same folder as the script.


In RStudio run:

`source("course_project.R")`

This command will go through the steps of 

- merging the train and test data
- apply labels to the data set, using the contents of the `features.txt` file
- extracting the mean and stardard deviation measurements
- add another column with the associated activity label
- group the data by subject ID and activity ID and calculate the mean for each group of measurements

The final data is stored in the `tidy_data` variable.

In order to write the data to an output file, use:
`write.table(tidy_data, "output_file_name.txt", row.name=FALSE)`

In order to load a data file:
`data <- read.table("output_file_name.txt", header = TRUE)`

In order to view the data:
`View(data)`
