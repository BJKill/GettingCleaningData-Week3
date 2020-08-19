#### Getting and Cleaning Data Week 3 Quiz

## Q1. The American Community Survey distributes downloadable data about United States communities. 
## Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
## 
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
## 
## and load the data into R. The code book, describing the variable names is here:
## 
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
## 
## Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of 
## agriculture products. Assign that logical vector to the variable agricultureLogical. Apply the which() function like 
## this to identify the rows of the data frame where the logical vector is TRUE.
## 
## which(agricultureLogical)
## 
## What are the first 3 values that result?

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/housing.csv", method = "curl")
Housing <- read.csv("./data/housing.csv")
head(Housing)
agricultureLogic <- Housing$ACR == 3 & Housing$AGS == 6
head(agricultureLogic)
which(agricultureLogic)

## A1. 125, 238, 262


## Q2. Using the jpeg package read in the following picture of your instructor into R
## 
## https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
## 
## Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
## (some Linux systems may produce an answer 638 different for the 30th quantile)

library(jpeg)
picUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(picUrl, destfile = "./data/jeff.jpg", mode = "wb")
pic <- readJPEG("./data/jeff.jpg", native = TRUE)
pic
quantile(pic, c(0.3, 0.8))

## A2. -15258512, -10575416




## Q3. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
## 
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
## 
## Load the educational data from this data set:
## 
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
## 
## Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in descending order by 
## GDP rank (so United States is last). What is the 13th country in the resulting data frame?
## 
## Original data sources:
## http://data.worldbank.org/data-catalog/GDP-ranking-table
## http://data.worldbank.org/data-catalog/ed-stats

library(reshape)
library(dplyr)
library(tidyr)
## import files and make them into tbl_dfs
fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fileUrl3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl2, destfile = "./data/GDP.csv", method = "curl")
download.file(fileUrl3, destfile = "./data/EDStats.csv", method = "curl")
GDPCSV <- read.csv("./data/GDP.csv")
EDStatsCSV <- read.csv("./data/EDStats.csv")
GDP <- tbl_df(GDPCSV)
GDP
View(GDP)
EDStats <- tbl_df(EDStatsCSV)
EDStats
View(EDStats)

## Tidy up data by renaming columns and isolating columns and rows of data we need
GDP_fixed <- GDP %>% select(1, 2, 4, 5) %>% print
colnames(GDP_fixed) <- c("CountryCode", "Ranking", "Economy", "MillUSD")
GDP_fixed <- GDP_fixed[-(1:4), ]
GDP_fixed <- GDP_fixed[c(1:190, 192:215), ]

## Merge the data frames together by common CountryCode
MergedData <- merge(GDP_fixed, EDStats, by = "CountryCode", all.x = FALSE, all.y = FALSE)
View(MergedData)
nrow(MergedData)
MergedData$Ranking <- as.numeric(MergedData$Ranking)
MergedData <- arrange(MergedData, desc(Ranking))
View(MergedData)

## To match and merge the data better
GDPM <- arrange(GDP_fixed[1:190, ], CountryCode)
View(GDPM)
EDSM <- arrange(EDStats, CountryCode)
View(EDSM)
EDSM <- filter(EDSM, Income.Group != "")
MergedData2 <- merge(GDPM, EDSM, by = "CountryCode", all.x = FALSE, all.y = FALSE)
View(MergedData2)

MatchLogic <- GDPM$CountryCode[1:190] %in% EDSM$CountryCode
MatchLogic
sum(MatchLogic)

MergedData2$Ranking <- as.numeric(MergedData2$Ranking)
MergedSorted <- arrange(MergedData2, desc(Ranking))
View(MergedSorted)

## A3. 189 matches. 13th lowest country is St. Kitts and Nevis



## Q4. What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

MergedSummary <- MergedSorted %>% group_by(Income.Group) %>% summarize(AvgRank = mean(Ranking, na.rm = TRUE))
MergedSummary

## A4. 32.96667, 91.91304  (MY console returned 33.0 and 91.9, but I inferred the correct answer)



## Q5. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries are 
## Lower middle income but among the 38 nations with highest GDP?

library(Hmisc)
MergedSorted$Quantile <- cut2(MergedSorted$Ranking, g = 5)
QuantTable <- table(MergedSorted$Quantile, MergedSorted$Income.Group)
QuantTable

## A5. 5
