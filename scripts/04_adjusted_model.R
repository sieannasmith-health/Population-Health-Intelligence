# Population Health Intelligence | Adjusted Model
library(survey)

# 1. Prepare Data ----------------------------------------------
d <- read.csv("data/processed/adult_hba1c_audit.csv")
d$high_hba1c <- ifelse(is.na(d$LBXGH), NA,
                       as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                labels = c("<=1", "1-2", "2-4", ">4"))
d$education <- factor(d$DMDEDUC2, levels = 1:5,
  labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
d$sex <- factor(d$RIAGENDR, levels = 1:2,
                labels = c("Male", "Female"))
d$race_ethnicity <- factor(d$RIDRETH3)

# 2. Analytic Sample -------------------------------------------
needed <- c("high_hba1c", "income", "education", "RIDAGEYR",
            "sex", "race_ethnicity", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
complete <- complete.cases(d[needed]) & d$WTMEC2YR > 0
cat("Adults:", nrow(d), "| Complete cases:", sum(complete), "\n")
print(table(d$high_hba1c[complete]))

# 3. Survey Design ---------------------------------------------
options(survey.lonely.psu = "adjust")
design <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                    weights = ~WTMEC2YR, nest = TRUE, data = d)
analytic <- subset(design, complete)

# 4. Adjusted Model --------------------------------------------
fit <- svyglm(high_hba1c ~ income + education + RIDAGEYR + sex +
               race_ethnicity, design = analytic,
             family = quasibinomial())

# 5. Odds Ratios and Confidence Intervals ----------------------
b <- coef(fit)
se <- sqrt(diag(vcov(fit)))
df_survey <- degf(analytic)
critical <- qt(0.975, df = df_survey)
ci <- cbind(b - critical * se, b + critical * se)
cat("Survey design degrees of freedom:", df_survey, "\n")
results <- data.frame(
  term = names(b),
  odds_ratio = round(exp(b), 3),
  lower_95 = round(exp(ci[, 1]), 3),
  upper_95 = round(exp(ci[, 2]), 3),
  p_value = signif(2 * pt(-abs(b / se), df = df_survey), 3)
)
print(results, row.names = FALSE)

# 6. Output ----------------------------------------------------
write.csv(results, "reports/04_adjusted_model_odds_ratios.csv",
          row.names = FALSE)
