# How do nutritional and clinical factors influence frailty in elderly
# hemodialysis patients?

# 1. DATA LOADING AND PREPARATION

# Load the dataset
data <- read.csv("Frailty_dataset_CLEAN.csv")

# Complete case analysis
data_complete <- na.omit(data)
cat("Sample size (complete cases): N =", nrow(data_complete), "\n")

# 2. UNIVARIATE LINEAR REGRESSIONS (Preliminary Plots)

par(mfrow = c(3, 4))

# Row 1
boxplot(MPI_score ~ sex, data = data, 
        main = "MPI score VS Sex",
        xlab = "Sex", ylab = "MPI score",
        col = "gray")

plot(data$age, data$MPI_score, 
     main = "MPI score VS Age",
     xlab = "Age (years)", ylab = "MPI score")

plot(data$BMI, data$MPI_score, 
     main = "MPI score VS BMI",
     xlab = expression("BMI (kg/m"^2*")"), ylab = "MPI score")

plot(data$weight_loss_6mo_pct, data$MPI_score, 
     main = "MPI score VS Weight loss",
     xlab = "Weight loss 6 months (%)", ylab = "MPI score")

# Row 2
plot(data$ferritin, data$MPI_score, 
     main = "MPI score VS Ferritin",
     xlab = "Ferritin (ng/mL)", ylab = "MPI score")

plot(data$phosphorus, data$MPI_score, 
     main = "MPI score VS Phosphorus",
     xlab = "Phosphorus (mg/dL)", ylab = "MPI score")

plot(data$PTH, data$MPI_score, 
     main = "MPI score VS PTH",
     xlab = "PTH (pg/mL)", ylab = "MPI score")

plot(data$HCO3, data$MPI_score, 
     main = "MPI score VS HCO3",
     xlab = "HCO3 (mEq/L)", ylab = "MPI score")

# Row 3
plot(data$albumin, data$MPI_score, 
     main = "MPI score VS Albumin",
     xlab = "Albumin (g/dL)", ylab = "MPI score")

# Filter diabetes to only 0 and 1
data_dm <- data[data$diabetes %in% c(0, 1), ]
boxplot(MPI_score ~ diabetes, data = data_dm, 
        main = "MPI score VS Diabetes",
        xlab = "Diabetes", ylab = "MPI score",
        names = c("0 No DM", "1 DM"),
        col = "gray")

plot(data$ERI, data$MPI_score, 
     main = "MPI score VS ERI",
     xlab = "ERI", ylab = "MPI score")

# 3. MULTIVARIATE LINEAR REGRESSION

# Full model (All 11 covariates)
model_full <- lm(MPI_score ~ sex + age + BMI + weight_loss_6mo_pct + 
                   ferritin + phosphorus + PTH + HCO3 + albumin + 
                   factor(diabetes) + ERI, 
                 data = data_complete)

cat("\n1. Full model (All 11 covariates)\n")
summary(model_full)

# Step-down model (Backward Elimination)
model_stepdown <- step(model_full, direction = "backward", trace = 0)

cat("\n2. Step-down model (Backward Elimination)\n")
summary(model_stepdown)

# Step-up model (Forward Selection)
model_null <- lm(MPI_score ~ 1, data = data_complete)
model_stepup <- step(model_null, 
                     scope = list(lower = model_null, upper = model_full),
                     direction = "forward", trace = 0)

cat("\n3. Step-up model (Forward Selection)\n")
summary(model_stepup)

# AIC comparison
cat("\n4. AIC comparison\n")
cat("Full Model AIC:", AIC(model_full), "\n")
cat("Step-down Model AIC:", AIC(model_stepdown), "\n")
cat("Step-up Model AIC:", AIC(model_stepup), "\n")

# Final model
model_final <- model_stepdown

# 4. GROUP COMPARISON ANALYSIS (Diabetes)

# Filter to only keep diabetes values 0 and 1
data_diabetes <- data_complete[data_complete$diabetes %in% c(0, 1), ]

# Mean MPI score by diabetes status
mpi_by_diabetes <- aggregate(MPI_score ~ diabetes, data = data_diabetes, 
                              FUN = function(x) c(mean = mean(x), sd = sd(x)))
mpi_by_diabetes <- do.call(data.frame, mpi_by_diabetes)
colnames(mpi_by_diabetes) <- c("diabetes", "MPI_score.mean", "MPI_score.sd")
print(mpi_by_diabetes)

# Welch two-sample t-test
t.test(MPI_score ~ diabetes, data = data_diabetes)

# 5. MODEL DIAGNOSTICS

# Extract residuals and fitted values from the final model
residuals_final <- residuals(model_final)
fitted_final <- fitted(model_final)

# Create diagnostic plots
par(mfrow = c(1, 3))

# Histogram of residuals with normal curve overlay
hist(residuals_final, 
     probability = TRUE,
     main = "Histogram of residuals",
     xlab = "Residuals",
     ylab = "Density",
     col = "lightblue")
x_seq <- seq(-0.5, 0.5, length.out = 100)
lines(x_seq, dnorm(x_seq, mean = mean(residuals_final), sd = sd(residuals_final)), 
      col = "red", lwd = 2)

# Normal Q-Q plot
qqnorm(residuals_final, 
       main = "Normal Q-Q Plot",
       xlab = "Theoretical Quantiles",
       ylab = "Sample Quantiles")
qqline(residuals_final, col = "red", lwd = 2)

# Residuals vs Fitted values
plot(fitted_final, residuals_final,
     main = "Residuals VS Fitted",
     xlab = "Fitted",
     ylab = "Residuals")
abline(h = 0, col = "red", lty = 2, lwd = 2)
