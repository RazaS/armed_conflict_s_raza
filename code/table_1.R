
library(dplyr)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(tidyr)


# Read the CSV file from the data folder
df <- read.csv("../data/final_analysis_dataset.csv")

# filters years 
df_filtered <- df[df$year >= 2000 & df$year <= 2017, ]

# prepare dataset for plotting

# calculate mean of the four numerical covariates of interest
df_summary <- df %>%
  group_by(country_name) %>%
  summarise(
    popdens_mean = mean(popdens, na.rm = TRUE),
    
    urban_mean = mean(urban, na.rm = TRUE),
    
    agedep_mean = mean(agedep, na.rm = TRUE),
    
    male_edu_mean = mean(male_edu, na.rm = TRUE),
    
  )


# join to original dataframe
df_sum <- df_filtered %>%
  left_join(df_summary, by = "country_name")


# calculate years of conflict in first and second half of study

# first half
df_sum_2000_2008 <- df %>%
  filter(year >= 2000 & year <= 2008) %>%
  group_by(country_name) %>%
  summarise(sum_best_binary_2000_2008 = sum(best_binary, na.rm = TRUE))

# second half
df_sum_2009_2017 <- df %>%
  filter(year >= 2009 & year <= 2017) %>%
  group_by(country_name) %>%
  summarise(sum_best_binary_2009_2017 = sum(best_binary, na.rm = TRUE))

# Merge years of conflict for first and second half to original dataset
df_sum <- df_sum %>%
  left_join(df_sum_2000_2008, by = "country_name") %>%
  left_join(df_sum_2009_2017, by = "country_name")


### one hot encode region (to get summary stats later) 

## map regions to continents 
df_sum <- df_sum %>%
  mutate(continent = case_when(
    region %in% c("Southern Asia", "Western Asia", "South-eastern Asia", "Eastern Asia", "Central Asia") ~ "Asia",
    region %in% c("Sub-Saharan Africa", "Northern Africa") ~ "Africa",
    region %in% c("Southern Europe", "Western Europe", "Eastern Europe", "Northern Europe") ~ "Europe",
    region %in% c("Latin America and the Caribbean") ~ "Latin America",
    region %in% c("Northern America") ~ "North America",
    region %in% c("Australia and New Zealand", "Melanesia", "Micronesia", "Polynesia") ~ "Oceania"
  ))

# One-hot encode the continent column
continent_one_hot <- model.matrix(~ continent - 1, data = df_sum)

# Convert the matrix to a dataframe
continent_one_hot_df <- as.data.frame(continent_one_hot)

# Rename columns: replace spaces with underscores and add "continent_" prefix
colnames(continent_one_hot_df) <- gsub("continent", "continent_", colnames(continent_one_hot_df))
colnames(continent_one_hot_df) <- gsub(" ", "_", colnames(continent_one_hot_df))

# Combine the one-hot encoded columns with the original dataframe
df_sum <- cbind(df_sum, continent_one_hot_df)



# calculate summary stats for all mortality stats 

# Calculate average yearly mortality for each country
df_avg_mortality <- df_sum %>%
  group_by(country_name) %>%
  summarise(
    avg_totdeath = mean(totdeath, na.rm = TRUE),
    avg_MatMort = mean(MatMort, na.rm = TRUE),
    avg_InfantMort = mean(InfantMort, na.rm = TRUE),
    avg_NeonatalMort = mean(NeonatalMort, na.rm = TRUE),
    avg_Under5Mort = mean(Under5Mort, na.rm = TRUE)
  )

# Merge the calculated averages back into the original dataframe
df_sum <- df_sum %>%
  left_join(df_avg_mortality, by = "country_name")



# Define a function to calculate the mode (most common value)
get_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Group by country_name and apply the get_mode function to all columns
tab_1_df <- df_sum %>%
  group_by(country_name) %>%
  summarise(across(everything(), get_mode))



##### Create Table


# Create the best_binary_category variable
tab_1_df$best_binary_category <- ifelse(tab_1_df$best_binary == 1, "Conflict Present", "Conflict Absent")

# Convert OECD2023 to a factor to ensure it's treated as categorical
tab_1_df$OECD2023 <- factor(tab_1_df$OECD2023, levels = c(0, 1), labels = c("Non-OECD", "OECD"))

# Create the best_binary_category variable
tab_1_df$best_binary_category <- ifelse(tab_1_df$best_binary == 1, "Conflict Present", "Conflict Absent")

# Custom render function for continuous variables (to show medians)
my_render_continuous <- function(x) {
  with(stats.apply.rounding(stats.default(x), digits=2), 
       c("", "Median" = sprintf("%s", MEDIAN)))
}


library(table1)

# Convert OECD2023 to a factor to ensure it's treated as categorical
tab_1_df$OECD2023 <- factor(tab_1_df$OECD2023, levels = c(0, 1), labels = c("Non-OECD", "OECD"))

# Create the best_binary_category variable
tab_1_df$best_binary_category <- ifelse(tab_1_df$best_binary == 1, "Conflict Present", "Conflict Absent")
# Custom render function for continuous variables (to show median and IQR)

# Calculate yearly total deaths
tab_1_df$yearly_totdeath <- tab_1_df$avg_totdeath / 18
tab_1_df$yearly_mat <- tab_1_df$avg_MatMort / 18
tab_1_df$yearly_neonatal <- tab_1_df$avg_NeonatalMort / 18
tab_1_df$yearly_infant <- tab_1_df$avg_InfantMort / 18
tab_1_df$yearly_under5 <- tab_1_df$avg_Under5Mort / 18


my_render_continuous <- function(x) {
  stats <- stats.default(x)
  
  q1 <- quantile(x, 0.25, na.rm = TRUE) %>% round(1) # 25th percentile
  q3 <- quantile(x, 0.75, na.rm = TRUE) %>% round(1) # 75th percentile
  iqr <- q3 - q1  # Interquartile range (IQR)
  
  with(stats.apply.rounding(stats, digits=2), 
       c("", 
         "Median (IQR)" = sprintf("%s (%s - %s)", MEDIAN, q1, q3)))
}

# Assign labels to variables in tab_1_df
label(tab_1_df$gdp1000) <- "GDP (in 1000s)"
label(tab_1_df$agedep) <- "Age Dependency Ratio"
label(tab_1_df$male_edu) <- "Male Education Level"
label(tab_1_df$urban) <- "Urban Population (%)"
label(tab_1_df$sum_best_binary_2000_2008) <- "Years with Conflict (2000-2008)"
label(tab_1_df$sum_best_binary_2009_2017) <- "Years with Conflict (2009-2017)"
label(tab_1_df$yearly_totdeath) <- "Total Deaths (Yearly)"
label(tab_1_df$yearly_mat) <- "Maternal Deaths (Yearly)"
label(tab_1_df$yearly_neonatal) <- "Neonatal Deaths (Yearly)"
label(tab_1_df$yearly_infant) <- "Infant Deaths (Yearly)"
label(tab_1_df$yearly_under5) <- "Under 5 Deaths (Yearly)"

# Create the summary table with new labels
table1(~ gdp1000 + agedep + male_edu + urban + 
         sum_best_binary_2000_2008 + sum_best_binary_2009_2017 + 
         yearly_totdeath + yearly_mat + yearly_neonatal + yearly_infant + yearly_under5 | 
         factor(best_binary_category, levels = c("Conflict Present", "Conflict Absent")), 
       data = tab_1_df, 
       overall = "All countries", 
       render.continuous = my_render_continuous)  # Apply the new labels