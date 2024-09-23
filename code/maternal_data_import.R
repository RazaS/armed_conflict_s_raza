library (dplyr)
library (here)
library (tidyverse)
library(usethis) 


here() #set wd

#import maternal mortality
matmort <- read.csv("data/maternalmortality.csv")

#select columns of interest
matmort_subset <- matmort %>% select (Country.Name, X2000:X2019)

#
matmort_subset <- matmort_subset %>% 
  pivot_longer (cols=X2000:X2019, names_to = "Year", names_prefix = "X", values_to = "MatMor") %>%
  mutate(Year = as.numeric(Year))


