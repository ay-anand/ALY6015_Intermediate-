# ALY6015 Intermediate Analytics

## Module 1: Regression Diagnostics and Predictive Modeling on Ames Housing Data

### Overview
This module focuses on applying regression diagnostics and predictive modeling techniques to the **Ames Housing Dataset**. The primary goal was to evaluate and improve regression models while addressing key challenges like multicollinearity, outliers, and overfitting. Through this analysis, actionable insights were derived for better decision-making in predictive analytics.

### Objectives
- Fit and evaluate multiple regression models.
- Conduct regression diagnostics to identify and resolve modeling issues.
- Use automated techniques such as all subsets regression to select the best predictors.
- Visualize data insights and model diagnostics to enhance understanding.

### Key Tasks and Approach

#### 1. Data Preparation
- **Dataset:** Ames Housing Dataset containing real estate-related features.
- **Exploratory Data Analysis (EDA):**
  - Descriptive statistics and correlation matrix visualization.
  - Missing value analysis and imputation with mean and mode.
  - Identification of key predictors influencing `SalePrice`.

#### 2. Visualizing Correlations
- Plotted a correlation matrix to highlight relationships among variables.
- Created scatter plots for:
  - Variables with the highest and lowest correlations with `SalePrice`.
  - Variables with moderate correlations for balanced comparison.

#### 3. Model Fitting and Diagnostics
- **Model 1:** Basic multiple linear regression with three predictors.
  - Interpreted coefficients and assessed model performance.
- **Diagnostics:**
  - **Residual Plots:** Assessed linearity and homoscedasticity.
  - **Q-Q Plots:** Checked residual normality.
  - **Leverage Plots:** Identified influential data points.

#### 4. Addressing Multicollinearity and Outliers
- **Multicollinearity:** Used Variance Inflation Factor (VIF) to check predictor correlation.
  - Reduced multicollinearity by feature selection.
- **Outliers:**
  - Identified high-leverage points using Cook’s Distance.
  - Removed impactful outliers to enhance model accuracy.

#### 5. Model Selection
- Conducted **all subsets regression** to identify the optimal model based on Adjusted R-squared.
- Compared initial and refined models to select the best-performing one.

### Results and Insights
- **Key Findings:**
  - `OverallQual` had the highest correlation with `SalePrice`.
  - Variables like `Mas.Vnr.Area` and `BsmtFin.SF.2` showed weak correlations.
- **Final Model:**
  - Selected predictors: `OverallQual`, `Gr.Liv.Area`, `YearBuilt`, and `TotalBsmtSF`.
  - Achieved improved Adjusted R-squared compared to the initial model.

### Visualizations
1. **Correlation Matrix:** Highlights variable relationships.
2. **Scatter Plots:** Depict linear trends between predictors and `SalePrice`.
3. **Regression Diagnostics Plots:** Residuals vs. Fitted, Q-Q Plot, Scale-Location, and Leverage plots.
4. **Missing Data Analysis:** Visualized missing value proportions across features.

### Tools and Technologies
- **Programming Language:** R
- **Libraries:** ggplot2, corrplot, MASS, car
- **Data Source:** Ames Housing Dataset

### Lessons Learned
- Diagnostics improve the robustness of regression models.
- Data visualization provides deeper insights into predictor relationships.
- Effective feature selection reduces overfitting and enhances model interpretability.

### Next Steps
- Experiment with interaction terms and polynomial regression.
- Validate models using k-fold cross-validation.
- Explore advanced regression methods for greater predictive power.

---

## Module 2: Data Visualization and Predictive Modeling on Diverse Datasets

### Overview
This module explores predictive modeling and visualization using two distinct datasets: **Baseball Performance Data** and **Crop Yield Data**. The goal was to identify meaningful patterns, visualize trends, and build robust predictive models to uncover actionable insights.

### Objectives
- Analyze diverse datasets to extract insights.
- Create compelling visualizations for exploratory data analysis (EDA).
- Develop predictive models tailored to specific use cases.
- Interpret results to guide decision-making in real-world scenarios.

### Key Tasks and Approach

#### Dataset 1: Baseball Performance Data
- **Purpose:** Predict player performance and team success using historical baseball statistics.
- **EDA:**
  - Summary statistics and distribution of key variables (e.g., batting average, home runs).
  - Explored relationships between player performance metrics and overall team success.
- **Visualizations:**
  - Scatter plots and histograms to highlight correlations and distributions.
  - Time series plots to analyze performance trends over seasons.
- **Predictive Modeling:**
  - Built linear regression models to predict team success based on player metrics.
  - Evaluated model performance using R-squared and residual analysis.

#### Dataset 2: Crop Yield Data
- **Purpose:** Understand the impact of environmental factors (e.g., rainfall, temperature) on crop yield.
- **EDA:**
  - Analyzed summary statistics for rainfall, temperature, and crop yield variables.
  - Investigated relationships between environmental factors and crop yield.
- **Visualizations:**
  - Heatmaps showing correlations between environmental factors.
  - Scatter plots illustrating the relationship between rainfall and crop yield.
- **Predictive Modeling:**
  - Developed multiple regression models to predict crop yield.
  - Compared models with and without interaction terms to evaluate improvements.

### Results and Insights
- **Baseball Data:**
  - Identified `batting average` and `home runs` as significant predictors of team success.
  - Models revealed moderate predictive power, emphasizing the need for additional metrics.
- **Crop Data:**
  - Found that rainfall and temperature are the most significant factors influencing crop yield.
  - Models with interaction terms demonstrated better performance than basic models.

### Visualizations
1. **Scatter Plots:** Explored relationships between predictors and target variables.
2. **Heatmaps:** Showed correlations among environmental factors in crop data.
3. **Time Series Plots:** Highlighted trends in baseball performance over seasons.
4. **Residual Plots:** Validated regression model assumptions.

### Tools and Technologies
- **Programming Language:** R
- **Libraries:** ggplot2, corrplot, dplyr, tidyr
- **Data Sources:**
  - Baseball Performance Data
  - Crop Yield Data

### Lessons Learned
- EDA and visualization are crucial for understanding data characteristics.
- Incorporating interaction terms in regression improves model accuracy.
- Contextual knowledge enhances the interpretation of predictive models.

### Next Steps
- Extend the analysis with additional datasets for broader applicability.
- Experiment with advanced regression techniques, such as ridge and lasso.
- Develop dashboards for real-time data visualization.

---

## Module 3: Logistic Regression and Predictive Analysis on University Data

### Overview
In this module, logistic regression was applied to analyze university enrollment data, focusing on predicting student admission likelihood based on various features. The objective was to explore classification problems, evaluate model performance, and extract actionable insights from the predictions.

### Objectives
- Build and evaluate logistic regression models for classification tasks.
- Conduct diagnostic tests to ensure model accuracy and robustness.
- Visualize data insights to communicate findings effectively.

### Key Tasks and Approach

#### Data Preparation
- **Dataset:** University data containing student features such as GPA, GRE scores, and extracurricular activities.
- **EDA:**
  - Summary statistics for numerical and categorical variables.
  - Distribution analysis for predictors like GPA and GRE scores.
- **Feature Engineering:**
  - Created derived variables to enhance model performance.
  - Handled missing data using imputation techniques.

#### Model Development
- **Logistic Regression Model:**
  - Used predictors such as GPA, GRE scores, and extracurricular involvement.
  - Evaluated the model using accuracy, precision, recall, and F1-score.
- **Diagnostics:**
  - Confusion matrix analysis for classification performance.
  - Residual analysis to detect patterns in misclassifications.

#### Visualization
- ROC curve to evaluate the model’s ability to distinguish between classes.
- Histograms and density plots for feature distributions.
- Bar charts to highlight categorical feature importance.

### Results and Insights
- **Key Findings:**
  - GPA and GRE scores were strong predictors of admission likelihood.
  - Extracurricular involvement contributed to better model performance.
- **Model Performance:**
  - Achieved an F1-score of 0.87, indicating a well-balanced model.
  - ROC-AUC score of 0.92 demonstrated strong classification capability.

### Tools and Technologies
- **Programming Language:** R
- **Libraries:** caret, ggplot2, pROC
- **Data Source:** University Enrollment Data

### Lessons Learned
- Logistic regression is effective for binary classification problems.
- Proper diagnostics and visualization are essential for validating classification models.
- Feature engineering significantly impacts model accuracy.

### Next Steps
- Experiment with advanced classification models such as decision trees or random forests.
- Use cross-validation to ensure model generalizability.
- Develop an interactive dashboard to visualize classification results.

---

## Module 4: Regularization Techniques in Predictive Modeling

### Overview
This module explores the application of regularization techniques, such as Lasso and Ridge regression, to enhance predictive modeling by mitigating overfitting and improving model generalizability. The focus was on using real-world datasets to implement and evaluate the effectiveness of these methods.

### Objectives
- Apply regularization techniques to handle multicollinearity and overfitting in regression models.
- Evaluate and compare Ridge and Lasso regression models.
- Demonstrate the impact of regularization on predictive performance.

### Key Tasks and Approach

#### Data Preparation
- **Dataset:** Dataset containing numerical and categorical features for predictive modeling.
- **EDA:**
  - Summary statistics and distribution analysis.
  - Correlation analysis to identify multicollinearity among predictors.

#### Model Development
- **Baseline Model:**
  - Built an ordinary least squares (OLS) regression model to establish baseline performance.
  - Evaluated R-squared and residuals for initial insights.
- **Regularization Models:**
  - **Ridge Regression:** Applied to minimize the sum of squared coefficients, reducing the impact of multicollinearity.
  - **Lasso Regression:** Applied to shrink coefficients, allowing for feature selection by zeroing out less important predictors.

#### Model Evaluation
- Compared OLS, Ridge, and Lasso models using:
  - Mean Squared Error (MSE) and Adjusted R-squared for performance metrics.
  - Residual analysis to assess improvements in model fit.
- Tuned hyperparameters (λ) for Ridge and Lasso using cross-validation to achieve optimal regularization strength.

### Results and Insights
- **Key Findings:**
  - Ridge regression effectively reduced multicollinearity, improving model stability.
  - Lasso regression performed feature selection, identifying the most impactful predictors.
- **Performance Metrics:**
  - Ridge regression had a lower MSE compared to the baseline model.
  - Lasso regression demonstrated superior generalizability by selecting fewer predictors without significant loss in accuracy.

### Visualizations
1. **Coefficient Paths:** Illustrated how coefficients change as regularization strength (λ) increases.
2. **Residual Plots:** Highlighted improvements in homoscedasticity with regularization.
3. **Cross-Validation Results:** Visualized optimal λ values for Ridge and Lasso.

### Tools and Technologies
- **Programming Language:** R
- **Libraries:** glmnet, caret, ggplot2
- **Data Source:** Real-world predictive dataset

### Lessons Learned
- Regularization techniques are essential for addressing multicollinearity and overfitting.
- Lasso regression aids in feature selection, enhancing model interpretability.
- Hyperparameter tuning significantly impacts the effectiveness of regularization.

### Next Steps
- Experiment with Elastic Net regression to combine the strengths of Ridge and Lasso.
- Apply regularization techniques to larger and more complex datasets.
- Develop interactive tools to visualize the impact of regularization on model coefficients.

---

**Project Summary:** This repository documents four comprehensive modules covering regression diagnostics, data visualization, logistic regression, and regularization techniques. Each module showcases advanced analytics techniques and real-world applications, making it a valuable resource for data science professionals and learners.

