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

























