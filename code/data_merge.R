library (dplyr)
library (here)
library (tidyverse)
library(usethis) 
library(countrycode)


here() #set wd

# Running the script using source()
source("code/data_import.R")
source("code/conflict_data_import.R")
#imports the final dataframes we need, which are combined_subset, disaster_subset, covariates, and conflictdata

list_to_combine <- list(combined_subset, disaster_subset, covariates, conflictdata)

columns_to_join_with <- c("year", "ISO")

final_dataset <- combine_dataframes (list_to_combine, columns_to_join_with)

##rearrange columns

# Reorder columns in base R
final_dataset <- final_dataset[, c("ISO", "year", "MatMort", "InfantMort", "NeonatalMort", "Under5Mort","drought_dummy", "earthquake_dummy", "country_name","region", "gdp1000", "OECD", "OECD2023", "popdens", "urban", "agedep", "male_edu", "temp", "rainfall1000", "best_binary")]



