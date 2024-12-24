# Load necessary libraries
# Install required packages if not already installed
install.packages("ISLR")  # Contains the College dataset
install.packages("glmnet")  # For Ridge and Lasso regression
install.packages("caret")  # For data splitting and evaluation

# Load libraries
library(ISLR)
library(glmnet)
library(caret)

# Load the College dataset
data("College")
head(College)  # Preview the first few rows

# Summary and Data structure of dataset
summary(College)  # Summary statistics of the dataset
str(College)  # Structure of the dataset

# Set seed for reproducibility
set.seed(123)

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 1: Split Data into Training and Test Sets
# Split data: 70% Training, 30% Test
trainIndex <- sample(x = nrow(College), size = nrow(College) * 0.7)  # Randomly select 70% of the data for training
trainData <- College[trainIndex, ]  # Training dataset
testData <- College[-trainIndex, ]  # Test dataset

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Ridge Regression
# Step 2: Estimate Lambda Values using Cross-Validation
# Prepare data for glmnet
x_train <- model.matrix(Grad.Rate ~ ., data = trainData)[, -1]  # Predictor variables for training
y_train <- trainData$Grad.Rate  # Response variable for training

# Cross-validation for Ridge Regression
cv_ridge <- cv.glmnet(x_train, y_train, alpha = 0)  # alpha = 0 for Ridge Regression

# Lambda values
lambda_min_ridge <- cv_ridge$lambda.min  # Optimal lambda value with minimum cross-validation error
lambda_1se_ridge <- cv_ridge$lambda.1se  # Lambda value at 1-SE above minimum for simplicity
lambda_min_ridge  # Display lambda_min
lambda_1se_ridge  # Display lambda_1se

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 3: Plot Cross-Validation Results
plot(cv_ridge)  # Plot MSE as a function of lambda

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 4: Fit Ridge Regression Model
ridge_model <- glmnet(x_train, y_train, alpha = 0, lambda = lambda_min_ridge)  # Fit model with optimal lambda
coef(ridge_model)  # Display model coefficients

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 5: Evaluate Model Performance - Predictions on Training Set
pred_train_ridge <- predict(ridge_model, s = lambda_min_ridge, newx = x_train)  # Predictions on training data
rmse_train_ridge <- sqrt(mean((y_train - pred_train_ridge)^2))  # Calculate RMSE for training set
rmse_train_ridge  # Display RMSE

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 6: Evaluate Model Performance - Predictions on Test Set
x_test <- model.matrix(Grad.Rate ~ ., data = testData)[, -1]  # Predictor variables for testing
y_test <- testData$Grad.Rate  # Response variable for testing
pred_test_ridge <- predict(ridge_model, s = lambda_min_ridge, newx = x_test)  # Predictions on test data
rmse_test_ridge <- sqrt(mean((y_test - pred_test_ridge)^2))  # Calculate RMSE for test set
rmse_test_ridge  # Display RMSE

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# LASSO Regression
# Step 7: Estimate Lambda Values using Cross-Validation
# Cross-validation for LASSO
cv_lasso <- cv.glmnet(x_train, y_train, alpha = 1)  # alpha = 1 for LASSO Regression

# Lambda values
lambda_min_lasso <- cv_lasso$lambda.min  # Optimal lambda value with minimum cross-validation error
lambda_1se_lasso <- cv_lasso$lambda.1se  # Lambda value at 1-SE above minimum for simplicity
lambda_min_lasso  # Display lambda_min
lambda_1se_lasso  # Display lambda_1se

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 8: Plot Cross-Validation Results
plot(cv_lasso)  # Plot MSE as a function of lambda

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 9: Fit LASSO Regression Model
lasso_model <- glmnet(x_train, y_train, alpha = 1, lambda = lambda_min_lasso)  # Fit model with optimal lambda
coef(lasso_model)  # Display model coefficients

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 10: Evaluate Model Performance - Predictions on Training Set
pred_train_lasso <- predict(lasso_model, s = lambda_min_lasso, newx = x_train)  # Predictions on training data
rmse_train_lasso <- sqrt(mean((y_train - pred_train_lasso)^2))  # Calculate RMSE for training set
rmse_train_lasso  # Display RMSE

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Step 11: Evaluate Model Performance - Predictions on Test Set
pred_test_lasso <- predict(lasso_model, s = lambda_min_lasso, newx = x_test)  # Predictions on test data
rmse_test_lasso <- sqrt(mean((y_test - pred_test_lasso)^2))  # Calculate RMSE for test set
rmse_test_lasso  # Display RMSE

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Comparison
# Step 12: Compare Ridge and LASSO
comparison <- data.frame(
  Model = c("Ridge", "LASSO"),
  RMSE_Train = c(rmse_train_ridge, rmse_train_lasso),
  RMSE_Test = c(rmse_test_ridge, rmse_test_lasso)
)
comparison  # Display RMSE comparison between Ridge and LASSO

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Stepwise Selection
# Step 13: Stepwise Regression
stepwise_model <- step(lm(Grad.Rate ~ ., data = trainData), direction = "both")  # Stepwise selection using both directions
summary(stepwise_model)  # Summary of the stepwise model

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Evaluate Stepwise Model
pred_train_step <- predict(stepwise_model, newdata = trainData)  # Predictions on training data
rmse_train_step <- sqrt(mean((trainData$Grad.Rate - pred_train_step)^2))  # Calculate RMSE for training set

pred_test_step <- predict(stepwise_model, newdata = testData)  # Predictions on test data
rmse_test_step <- sqrt(mean((testData$Grad.Rate - pred_test_step)^2))  # Calculate RMSE for test set

# -------------------------------------------------------------------
# -------------------------------------------------------------------

# Stepwise Model Comparison
stepwise_comparison <- data.frame(
  Model = "Stepwise",
  RMSE_Train = rmse_train_step,
  RMSE_Test = rmse_test_step
)
stepwise_comparison  # Display RMSE for Stepwise model
