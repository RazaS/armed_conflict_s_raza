library (dplyr)
library (here)
library (tidyverse)
library(usethis) 




here() #set wd

matmort <- read.csv("data/maternalmortality.csv")

matmort_subset <- matmort %>% select (Country.Name, X2000:X2019)

matmort_subset <- matmort_subset %>% 
  pivot_longer (cols=X2000:X2019, names_to = "Year", names_prefix = "X", values_to = "MatMor") %>%
  mutate(Year = as.numeric(Year))






gitcreds::gitcreds_set(url = "[https://github.com](https://github.com)") #this will prompt you for a token


# usethis::use_git() # initializes new git repository
# use_github() connect local repo

#hello test 

# Stage specific files or all changes
usethis::use_git_hook(name = "update 1")
