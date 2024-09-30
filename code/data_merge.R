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
#list_to_combine <- list(conflictdata, outcomes_subset, disaster_subset)

columns_to_join_with <- c("year", "ISO")
list_to_combine <- list(conflictdata, outcomes_subset, disaster_subset_dummy_summarized, covariates)
final_dataset <- combine_dataframes (list_to_combine, columns_to_join_with)


##rearrange columns
final_dataset <- final_dataset %>%
  select(country_name, ISO, region, year, gdp1000, OECD, OECD2023, popdens, urban, agedep, male_edu, temp, rainfall1000, totdeath, best_binary, MatMort, InfantMort, NeonatalMort, Under5Mort, drought_dummy, earthquake_dummy)

final_dataset <- final_dataset |>
  mutate(best_binary = replace_na(best_binary, 0),
         drought = replace_na(drought_dummy, 0),
         earthquake = replace_na(earthquake_dummy, 0),
         totdeath = replace_na(totdeath, 0))

write.csv(final_dataset, "data/final_analysis_dataset.csv", row.names = FALSE)