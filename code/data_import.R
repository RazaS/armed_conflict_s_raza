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

## function for data cleaning and organizing via pivot 
data_cleaning <- function (dataframe, columnLabel) {
 
  data_subset <- dataframe %>% select (Country.Name, X2000:X2019)
  data_subset <- data_subset %>% 
    pivot_longer (cols=X2000:X2019, names_to = "Year", names_prefix = "X", values_to = columnLabel) %>%
    mutate(Year = as.numeric(Year))
  
  return(data_subset)
  
}

### function to join dataframes using reduce function 
combine_dataframes <- function (list_of_dataframes, join_by_list) {
  
  combined_dataframe <- reduce(list_of_dataframes, left_join, by=join_by_list)
  
}


# clean data, except for disaster csv
matmort_subset <- data_cleaning (matmort, "MatMort")
infant_subset <- data_cleaning (infant, "InfantMort")
neonatal_subset <- data_cleaning (neonatal, "NeonatalMort")
under5_subset <- data_cleaning (under5, "Under5Mort")

subset_list <- list(matmort_subset, infant_subset, neonatal_subset, under5_subset)

join_by_columns <- c("Country.Name", "Year")



# Example of full_join using two columns
outcomes_subset <- combine_dataframes(subset_list,join_by_columns)

outcomes_subset$ISO <- countrycode(outcomes_subset$Country.Name,
                            origin = "country.name",
                            destination = "iso3c")

#rename year column to lower case
outcomes_subset <- outcomes_subset %>% select(-Country.Name) %>% rename(year=Year)


## download and clean and wrangle disaster dataset
disaster <- read.csv("data/disaster.csv")

disaster_subset <- disaster %>% filter (Disaster.Type %in% c("Earthquake", "Drought"), Year>=2000, Year<=2019)

disaster_subset <- disaster_subset %>% select(Year, ISO, Disaster.Type)

## create dummy variables
disaster_subset_dummy <- disaster_subset %>%
  mutate(
    drought_dummy = as.integer(Disaster.Type == "Drought"),  # Creates 'drought' dummy variable
    earthquake_dummy = as.integer(Disaster.Type == "Earthquake")  # Creates 'earthquake' dummy variable
  )

## assigns values to dummy variable and collapses into one row based on max value (if any 1, final value is 1, if all 0, final value is 0)
disaster_subset_dummy_summarized <- disaster_subset_dummy %>% 
  group_by(Year, ISO)  %>% 
  summarize ( drought_dummy = max(drought_dummy), earthquake_dummy = max(earthquake_dummy), .groups="drop")%>% rename(year=Year) ##rename Year to year








