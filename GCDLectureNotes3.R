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





### Reshaping Data

## The goal is tidy data
# 1. Each variable forms a column
# 2. Each observation forms a row
# 3. Each table/file stores data about one kind of observation (e.g. people/hospitals)
# - http://vita.had.co.nz/papers/tidy-data.pdf
# - Leek, Taub, and Pineda 2011 PLoS One


## Start with reshaping
library(reshape2)
head(mtcars)


## Melting data frames
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp")) #identify ID vars vs measure vars
head(carMelt, 3)
tail(carMelt, 3)


## Casting data frames aka resummarize and reorganize in different ways
cylData <- dcast(carMelt, cyl ~ variable) # see cyl broken down by variable (mpg, hp), so only 3 columns
cylData
cylData <- dcast(carMelt, cyl ~ variable, mean) # see list of cyl vals (4,6,8) + mean mpg and hp for each (3x3 table)
cylData


## Summing/Averaging values with tapply
head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray, sum) # sums counts over different sprays
# read as "apply to 'count' along the index 'spray' the function 'sum'"
# returns vector '  A   B   C   D   E   F 
#                 174 184  25  59  42 200 '
# I suppose we could average by using mean command?
tapply(InsectSprays$count,InsectSprays$spray, mean) # my code, and worked
# returns vector '        A         B         C         D         E         F 
#                 14.500000 15.333333  2.083333  4.916667  3.500000 16.666667 '


## Another way - split first, then sum/mean w/ sapply
spIns = split(InsectSprays$count, InsectSprays$spray) # split InsectSprays into lists of counts for each spray
spIns
sapply(spIns, sum)   # returns same vector

## Another way still - split first, then lapply, then unlist
spIns = split(InsectSprays$count, InsectSprays$spray) # split InsectSprays into lists of counts for each spray
spIns
sprCount = lapply(spIns, sum) # applies sum to each list in spIns, now have a list of sums. may want vector later
sprCount
unlist(sprCount)              # turns list into vector


## Another way even still - plyr package
ddply(InsectSprays, .(spray), summarize, sum=sum(count)) # use .() for variable of interest
# dataset? InsSp, VoI? spray,  do what? summarize, how so? provide sum.

## Creating a new variable
spraySums <- ddply(InsectSprays, .(spray), summarize, sum=ave(count, FUN=sum)) 
dim(spraySums) # returns 72x2...same # rows as original
head(spraySums, 3) # displays sum of 174 next to every A
tail(spraySums, 3) # displays sum of 200 next to every F
# So, we created a new variable called 'sum' that showed the sum of each spray type for every spray type
# Can be added to a data set for analysis

## More information
# - A tutorial from the developer of plyr - http://plyr.had.co.nz/09-user/
# - A nice reshape tutorial - http://www.slideshare.net/jeffreybreen/reshaping-data-in-r
# - A good plyr primer - http://www.r-bloggers.com/a-quick-primer-on-split-apply-combine-problems/
# - See also the functions
#       - acast - for casting as multi-dimensional arrays
#       - arrange - for faster reordering without using order() commands
#       - mutate - adding new variables





### dplyr - for dataframes
# The data frame is a key data structure in statistics and in R.
# - There is only one observation per row
# - Each column represenets a variable or measure or characteristic
# - Primary implementation that you will use is the default R implementation
# - Other implementations, particularly relational databases systems

## dplyr
# - Developed by Hadley Wickham of RStudio
# - An optimized and distilled version of plyr package (also by Hadley)
# - Does not provide any "new functionality per se, but **greatly** simplifies existing functionality in R
# - Provides a "grammar" (in particular, verbs) for data manipulation
# - Is **very** fast, as many key operations are coded in C++

## dplyr verbs
# - select: return a subset of the columns of a data frame
# - filter: extract a subset of rows from a data frome based on logical conditions
# - arrange: reoder rows of a data frame
# - rename: rename variables in a data frame
# - mutate: add new variables/columns or transform existing variables
# - summarise/summarize: generate summary statistics of different variables in the data frame, possibly within strata
# - There is also a handy print method that prevents you from printing a lot of data to the consol.

## dplyr Properties
# - The first argument is a data frame
# - The subsequent arguments describe what to do with it, and you can refer to columns in the data frame directly without
#       using the '$' operator (just use the names)
# - The result is a new data frame
# - Data frames must be properly formatted and annotated for this all to be useful



### Managing Data Frames with dplyr - Basic Tools
library(dplyr)
fileUrl <- "https://github.com/DataScienceSpecialization/courses/blob/master/03_GettingData/dplyr/chicago.rds?raw=true"
download.file(fileUrl, destfile = "./data/chicago.rds", mode = "wb")
chicago <- readRDS("./data/chicago.rds")
dim(chicago)
str(chicago)
names(chicago)

## select function
head(select(chicago, city:dptp))     # leaves you with all cols b/w city and dptp, inclusive
head(select(chicago, -(city:dptp)))  # leaves you with all cols EXCEPT those between city and dptp, inclusive
## do last step without dplyr select function:
i <- match("city", names(chicago))   # finds the indicator of the position (col num) of "city"
j <- match("dptp", names(chicago))   # finds the indicator of the position (col num) of "dptp"
head(chicago[, -(i:j)])

## filter function
chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f, 10)
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(chic.f, 10)

## arrange function - reorders rows based on values of column
chicago <- arrange(chicago, date)
head(chicago)
tail(chicago)
chicago <- arrange(chicago, desc(date)) # descending order by date
head(chicago)
tail(chicago)

## rename function - a surprisingly hard and annoying thing to do in R if you don't have a function
chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
head(chicago)

## mutate function - add new variables to data sets
chicago <- mutate(chicago, pm25detrend = pm25-mean(pm25, na.rm = TRUE))
head(select(chicago, pm25, pm25detrend))

## group_by function - split a data frame behind the scenes by different categorical variable
chicago <- mutate(chicago, tempcat = factor(1*(tmpd > 80), labels = c("cold", "hot")))
hotcold <- group_by(chicago, tempcat)
hotcold
summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
summarize(hotcold, meanpm25 = mean(pm25, na.rm = TRUE), maxo3 = max(o3tmean2), medno2 = median(no2tmean2))  # my version
## group by years
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago, year)
summarize(years, avgpm25 = mean(pm25, na.rm = T), maxo3 = max(o3tmean2), medno2 = median(no2tmean2))


## special operator to chain operations together in a way to see what ops are happening in a readable way
# Called 'pipeline' operator - 'percent, greater than, percent'
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarize(avgpm25 = mean(pm25, na.rm = T),
        max03 = max(o3tmean2), medno2 = median(no2tmean2))

## dplyr
# - Once you learn the dplyr "grammar" there are a few additional benefits
#       - dplyr can work with other data frame "backends"
#       - data.table for large, fast tables
#       - SQL interface for relational databases via the DBI package



### Merging Data

## Peer review experiment data
# http://www.plosone.org/article/info:doi/10.1371/journal.pone.0026895

fileUrl1 <- "https://raw.githubusercontent.com/DataScienceSpecialization/courses/master/03_GettingData/03_05_mergingData/data/reviews.csv"
fileUrl2 <- "https://raw.githubusercontent.com/DataScienceSpecialization/courses/master/03_GettingData/03_05_mergingData/data/solutions.csv"
download.file(fileUrl1, destfile = "./data/reviews.csv", method = "curl")
download.file(fileUrl2, destfile = "./data/solutions.csv", method = "curl")
reviews <- read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews, 3)
head(reviews, 10)
head(solutions, 10)

## Merging data - merge()
# - Merges data frames
# - Important parameters: x, y, by, by.x, by.y, all
names(reviews)
names(solutions)

mergedData <- merge(reviews, solutions, by.x = "solution_id", by.y = "id", all = T)
head(mergedData)


## Default - merge all common column names
intersect(names(solutions), names(reviews))
mergedData2 = merge(reviews, solutions, all = T)
head(mergedData2)

## Using join in the plyr package
# - Faster, but less full featured
df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))
df1
df2
arrange(join(df1, df2), id) # merged to same id number
# returns:
# id          y
# 1   6 -0.8168021
# 2   3 -0.3781521
# 3   5 -0.5761294
# 4   2 -0.7559380
# 5   1  0.2048614
# 6   7  0.4019754
# 7   8 -1.5702684
# 8   4  0.3520793
# 9  10  0.3761223
# 10  9  0.5336846

## If you have multiple data frames, you can make a list, then use 'join_all'
df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))
df3 <- data.frame(id = sample(1:10), z = rnorm(10))
dfList = list(df1, df2, df3)
dfList
join_all(dfList)

## More on merging data
# - The quick R data merging page - http://www.statmethods.net/management/merging.html
# - plyr information - http://plyr.had.co.nz/
# - Types of joins - http://en.wikipedia.org/wiki/Join_(SQL)


