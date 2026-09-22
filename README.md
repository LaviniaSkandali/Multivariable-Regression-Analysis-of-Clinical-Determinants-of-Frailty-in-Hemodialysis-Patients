# Multivariable-Regression-Analysis-of-Clinical-Determinants-of-Frailty-in-Hemodialysis-Patients
A cross-sectional analysis in R of how nutritional and clinical factors relate to frailty (Multidimensional Prognostic Index) in hemodialysis patients aged 65 and over. It uses multiple linear regression, Welch's two-sample t-test and residual diagnostics.

# Nutritional and Clinical Determinants of Frailty in Elderly Hemodialysis Patients: A Multivariable Regression Analysis
*January 2026*

---

## Abstract

Frailty is a clinically recognisable state of increased vulnerability resulting from age-associated decline across multiple physiological systems. It is a recognised predictor of disability, hospitalisation and mortality. Patients undergoing maintenance hemodialysis are particularly exposed to frailty because of recurrent metabolic stress, dietary restriction and treatment-related inflammation.

This study examines how nutritional and clinical characteristics contribute to variation in frailty, measured by the Multidimensional Prognostic Index (MPI), in a cohort of hemodialysis patients aged 65 years and older (n = 101). The characteristics considered are malnutrition status defined by the Global Leadership Initiative on Malnutrition (GLIM), body composition, serum albumin, dialysis adequacy, comorbidity burden, age and sex. Two methods are used:

- a multiple linear regression model, which estimates the adjusted contribution of each factor;
- a Welch two-sample t-test, which compares frailty between malnourished and non-malnourished patients.

The regression model explains a substantial proportion of the variance in frailty (adjusted R² = 0.41; F(8, 92) = 9.66, p < 0.001). Three variables are independently and inversely associated with MPI:

- lean tissue index (β = −0.032, p < 0.001);
- fat mass percentage (β = −0.004, p = 0.019);
- serum albumin (β = −0.083, p = 0.025).

Malnourished patients showed significantly higher mean frailty than non-malnourished patients in the unadjusted comparison (0.44 vs 0.33; t = 4.12, p < 0.001). However, GLIM status was not independently associated with frailty after adjustment for body composition and clinical covariates (p = 0.393). This divergence between unadjusted and adjusted estimates suggests that the association between malnutrition and frailty may operate largely through more specific nutritional markers, particularly muscle mass and albumin concentration.

---

## Research Question

> How do nutritional and clinical factors influence frailty in elderly hemodialysis patients?

---

## Data

The analysis uses an anonymised clinical dataset of patients aged 65 years and older receiving maintenance hemodialysis. The data were collected during routine clinical assessment, and each observation corresponds to a single patient. Observations with missing values in the outcome or key covariates were excluded, giving a complete-case sample of 101 patients out of an initial 123.

| Variable | Description | Type |
|---|---|---|
| MPI | Multidimensional Prognostic Index (0–1; higher values indicate greater frailty) | Continuous (outcome) |
| GLIM | Malnutrition status | Binary |
| LTI | Lean Tissue Index (kg/m²) | Continuous |
| Fat mass | Fat mass (%) | Continuous |
| Albumin | Serum albumin (g/dL) | Continuous |
| Kt/V | Dialysis adequacy | Continuous |
| CIRS | Cumulative Illness Rating Scale (comorbidity burden) | Continuous |
| Age | Age (years) | Continuous |
| Sex | Sex | Binary |

**Data availability.** The dataset contains confidential clinical information. It is not publicly available and is not included in this repository.

---

## Methods

1. **Exploratory analysis.** We examined the distribution of MPI, compared MPI across GLIM categories, and plotted the bivariate association between MPI and lean tissue index.
2. **Group comparison.** We applied Welch's two-sample t-test to compare mean MPI between malnourished and non-malnourished patients. Welch's version was chosen to allow for unequal variances between groups.
3. **Multivariable regression.** We fitted an ordinary least squares model:

```
   MPI ~ GLIM + LTI + Fat% + Albumin + Kt/V + Age + Sex + CIRS
```

4. **Model diagnostics.** We checked the regression assumptions by inspecting four residual plots: residuals versus fitted values, the normal Q–Q plot, the scale–location plot, and residuals versus leverage with Cook's distance contours.

All analyses were performed in R.

---

## Results

### Descriptive statistics (n = 101)

| Variable | Mean ± SD |
|---|---|
| MPI | 0.37 ± 0.14 |
| Age (years) | 77.58 ± 6.47 |
| LTI (kg/m²) | 12.86 ± 2.49 |
| Fat mass (%) | 33.49 ± 9.03 |
| Albumin (g/dL) | 3.86 ± 0.32 |
| Kt/V | 1.40 ± 0.25 |
| CIRS | 13.43 ± 3.17 |

- **GLIM classification:** no malnutrition 61 (60.4%), moderate malnutrition 20 (19.8%), severe malnutrition 20 (19.8%).
- **Sex:** male 81 (80.2%), female 20 (19.8%).

### Multiple linear regression

| Predictor | Estimate | Std. Error | t | p |
|---|---:|---:|---:|---:|
| Intercept | 0.919 | 0.315 | 2.92 | 0.004 |
| GLIM malnutrition | 0.014 | 0.016 | 0.86 | 0.393 |
| Lean Tissue Index | −0.032 | 0.008 | −3.98 | < 0.001 |
| Fat mass (%) | −0.004 | 0.002 | −2.38 | 0.019 |
| Albumin | −0.083 | 0.037 | −2.28 | 0.025 |
| Kt/V | 0.001 | 0.048 | 0.02 | 0.982 |
| Age | 0.004 | 0.002 | 1.90 | 0.061 |
| Sex | −0.021 | 0.031 | −0.67 | 0.503 |
| CIRS | 0.005 | 0.004 | 1.50 | 0.138 |

- **Model fit:** residual standard error = 0.107 on 92 df; R² = 0.457; adjusted R² = 0.409; F(8, 92) = 9.66, p = 1.2 × 10⁻⁹.
- **Standardised effect of LTI:** a one-standard-deviation increase in lean tissue index corresponds to a decrease of about 0.08 in MPI. This is roughly 0.57 standard deviations of the outcome, making LTI the strongest predictor in the model.

### Group comparison

| Group | Mean MPI |
|---|---|
| Malnourished | 0.44 |
| Non-malnourished | 0.33 |

Welch's t = 4.12, p < 0.001. The 95% confidence interval for the difference in means excludes zero.

### Diagnostics

- **Linearity:** residuals showed no systematic pattern against fitted values.
- **Homoscedasticity:** the spread of residuals was approximately constant.
- **Normality:** residuals were approximately normally distributed, with minor deviations in the tails.
- **Influence:** no observation exceeded conventional Cook's distance thresholds.

---

## Discussion

Body composition and biochemical markers of nutrition emerged as the principal correlates of frailty in this population. Lean tissue index was the strongest independent predictor, followed by fat mass percentage and serum albumin.

GLIM-defined malnutrition was strongly associated with frailty in the unadjusted comparison but not after multivariable adjustment. This contrast illustrates the distinction between marginal and conditional associations. It is consistent with the hypothesis that the categorical malnutrition classification captures variance that is more precisely represented by continuous measures of muscle mass and nutritional biochemistry.

### Limitations

- **Design.** The cross-sectional design precludes causal inference.
- **Sample.** The sample is moderate in size and drawn from a single centre, which limits generalisability.
- **Missing data.** Complete-case analysis excluded 22 observations, mainly because of missing body composition data. This may introduce selection bias if the data are not missing completely at random.
- **Outcome measure.** The MPI is a composite index and may not capture every dimension of vulnerability relevant to hemodialysis patients.
- **Multiple comparisons.** No adjustment for multiple comparisons was applied to the coefficient tests.

### Future work

- Longitudinal designs to assess how frailty changes over time.
- Formal mediation analysis of the GLIM → body composition → frailty pathway.
- Multiple imputation to assess sensitivity to missing data.
- Beta regression to model the bounded outcome directly.
- Inclusion of functional and inflammatory markers.

---


## References

1. Xue QL. The frailty syndrome: Definition and natural history. *Clinics in Geriatric Medicine*. 2011;27(1):1–15.
2. Morley JE, Vellas B, Abellan van Kan G, et al. Frailty Consensus: A Call to Action. *Journal of the American Medical Directors Association*. 2013;14(6):392–7.
3. Pilotto A, Ferrucci L, Franceschi M, et al. Development and Validation of a Multidimensional Prognostic Index for One-Year Mortality from Comprehensive Geriatric Assessment in Hospitalized Older Patients. *Rejuvenation Research*. 2008;11(1):151–61.
4. Cederholm T, Jensen GL, Correia MITD, et al. GLIM criteria for the diagnosis of malnutrition: A consensus report from the global clinical nutrition community. *Clinical Nutrition*. 2019;38(1):1–9.
