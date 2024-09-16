library (dplyr)
library (here)
library (tidyverse)
library(usethis) 

usethis::use_git_config(user.name = "Sheharyar Raza", user.email = "sheharyar.raza@gmail.com")

# to confirm, generate a git situation-report, your user name and email should appear under Git config (global)
usethis::git_sitrep()


git config --global user.name "Sheharyar Raza"
git config --global user.email "sheharyar.raza@gmail.com"


here() #set wd

matmort <- read.csv("data/maternalmortality.csv")

matmort_subset <- matmort %>% select (Country.Name, X2000:X2019)

matmort_subset <- matmort_subset %>% 
  pivot_longer (cols=X2000:X2019, names_to = "Year", names_prefix = "X", values_to = "MatMor") %>%
  mutate(Year = as.numeric(Year))



