#### GCD Week 3 - Lecture Notes

### Subsetting and Sorting

## Quick review on subsetting
set.seed(13435)
x <- data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
x
x <- x[sample(1:5),]; x$var2[c(1,3)] = NA
x
## just gives us first column
x[,1] 
x[, "var1"]

## subset both rows and columns
x[1:2,"var2"]

## Logicals
x[(x$var1 <= 3 & x$var3 > 11), ]
x[(x$var1 <= 3 | x$var3 > 15), ]

## Dealing with missing values
x[which(x$var2 > 8), ]

## Sorting
sort(x$var1)
sort(x$var1, decreasing = TRUE)
sort(x$var2, na.last = TRUE)

## Ordering
x[order(x$var1), ]
x[order(x$var1, x$var3), ]

## Ordering with plyr
library(plyr)
arrange(x, var1)
arrange(x, desc(var1))

## Adding rows and columns
x$var4 <- rnorm(5)
x
y <- cbind(x, rnorm(5))
y

## http://www.biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%202.pdf



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


### Creating New Variables

## Why create new variables?
# - Often, the raw data won't have a value you are looking for
# - You may need to transform the data to get the values you would like
# - Usually you will add those values to the data frames you are working with
# - Common variables to create:
#       - Missingness indicators
#       - "Cutting up" quantitative variables
#       - Applying transforms (log, exponential, etc)

## GET DATA FROM WEB (not needed - already have, good reminder)
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv", method = "curl")
restData <- read.csv("./data/restaurants.csv")

## Creating sequences
# - Sometimes you need an index for your data set
s1 <- seq(1, 10, by = 2); s1      # returns '1 3 5 7 9'
s2 <- seq(1, 10, length=3); s2    # returns '1.0 5.5 10.0'
x <- c(1,3,8,25,100)              # vector of length 5
s3 <- seq(along = x); s3          # returns '1 2 3 4 5'

## Subsetting variables
restData$nearMe <- restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)

## Creating binary variables
restData$zipWrong <- ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode < 0)

## Creating categorical variables by cutting quantitative variables into quantiles
restData$zipGroups <- cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups, restData$zipCode)
class(restData$zipGroups)                           # zipGroups now a 'factor' aka categorical variable

## Easier cutting
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode, g = 4)
table(restData$zipGroups)                           # CUTTING CREATES FACTOR VARIABLES!

## Creating factor variables
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)

## Levels of factor variables
yesno <- sample(c("yes", "no"), size = 10, replace = TRUE)
yesnofac <- factor(yesno, levels = c("yes", "no"))
relevel(yesnofac, ref = "yes")                             # returns 'yes no  yes yes no  no  yes no  no  yes'
as.numeric(yesnofac)                                       # returns ' 1  2    1   1   2   2   1  2   2    1 '

## Using the mutate function to create a new variable and simultaneously add it to a data set
library(Hmisc); library(plyr)
restData2 = mutate(restData, zipGroups=cut2(zipCode, g=4)) # new data = old data + new variable
table(restData2$zipGroups)

## Common transforms
# - abs(x)                 - absolute value
# - sqrt(x)                - square root
# - ceiling(x)             - ceiling function (round up)
# - floor(x)               - floor function (round down)
# - round(x, digits = n)   - round(3.475, 2)  retunrs 3.48
# - signif(x, digits = n)  - signif(3.475, 2) returns 3.5
# - cos(x), sin(x), etc.   - all trig in R
# - log(x)                 - natural logarithm (think ln(x))
# - log2(x), log10(x), etc - other common logatithms
# - exp(x)                 - exponentiating x (think e^(x))

## Notes and further reading
# - A tutorial from the developer of plyr - http://plyr.had.co.nz/09-user/
# - Andrew Jaffe's R notes





