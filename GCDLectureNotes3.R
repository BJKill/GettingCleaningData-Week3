#### GCD Week 3 - Lecture Notes

### Subsetting and Sorting

## Quick review on subsetting
set.seed(13435)
x <- data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
x
x <- x[sample(1:5),]; x$var2[c(1,3)] = NA
x
# just gives us first column
x[,1] 
x[, "var1"]
# subset both rows and columns
x[1:2,"var2"]

# Logicals
x[(x$var1 <= 3 & x$var3 > 11), ]
x[(x$var1 <= 3 | x$var3 > 15), ]

# Dealing with missing values
x[which(x$var2 > 8), ]

# Sorting
sort(x$var1)
sort(x$var1, decreasing = TRUE)
sort(x$var2, na.last = TRUE)

# Ordering
x[order(x$var1), ]
x[order(x$var1, x$var3), ]

# Ordering with plyr
library(plyr)
arrange(x, var1)
arrange(x, desc(var1))

# Adding rows and columns
x$var4 <- rnorm(5)
x
y <- cbind(x, rnorm(5))
y

# http://www.biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%202.pdf



### Summarizing data

## Example data set: https://data.baltimorecity.gov/Community/Restaurants/k5ry-ef3g

## Getting data from the web
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv", method = "curl")
restData <- read.csv("./data/restaurants.csv")

## Look at a bit of the data
head(restData)
tail(restData, n = 3)

## Make summary
summary(restData)

## More in depth information
str (restData)

## Quantiles or percentiles of quantitative variables
quantile(restData$councilDistrict, na.rm = TRUE)
quantile(restData$councilDistrict, probs = c(0.5, 0.75, 0.9), na.rm = TRUE)

## Make Table
table(restData$zipCode, useNA = "ifany") # make sure to use 'useNa="ifany"'!!!
table(restData$councilDistrict, restData$zipCode)

## Check for missing values
sum(is.na(restData$councilDistrict))  # returns number of missing values
any(is.na(restData$councilDistrict))  # returns TRUE if any value is NA
all(restData$zipCode > 0)             # returns TRUE if all values pass logical test

## Row and column sums
colSums(is.na(restData))

## [[MY CODE]] TO SHRINK UPDATED DATA TABLE TO ORIGINAL SIZE IN LECUTRE
restData <- restData[,1:6]
head(restData,3)

## Values with specific characteristics within datasets
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212", "21213"))
restData[restData$zipCode %in% c("21212", "21213"), ]

## Cross tabulations
data("UCBAdmissions")
DF = as.data.frame(UCBAdmissions)
summary(DF)
xt <- xtabs(Freq ~ Gender + Admit, data = DF)  # makes a 2x2 table (cross tab) of admitted or rejected by gender
xt

## Flat tables aka cross tab for larger number of variables.
head(warpbreaks, 10)
warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~., data = warpbreaks)
xt
summary(warpbreaks$breaks)
ftable(xt) # much easier to look at, but must occur after xtab




