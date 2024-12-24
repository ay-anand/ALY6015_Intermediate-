# Load necessary libraries
library(dplyr)
library(ggplot2)
library(DataExplorer)
library(readr)
library(gtsummary)
library(gt)

#**********************************************************************************************************************

# Read CSV file into R and assign to a unique dataframe name
baseball_data <- read.csv("C:/Users/ayush/Downloads/Intermediate_Analytics/Mudule 2 Assignment- Chi Anova/baseball.csv")
head(baseball_data)

# Get the structure of the dataset to understand column types
str(baseball_data)

# Generate a summary of the dataset
summary(baseball_data)

# Display column names
column_names <- names(baseball_data)
print(column_names)

#**********************************************************************************************************************

# Calculate the percentage of blank values in each column
blank_percentage <- sapply(baseball_data, function(x) sum(x == "", na.rm = TRUE)) / nrow(baseball_data) * 100
blank_df <- data.frame(Column = names(blank_percentage), Blank_Percentage = blank_percentage)
blank_df <- subset(blank_df, Blank_Percentage > 0)

# Plot the percentage of blank values for each column
ggplot(blank_df, aes(x = reorder(Column, -Blank_Percentage), y = Blank_Percentage)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Percentage of Blank Values in Each Column",
       x = "Columns",
       y = "Percentage of Blank Values") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#**********************************************************************************************************************

# Check for NA values in each column
colSums(is.na(baseball_data))

# Visualize missing data patterns
plot_missing(baseball_data)

# Remove columns with more than 60% missing values
# Calculate the percentage of missing values for each column
missing_percent <- sapply(baseball_data, function(x) sum(is.na(x)) / length(x) * 100)

# Print the names of columns that will be dropped
dropping_columns <- names(missing_percent[missing_percent > 60])
print("Dropping columns:")
print(dropping_columns)

# Retain columns with missing percentage ≤ 60%
baseball_data <- baseball_data[, missing_percent <= 60]

# Visualize the missing data patterns again after column removal
plot_missing(baseball_data)

#**********************************************************************************************************************

# Select variables for the summary table
selected_vars <- c("League", "Year","RS", "RA", "W", "G", "OBP", "SLG", "BA", "Playoffs")

# Create summary table by League
summary_table_by_league <- baseball_data %>%
  select(all_of(selected_vars)) %>%
  tbl_summary(
    by = League,
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = all_continuous() ~ 2) %>%
  add_p() %>% add_overall() %>%
  modify_header(label = "**Variable**") %>%
  modify_caption("Table 1. Descriptive Statistics for Baseball matches by League (1962-2012)")

# Print the summary table by League
print(summary_table_by_league)

# Export summary table as a .docx file
summary_table_by_league %>%
  as_gt() %>%
  gt::gtsave(filename = "summary_table_by_league.docx")

#**********************************************************************************************************************

# Plot: Boxplot of Runs Scored by Wins
ggplot(baseball_data, aes(x = factor(W), y = RS)) +
  geom_boxplot(fill = "orange", alpha = 0.7) +
  labs(title = "Boxplot of Runs Scored by Wins", x = "Wins", y = "Runs Scored") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Plot: Count of Wins by League
ggplot(baseball_data, aes(x = W, fill = League)) +
  geom_histogram(binwidth = 5, position = "dodge", color = "black", alpha = 0.7) +
  labs(title = "Count of Wins by League", x = "Wins", y = "Count") +
  theme_minimal()

# Plot: Runs Scored by League Over the Years
# Calculate total Runs Scored (RS) per league per year
runs_by_league <- baseball_data %>%
  group_by(Year, League) %>%
  summarize(Total_RS = sum(RS))

# Generate line plot for Runs Scored by League Over the Years
ggplot(runs_by_league, aes(x = Year, y = Total_RS, color = League)) +
  geom_line(size = 1.2) +
  geom_point() +
  labs(title = "Runs Scored by League Over the Years",
       x = "Year",
       y = "Total Runs Scored",
       color = "League") +
  theme_minimal()

# Plot: Wins by League Over the Years
# Calculate total Wins (W) per league per year
wins_by_league <- baseball_data %>%
  group_by(Year, League) %>%
  summarize(Total_Wins = sum(W))

# Generate line plot for Wins by League Over the Years
ggplot(wins_by_league, aes(x = Year, y = Total_Wins, color = League)) +
  geom_line(size = 1.2) +
  geom_point() +
  labs(title = "Wins by League Over the Years",
       x = "Year",
       y = "Total Wins",
       color = "League") +
  theme_minimal()

#**********************************************************************************************************************

# Hypothesis Testing
# Null Hypothesis (H0): The number of wins is evenly distributed across decades.
# Alternative Hypothesis (H1): The number of wins is not evenly distributed across decades.

# Create a new column for decade
baseball_data <- baseball
