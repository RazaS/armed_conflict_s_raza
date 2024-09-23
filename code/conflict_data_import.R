library (dplyr)
library (here)
library (tidyverse)
library(usethis) 
library(countrycode)


here() #set wd

#import conflict data
conflictdata <- read.csv("data/conflictdata.csv")

## make conflict binary
conflictdata <- conflictdata %>% mutate(best_binary= ifelse(best >0, TRUE, FALSE)) %>% group_by(ISO,year) %>% summarise(best_binary = any(best_binary), .groups = 'drop') 

## lag a year, remove original year column
conflictdata <- conflictdata %>% mutate(year = year+1) 


library(usethis) 

usethis::use_git_config(user.name = "Sheharyar Raza", user.email = "sheharyar.raza@gmail.com")
 
# to confirm, generate a git situation-report, your user name and email should appear under Git config (global)
usethis::git_sitrep()









