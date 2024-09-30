library (dplyr)
library (here)
library (tidyverse)
library(usethis) 
library(countrycode)


here() #set wd

#import conflict data
conflictdata <- read.csv("data/conflictdata.csv")

## make conflict binary
conflictdata <- conflictdata %>% 
  group_by(ISO, year) %>%
  summarize(totdeath = max(best)) %>%
  mutate(best_binary = ifelse(totdeath > 0, 1, 0)) %>%
  ungroup() 

## lag a year, remove original year column
conflictdata <- conflictdata %>% mutate(year = year+1) 




# library(usethis) 
# 
# usethis::use_git_config(user.name = "Sheharyar Raza", user.email = "sheharyar.raza@gmail.com")
#  
# # to confirm, generate a git situation-report, your user name and email should appear under Git config (global)
# usethis::git_sitrep()









