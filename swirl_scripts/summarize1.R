# Compute four values, in the following order, from
# the grouped data:
#
# 1. count = n()
# 2. unique = n_distinct(ip_id)
# 3. countries = n_distinct(country)
# 4. avg_bytes = mean(size)
#
# A few thing to be careful of:
#
# 1. Separate arguments by commas
# 2. Make sure you have a closing parenthesis
# 3. Check your spelling!
# 4. Store the result in pack_sum (for 'package summary')
#
# You should also take a look at ?n and ?n_distinct, so
# that you really understand what is going on.

pack_sum <- summarize(by_package,
                      count = n(),                      # n() tells us number of obs or rows for each package
                      unique = n_distinct(ip_id),       # n_distinct tells us number of unique downloads for each package
                      countries = n_distinct(country),  # same here, but unique countries
                      avg_bytes = mean(size))           # finds average download size of each file in package
