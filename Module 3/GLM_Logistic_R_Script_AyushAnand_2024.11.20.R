# Load required libraries 
library(ISLR) 
library(DataExplorer) 
library(gtsummary) 
library(ggplot2) 
library(gridExtra) 
library(dplyr) 
library(caret) 
library(pROC) 

#----------------------------------------------------------------------------------------------------------------------------
# Load the College dataset 
data(College)  # Load dataset
force(College)  # Ensure data is properly loaded

# Get column names 
column_names <- names(College) 
print(column_names)  # Print column names to check the variables

# Checking for missing values in each column 
colSums(is.na(College))  # Summarize missing values per column

# View missing data patterns 
plot_missing(College)  # Plot to visualize missing data patterns

#----------------------------------------------------------------------------------------------------------------------------
# Summary statistics 
# Create a summary table 
college_summary <- College %>% 
  select(-Apps, -F.Undergrad, -P.Undergrad) %>%  # Exclude some variables for brevity 
  tbl_summary(
    by = Private,  # Group by Private/Public status 
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",  # Mean and standard deviation for continuous variables
      all_categorical() ~ "{n} ({p}%)"  # Count and percentage for categorical variables
    ),
    digits = all_continuous() ~ 1,  # Limit digits to 1 for continuous variables
    missing = "no"  # Don't show missing data 
  ) %>% 
  add_p() %>%  # Add p-values for group comparisons 
  add_overall() %>%  # Add an overall column 
  modify_header(label = "**Variable**") %>%  # Modify column headers 
  modify_spanning_header(c("stat_1", "stat_2") ~ "**University Type**") %>% 
  bold_labels()  # Make labels bold for better visibility

# Print the summary table 
print(college_summary)

#------------------------------------------------------------------------------------------------------------------------------
# Visualizations 
# Visualize the distribution of public vs private universities 
ggplot(College, aes(x = Private)) + 
  geom_bar(fill = "steelblue") + 
  ggtitle("Distribution of Public vs Private Universities")

# Boxplot of Outstate tuition by Private/Public status 
ggplot(College, aes(x = Private, y = Outstate)) + 
  geom_boxplot(fill = "orange") + 
  ggtitle("Outstate Tuition by University Type")

# Scatter plot of Outstate tuition vs Graduation Rate 
ggplot(College, aes(x = Outstate, y = Grad.Rate, color = Private)) + 
  geom_point(alpha = 0.6) + 
  ggtitle("Outstate Tuition vs Graduation Rate")

# Boxplot of Full-time and Part-time Undergraduates by university type 
p1 <- ggplot(College, aes(x = Private, y = F.Undergrad)) + 
  geom_boxplot(aes(fill = Private)) + 
  labs(title = "Full-time Undergraduates by University Type", y = "Number of Full-time Undergraduates") + 
  theme_minimal()

p2 <- ggplot(College, aes(x = Private, y = P.Undergrad)) + 
  geom_boxplot(aes(fill = Private)) + 
  labs(title = "Part-time Undergraduates by University Type", y = "Number of Part-time Undergraduates") + 
  theme_minimal()

# Arrange the two plots side by side 
grid.arrange(p1, p2, ncol = 2)

# Scatter plot of Graduation Rate vs. Student-Faculty Ratio 
ggplot(College, aes(x = S.F.Ratio, y = Grad.Rate, color = Private)) + 
  geom_point(alpha = 0.6) + 
  geom_smooth(method = "lm", se = FALSE) + 
  labs(title = "Graduation Rate vs. Student-Faculty Ratio", x = "Student-Faculty Ratio", y = "Graduation Rate (%)") + 
  theme_minimal()

# Grouped bar plot of Top 10% of High School Class 
College$Top10perc_cat <- cut(College$Top10perc, breaks = c(0, 25, 50, 75, 100), labels = c("0-25%", "26-50%", "51-75%", "76-100%"))

# Grouped bar chart 
ggplot(College, aes(x = Top10perc_cat, fill = Private)) + 
  geom_bar(position = "dodge") + 
  labs(title = "Proportion of Students from Top 10% of High School Class", x = "Percentage from Top 10%", y = "Count") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Various Expenses by University Type 
College_long <- College %>% 
  select(Private, Books, Personal, Room.Board) %>% 
  tidyr::pivot_longer(cols = c(Books, Personal, Room.Board), names_to = "Expense_Type", values_to = "Amount")

# Histogram of expenses by university type 
ggplot(College_long, aes(x = Amount, fill = Private)) + 
  geom_histogram(position = "dodge", bins = 30, alpha = 0.7) + 
  facet_wrap(~Expense_Type, scales = "free_x") + 
  labs(title = "Distribution of Various Expenses by University Type", x = "Amount ($)", y = "Count") + 
  theme_minimal()

#-----------------------------------------------------------------------------------------------------------------------------
# Split the data into training and testing sets 
set.seed(123)  # Set seed for reproducibility
train_index <- createDataPartition(College$Private, p = 0.7, list = FALSE)  # Split data into 70% train and 30% test
train_data <- College[train_index, ]
test_data <- College[-train_index, ]

# Fit logistic regression models 
model1 <- glm(Private ~ ., data = train_data, family = "binomial")  # Full model using all predictors
summary(model1)

model2 <- glm(Private ~ F.Undergrad + Outstate + PhD + Grad.Rate, data = train_data, family = "binomial")  # Reduced model using selected predictors
summary(model2)

library(modelsummary)

# Create a side-by-side comparison table for both models 
models_comparison <- modelsummary(
  list("Model-1" = model1, "Model-2" = model2),
  title = "Comparison of Logistic Regression Models",
  stars = TRUE,
  gof_map = c("nobs", "aic", "bic", "r.squared"),
  coef_map = c(
    "F.Undergrad" = "Full-time Undergrads",
    "Outstate" = "Out-of-state Tuition",
    "PhD" = "% Faculty with PhD",
    "Grad.Rate" = "Graduation Rate"
  )
)

# Print the comparison table 
print(models_comparison)

#---------------------------------------------------------------------------------------------------------------------------
# Create confusion matrices for training and testing sets 
# Training set predictions 
train_pred <- predict(model2, train_data, type = "response")
train_pred_class <- ifelse(train_pred > 0.5, "Yes", "No")
train_conf_matrix <- confusionMatrix(factor(train_pred_class), factor(train_data$Private), positive = 'Yes')
print(train_conf_matrix)

# Testing set predictions 
test_pred <- predict(model2, test_data, type = "response")
test_pred_class <- ifelse(test_pred > 0.5, "Yes", "No")
test_conf_matrix <- confusionMatrix(factor(test_pred_class), factor(test_data$Private), positive = 'Yes')
print(test_conf_matrix)

#---------------------------------------------------------------------------------------------------------------------------
# Plot ROC curve for training set 
roc_train <- roc(train_data$Private, train_pred)
plot(roc_train, main = "ROC Curve for Training Set", col = "blue", ylab = "Sensitivity - TP Rate", xlab = "Specificity - FP Rate")

# Calculate and print the AUC for Training Set 
auc_value_train <- auc(roc_train)
cat("AUC for Training Set:", auc_value_train, "\n")

# Plot ROC curve for testing set 
roc_test <- roc(test_data$Private, test_pred)
plot(roc_test, main = "ROC Curve for Testing Set", col = "blue", ylab = "Sensitivity - TP Rate", xlab = "Specificity - FP Rate")

# Calculate and print the AUC for Testing Set 
auc_value_test <- auc(roc_test)
cat("AUC for Testing Set:", auc_value_test, "\n")

