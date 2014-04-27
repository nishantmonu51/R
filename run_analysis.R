# Download the file and extract it to your R working Directory
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# read data set X
training <- read.table("UCI HAR Dataset/train/X_train.txt")
test <- read.table("UCI HAR Dataset/test/X_test.txt")
# merge Data set X
XCombined <- rbind(training, test)

# read data set subject
training <- read.table("UCI HAR Dataset/train/subject_train.txt")
test <- read.table("UCI HAR Dataset/test/subject_test.txt")
# merge data set X
SCombined <- rbind(training, test )

# read data set Y
training <- read.table("UCI HAR Dataset/train/y_train.txt")
test <- read.table("UCI HAR Dataset/test/y_test.txt")
# merge data set Y
YCombined <- rbind(training, test)

# Extract mean and standard deviation for each measurement
features <- read.table("UCI HAR Dataset/features.txt")
colsNeeded <- grep(".*mean\\(\\)|.*std\\(\\)", features$MeasureName)
XCombined <- XCombined[,colsNeeded]

#Add descriptive activity names to name the activityLabels in the data set
names(YCombined) <- "activity"
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[, 2] = gsub("_", "", tolower(as.character(activityLabels[, 2])))
YCombined[,1] = activityLabels[YCombined[,1], 2]

names(SCombined) <- "subject"
merged <- cbind(SCombined, YCombined, XCombined)
write.table(merged, "merged-data.txt")

# make averages data set

uniqueSubjects <- unique(SCombined)[,1] 
numCols <- dim(merged)[2]
result <- merged[1:(length(unique(SCombined)[,1])*length(activityLabels[,1])), ]

row = 1
for (sub in 1:length(unique(SCombined)[,1])) {
  for (act in 1:length(activityLabels[,1])) {
    result[row, 1] = uniqueSubjects[sub]
    result[row, 2] = activityLabels[act, 2]
    tmp <- merged[merged$subject==sub & merged$activity==activityLabels[act, 2], ]
    result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
    row = row+1
  }
}
write.table(result, "averages.txt")