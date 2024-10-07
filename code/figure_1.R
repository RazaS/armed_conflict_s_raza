library(dplyr)
library(ggplot2)

# Step 1: Identify countries with an increase in MatMort from 2000 to 2017
increased_matmort_countries <- df %>%
  filter(year %in% c(2000, 2017)) %>%
  group_by(country_name) %>%
  summarise(
    matmort_2000 = MatMort[year == 2000],
    matmort_2017 = MatMort[year == 2017]
  ) %>%
  filter(matmort_2017 > matmort_2000)

# Step 2: Prepare data for plotting
countries_to_plot <- increased_matmort_countries$country_name

# Filter the original dataframe to include only those countries
plot_data <- df %>%
  filter(country_name %in% countries_to_plot & year %in% c(2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017))

# Step 3: Create the line graph
ggplot(plot_data, aes(x = year, y = MatMort, group = country_name, color = country_name)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Change in Maternal Mortality from 2000 to 2017",
    x = "Year",
    y = "Maternal Mortality",
    color = "Country"
  ) +
  theme_minimal() +
  theme(legend.position = "right")