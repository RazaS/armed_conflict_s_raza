library (dplyr)
library (here)
library (tidyverse)
library(usethis) 


here() #set wd

disaster <- read.csv("data/disaster.csv")

disaster_subset <- disaster %>% filter (Disaster.Type %in% c("Earthquake", "Drought"), Year>=2000, Year<=2019)

disaster_subset <- disaster_subset %>% select(Year, ISO, Disaster.Type)

disaster_subset_dummy <- disaster_subset %>%
  mutate(
    drought = as.integer(Disaster.Type == "Drought"),  # Creates 'drought' dummy variable
    earthquake = as.integer(Disaster.Type == "Earthquake")  # Creates 'earthquake' dummy variable
  )


disaster_subset_dummy_summarized <- disaster_subset_dummy %>% 
  group_by(Year, ISO)  %>% 
  summarize ( drought = max(drought), earthquake = max(earthquake), .groups="drop")%>% rename(year=Year) ##rename Year to year


# use_git()
# use_github()
