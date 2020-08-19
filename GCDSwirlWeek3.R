#### GCD Week 3 Swirl

library(swirl)
swirl()
BJKill
1

### Manipulating Data with dplyr

1
## read in data frame
mydf <- read.csv(path2csv, stringsAsFactors = FALSE)
dim()
dim(mydf)
head(mydf)

## call dplyr
library(dplyr)
packageVersion("dplyr")

## create a 'data frame tbl'
cran <- tbl_df(mydf)
rm("mydf")
cran

## select helps select columns
?select
select(cran, ip_id, package, country)
5:20
select(cran, r_arch:country)
select(cran, country:r_arch)
cran
select(cran, -time)
-(5:20)
select(cran, -(X:size))

## filter helps select rows
filter(cran, package == "swirl")
filter(cran, r_version == "3.1.1", country == "US")
?Comparison
filter(cran, r_version <= "3.0.2", country == "IN")
filter(cran, country == "US" | country == "IN")
filter(cran, size > 100500, r_os == "linux-gnu")
is.na(c(3, 5, NA, 10))
!is.na(c(3,5,NA,10))
filter(cran, !is.na(r_version))

## arrange helps order rows
cran2 <- select(cran, size:ip_id)
arrange(cran2, ip_id)
arrange(cran2, desc(ip_id))
arrange(cran2, package, ip_id)
arrange(cran2, country, desc(r_version), ip_id)
cran3 <- select(cran, ip_id, package, size)
cran3

## mutate helps create new variables based on the value of existing variables
mutate(cran3, size_mb = size / 2^20)
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)
mutate(cran3, correct_size = size + 1000)

## summarize helps collapse the dataset into a single row
summarize(cran, avg_bytes = mean(size))
1



### Grouping and Chaining with dplyr
1
2
library(dplyr)
cran <- tbl_df(mydf)
rm("mydf")
cran
?group_by
by_package <- group_by(cran, package)
by_package
summarize(by_package, mean(size))

## did side work with summarize1.R
submit()

pack_sum
quantile(pack_sum$count, probs = 0.99)
top_counts <- filter(pack_sum, count > 679)
top_counts
## dplyr only displays 10 rows, so use View() to see everything
View(top_counts)
top_counts_sorted <- arrange(top_counts, desc(count))
View(top_counts_sorted)
quantile(pack_sum$unique, 0.99)
top_unique <- filter(pack_sum, unique > 465)
View(top_unique)
top_unique_sorted <- arrange(top_unique, desc(unique))
View(top_unique_sorted)

## Chaining allows you to string together multiple function calls in a way that is compact and reliable
## Looking at summarize2.R
submit()
## Looking at summarize3.R
submit()
## Looking at summarize4.R
submit()
View(result3)
## Messed with chain1.R
submit()
## Messed with chain2.R
submit()
## Messed with chain3.R
submit()
## Messed with chain4.R
submit()
1
