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


usethis::use_git_config(user.name = "Sheharyar Raza", user.email = "sheharyar.raza@gmail.com")



gitcreds::gitcreds_set(url = "[https://github.com](https://github.com)") #this will prompt you for a token


usethis::use_git()

usethis::use_github()

