# ================================================================================
# Loading Necessary Libraries
# ================================================================================

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(corrplot)
library(DataExplorer)
library(gridExtra)
library(car)
library(leaps)

# ================================================================================
# Step 1: Reading the Dataset
# ================================================================================

# Load the Ames housing dataset
ames_data <- read.csv("C:/Users/ayush/Downloads/Intermediate_Analytics/AmesHousing.csv")
head(ames_data)

# ================================================================================
# Step 2: Exploratory Data Analysis
# ================================================================================

# Display column names
column_names <- names(ames_data)
print(column_names)

# Get the structure and summary of the dataset
str(ames_data)
summary(ames_data)

# ================================================================================
# Step 3: Displaying Columns with Blank ("") Values in Plot
# ================================================================================

# Calculate the percentage of blank ("") values in each column
blank_percentage <- sapply(ames_data, function(x) sum(x == "", na.rm = TRUE)) / nrow(ames_data) * 100
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

# Convert blank ("") values to NA in the entire dataframe
ames_data[ames_data == ""] <- NA

# Checking for NA values in each column
colSums(is.na(ames_data))

# View missing data patterns
plot_missing(ames_data)

# ================================================================================
# Step 4: Removing Columns that Have Missing Values > 40%
# ================================================================================

# Calculate the percentage of missing values for each column
missing_percent <- sapply(ames_data, function(x) sum(is.na(x)) / length(x) * 100)

# Print the names of columns that were dropped
dropping_columns <- names(missing_percent[missing_percent > 40])
print("Dropping columns:")
print(dropping_columns)

# Filter out columns where the missing percentage is greater than 40%
ames_data <- ames_data[, missing_percent <= 40]

# View missing data patterns
plot_missing(ames_data)

# ================================================================================
# Step 5: Handling Missing Values (Categorical - Mode, Numerical - Median)
# ================================================================================

# Function to calculate mode
get_mode <- function(x) {
  unique_values <- unique(x)
  unique_values[which.max(tabulate(match(x, unique_values)))]
}

# Handling missing values in ames_data
ames_data <- ames_data %>%
  # Replace NA in numeric columns with median
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .))) %>%
  # Convert character columns to factor to ensure compatibility with get_mode
  mutate(across(where(is.character), as.factor)) %>%
  # Replace NA in factor (categorical) columns with mode
  mutate(across(where(is.factor), ~ ifelse(is.na(.), get_mode(na.omit(.)), .)))

# View missing data patterns
plot_missing(ames_data)

# ================================================================================
# Step 6: Visualizations
# ================================================================================

# Visualizations
# View histograms of variables
hist(ames_data$SalePrice, main = 'Sale Price')

# View boxplots of variables
ggplot(ames_data, aes(x = "", y = SalePrice)) +
  geom_boxplot() +
  labs(title = "Boxplot of Sale Price")

# Select variables to plot against SalePrice
variables <- c("Overall.Qual", "Gr.Liv.Area", "Total.Bsmt.SF", "Garage.Area", "Year.Built")

# Create a list to store individual plots
plots <- list()

# Create scatter plots for each variable
for (var in variables) {
  p <- ggplot(ames_data, aes_string(x = var, y = "SalePrice")) +
    geom_point(alpha = 0.5) +
    geom_smooth(method = "lm", se = FALSE, color = "red") +
    labs(title = paste("SalePrice vs", var),
         x = var,
         y = "SalePrice") +
    theme_minimal()
  plots[[var]] <- p
}

# Arrange plots in a grid
library(gridExtra)
grid.arrange(grobs = plots, ncol = 2)

# ================================================================================
# Step 7: Correlation Analysis
# ================================================================================

# Producing a correlation matrix for numeric values
numeric_ames_data <- ames_data[, sapply(ames_data, is.numeric)]
cor_matrix <- cor(numeric_ames_data, use = "complete.obs")

# Plotting the correlation matrix
corrplot(cor_matrix, method = "color", order = "hclust", tl.cex = 0.7)

# ================================================================================
# Step 8: Making Scatter Plots for Total Basement Area vs Sale Price
# ================================================================================

# Find highest correlation with SalePrice
highest_cor <- names(which.max(abs(cor_matrix["SalePrice", ])))
print(highest_cor)
ggplot(ames_data, aes_string(x = highest_cor, y = "Total.Bsmt.SF")) +
  geom_point(color = 'blue', alpha = 0.5) +
  labs(title = "Total Basement Area vs variable with the highest correlation with SalePrice",
       x = "Sale Price",
       y = "Total Basement Area (in Sqft)")

# Find lowest correlation with SalePrice
lowest_cor <- names(which.min(abs(cor_matrix["SalePrice", ])))
print(lowest_cor)
ggplot(ames_data, aes_string(x = lowest_cor, y = "Total.Bsmt.SF")) +
  geom_point(color = 'red', alpha = 0.5) +
  labs(title = "Total Basement Area vs variable with the lowest correlation with SalePrice",
       x = "BsmtFin.SF.2 - Type 2 finished square feet",
       y = "Total Basement Area (in Sqft)")

# Find correlation closest to 0.5 with SalePrice
mid_cor <- names(which.min(abs(abs(cor_matrix["SalePrice", ]) - 0.5)))
print(mid_cor)
ggplot(ames_data, aes_string(x = mid_cor, y = "Total.Bsmt.SF")) +
  geom_point(color = 'purple', alpha = 0.5) +
  labs(title = "Total Basement Area vs variable with the 0.5 correlation with SalePrice",
       x = "Mas.Vnr.Area - Masonry veneer area in square feet",
       y = "Total Basement Area (in Sqft)")

# ================================================================================
# Step 9: Fitting a Regression Model
# ================================================================================

# Fitting a regression model using 5 continuous variables
model1 <- lm(SalePrice ~ Overall.Qual + Gr.Liv.Area + Year.Built + Total.Bsmt.SF + Garage.Area, data = ames_data)
summary(model1)

# Plotting the regression model
par(mfrow = c(2, 2))
plot(model1)

# Calculating the Mean Residual Standard Error (MRSE) for the model
rse <- summary(model1)$sigma
n1 <- nrow(ames_data)
mrse <- rse / sqrt(n1)
mrse

# Calculating AIC and BIC of the model:
AIC(model1)
BIC(model1)

# ================================================================================
# Step 10: Checking for Multicollinearity and Outliers
# ================================================================================

# Checking for multicollinearity
library(car)
vif(model1)

# Checking for outliers using Bonferroni test
outliers <- outlierTest(model1)
print(outliers)

# Plotting high-leverage observations
hat.plot <- function(model1) {
  p <- length(coefficients(model1))
  n <- length(fitted(model1))
  
  plot(hatvalues(model1), main = "Index Plot of Hat Values")
  abline(h = c(2, 3) * p / n, col = "red", lty = 2)
  identify(1:n, hatvalues(model1), names(hatvalues(model1)))
}
hat.plot(model1)

# Influential observations
cutoff <- 4 / (nrow(ames_data) - length(model1$coefficients) - 2)
plot(model1, which = 4, cook.levels = cutoff)
abline(h = cutoff, lty = 2, col = "red")

# ================================================================================
# Step 11: Using All Subsets Regression to Identify the "Best" Model
# ================================================================================

# Using all subsets regression to identify the "best" model
subsets <- regsubsets(SalePrice ~ Overall.Qual + Gr.Liv.Area + Year.Built + Total.Bsmt.SF + Garage.Area,
                      data = ames_data, nvmax = 5)
summary(subsets)

# Plotting subsets regression:
plot(subsets, scale = "adjr2")
