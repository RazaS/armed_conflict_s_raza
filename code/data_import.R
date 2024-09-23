library (dplyr)
library (here)
library (tidyverse)
library(usethis) 
library(countrycode)


here() #set wd

#import datasets
matmort <- read.csv("data/maternalmortality.csv")
disaster <- read.csv("data/disaster.csv")
infant <- read.csv("data/infantmortality.csv")
neonatal <- read.csv("data/neonatalmortality.csv")
under5 <- read.csv("data/under5mortality.csv")
covariates <- read.csv("data/covariates.csv")

data_cleaning <- function (dataframe, columnLabel) {
 
  data_subset <- dataframe %>% select (Country.Name, X2000:X2019)
  data_subset <- data_subset %>% 
    pivot_longer (cols=X2000:X2019, names_to = "Year", names_prefix = "X", values_to = columnLabel) %>%
    mutate(Year = as.numeric(Year))
  
  return(data_subset)
  
}

# clean data, except for disaster csv
matmort_subset <- data_cleaning (matmort, "MatMort")
infant_subset <- data_cleaning (matmort, "InfantMort")
neonatal_subset <- data_cleaning (matmort, "NeonatalMort")
under5_subset <- data_cleaning (matmort, "Under5Mort")

subset_list <- list(matmort_subset, infant_subset, neonatal_subset, under5_subset)

join_by_columns <- c("Country.Name", "Year")


combine_dataframes <- function (list_of_dataframes, join_by_list) {
  
  combined_dataframe <- reduce(list_of_dataframes, full_join, by=join_by_list)

}

# Example of full_join using two columns
combined_subset <- combine_dataframes(subset_list,join_by_columns)

combined_subset$ISO <- countrycode(combined_subset$Country.Name,
                            origin = "country.name",
                            destination = "iso3c")

#rename year column to lower case
combined_subset <- combined_subset %>% select(-Country.Name) %>% rename(year=Year)


## download and clean and wrangle disaster dataset
disaster_subset <- disaster %>% filter (Disaster.Type %in% c("Earthquake", "Drought"), Year>=2000, Year<=2019)
disaster_subset <- disaster_subset %>% select(Year, ISO, Disaster.Type)
disaster_subset <- disaster_subset %>%
  mutate(
    drought_dummy = as.integer(Disaster.Type == "Drought"),  # Creates 'drought' dummy variable
    earthquake_dummy = as.integer(Disaster.Type == "Earthquake")  # Creates 'earthquake' dummy variable
  ) %>%
  select(-Disaster.Type) %>% rename(year=Year) ##rename Year to year










