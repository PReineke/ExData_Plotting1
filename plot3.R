####################################################
## Loading libraries, Loading data
####################################################
# preparing environment
remove(list = ls()); options(max.print=20000)

# loading libraries
library(lubridate)

# downloading dataset unless it's already present
if (!file.exists("household_power_consumption.txt")) {
        file_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(file_URL, destfile= "exdata-data-household_power_consumption.zip", method = "curl")
        unzip("exdata-data-household_power_consumption.zip")
        sink("Source Data Download Date.txt")
        paste("Source data downloaded on:" ,as.character(now()), "from:", file_URL)
        sink()
        rm(file_URL)
}

# loading data
data <- read.csv("household_power_consumption.txt", sep = ";", header = TRUE)

####################################################
## Preparing data
####################################################
# creating single time column
data$DateTime <- paste(data$Date, data$Time)

# converting date data into date format
data$DateTime <- dmy_hms(data$DateTime)

# subsetting dataset
data <- data[data$DateTime >= ymd_hms("2007-02-01 00:00:00") & data$DateTime < ymd_hms("2007-02-03 00:00:00"),]

# deleting obselete columns
data$Date <- data$Time <- NULL

# creating weekday columns
data$Weekday <- wday(data$DateTime)

# converting columns to numberic
columns <- colnames(data)[!(colnames(data) %in% "DateTime")]
data[,columns] <- lapply(data[,columns], function(x) as.numeric(as.character(x))); rm(columns)

####################################################
## Creating plots
####################################################
# Plot 3
png(filename = "plot3.png", width = 480, height = 480, units = "px")
with(data, {plot(DateTime, Sub_metering_1, 
                 type="n", 
                 xlab = "",
                 ylab="Energy sub metering")
            lines(DateTime, Sub_metering_1, type = "l", col = "black")
            lines(DateTime, Sub_metering_2, type = "l", col = "red")
            lines(DateTime, Sub_metering_3, type = "l", col = "blue")
            legend("topright",
                   c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
                   lty = c(1,1,1),
                   col=c('black','red','blue'))
})
dev.off()