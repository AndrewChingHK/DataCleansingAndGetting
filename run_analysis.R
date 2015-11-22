
#Nanme: ANdrew Ching


library(dplyr)
library(tidyr)

setwd("UCI HAR Dataset")

activity_label <- read.table("activity_labels.txt")
features <- read.table("features.txt")
features[2] <- lapply(features[2], as.character) 

subject_test <- read.table("test/subject_test.txt")
y_test <- read.table("test/y_test.txt")
c_y_test <- merge(y_test, activity_label, by="V1", sort = FALSE)
x_test <- read.table("test/x_test.txt")
names(x_test) <- features$V2
x_test <- cbind(c_y_test, x_test)
x_test <- cbind(subject_test, x_test)

subject_train <- read.table("train/subject_train.txt")
y_train <- read.table("train/y_train.txt")
c_y_train <- merge(y_train, activity_label, by="V1", sort = FALSE)
x_train <- read.table("train/x_train.txt")
names(x_train) <- features$V2
x_train <- cbind(c_y_train, x_train)
x_train <- cbind(subject_train, x_train)

x_completed <- rbind(x_test, x_train)

names(x_completed)[c(1,3)] <- c("Subject", "Activity")

x_completed <- subset(x_completed, select = -c(V1))

x_calculated <- 
        x_completed %>% 
        gather(meter_measure_direction, value, -Subject, -Activity) %>% 
        separate(meter_measure_direction, c("meter", "measure", "direction")) %>%
        filter(measure == c("mean", "std")) %>%
        group_by(meter, measure) %>%
        summarize(meanVal = mean(value),
                  stdVal = sd(value))

        print(x_calculated)

