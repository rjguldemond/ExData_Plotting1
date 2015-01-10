## Load libraries
library(data.table)
library(lubridate)

## Options
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
dataDir <- "./data"
zipFile <- file.path(dataDir, "household_power_consumption.zip")
txtFile <- file.path(dataDir, "household_power_consumption.txt")
pngFile <- "plot3.png"
Sys.setlocale("LC_TIME", "English")

## Download and unzip datafile
if(!file.exists(dataDir)) dir.create(dataDir)
if(!file.exists(zipFile)) download.file(fileUrl, destfile=zipFile)
if(!file.exists(txtFile)) unzip(zipFile, exdir=dataDir)

## Read the datafile
# suppress warnings in fread (some issues with na.strings = "?")
suppressWarnings(data <- fread(txtFile, na.strings = "?"))

# Only use data of the days 1/2/2007 and 2/2/2007 
data <- data[Date %in% c("1/2/2007", "2/2/2007")]
data[,DateTime := dmy_hms(paste(Date, Time))]               # Convert Date to class Date
data[,3:9] <- data[,lapply(.SD,as.numeric),.SDcols=3:9]     # Convert col 3:9 to numeric

## Save plot to PNG file with size 480x480
png(pngFile, width = 480, height = 480)

# Create plot
plot(data$DateTime, data$Sub_metering_1, col="black",
     xlab="",
     ylab="Energy sub metering",
     type="l")
lines(data$DateTime, data$Sub_metering_2, col="red")
lines(data$DateTime, data$Sub_metering_3, col="blue")
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"),
       lty="solid")

# close device to save png
dev.off()
