---
title: "CookBook"
author: "Andrew Ching"
date: "23 November, 2015"
output: html_document
---

This is a markdown file to contain the explanation and describe the embedded R code for documentation purposes

```{r, message=FALSE}

library(dplyr)
library(tidyr)

setwd("UCI HAR Dataset")
```

To set environment above, including import required packages and set the working directory
The directory default to the same as of the name after unzip of the download file


```{r, message=FALSE}
activity_label <- read.table("activity_labels.txt")
features <- read.table("features.txt")
features[2] <- lapply(features[2], as.character) 

```
To import both activity and features tables to construct the table of column names and add columns


```{r, message=FALSE}
subject_test <- read.table("test/subject_test.txt")
y_test <- read.table("test/y_test.txt")
c_y_test <- merge(y_test, activity_label, by="V1", sort = FALSE)
x_test <- read.table("test/x_test.txt")
names(x_test) <- features$V2
x_test <- cbind(c_y_test, x_test)
x_test <- cbind(subject_test, x_test)

```
To conbstruct the test data

```{r, message=FALSE}
subject_train <- read.table("train/subject_train.txt")
y_train <- read.table("train/y_train.txt")
c_y_train <- merge(y_train, activity_label, by="V1", sort = FALSE)
x_train <- read.table("train/x_train.txt")
names(x_train) <- features$V2
x_train <- cbind(c_y_train, x_train)
x_train <- cbind(subject_train, x_train)
```
To construct the train data

```{r, messsage=FALSE}
x_completed <- rbind(x_test, x_train)

names(x_completed)[c(1,3)] <- c("Subject", "Activity")

x_completed <- subset(x_completed, select = -c(V1))
```
To coalsce both the train and test data, so as to rename the column name and remove unnecessary one

```{r, message=FALSE}
x_calculated <- 
        x_completed %>% 
        gather(meter_measure_direction, value, -Subject, -Activity) %>% 
        separate(meter_measure_direction, c("meter", "measure", "direction")) %>%
        filter(measure == c("mean", "std")) %>%
        group_by(meter, measure) %>%
        summarize(meanVal = mean(value),
                  stdVal = sd(value))

        print(x_calculated)
        
```
The last session to use tidyr and dplyr to calculate via chaining

At last the message will be printed out
