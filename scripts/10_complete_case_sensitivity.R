# Population Health Intelligence | Complete-Case Sensitivity
library(survey)

# 1. Data -----------------------------------------------------
d <- read.csv("data/processed/adult_hba1c_audit.csv")
d$high <- ifelse(is.na(d$LBXGH), NA,
                 as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                labels = c("<=1", "1-2", "2-4", ">4"))
d$education <- factor(d$DMDEDUC2, levels = 1:5,
  labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
needed <- c("high", "income", "education", "RIDAGEYR",
            "RIAGENDR", "RIDRETH3", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
d$complete <- complete.cases(d[needed]) & d$WTMEC2YR > 0
d$observed <- !is.na(d$high) & !is.na(d$WTMEC2YR) &
              d$WTMEC2YR > 0

# 2. Identical Survey Design ----------------------------------
options(survey.lonely.psu = "adjust")
s <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
               weights = ~WTMEC2YR, nest = TRUE, data = d)
all_observed <- subset(s, observed)
complete_case <- subset(s, complete)

# 3. Comparable Marginal Outcome Estimates --------------------
extract <- function(x, label) {
  z <- svymean(~high, x, na.rm = TRUE)
  ci <- confint(z)
  data.frame(sample = label, n = nrow(x$variables),
             estimate_pct = 100 * coef(z)[1],
             lower_pct = 100 * ci[1], upper_pct = 100 * ci[2])
}
results <- rbind(extract(all_observed, "HbA1c observed"),
                 extract(complete_case, "Full model complete case"))
results$estimate_pct <- round(results$estimate_pct, 2)
results$lower_pct <- round(results$lower_pct, 2)
results$upper_pct <- round(results$upper_pct, 2)
print(results, row.names = FALSE)
cat("Complete minus observed (percentage points):",
    round(diff(results$estimate_pct), 2), "\n")

# 4. Group-Specific Retention ---------------------------------
print(table(d$education, d$complete, useNA = "ifany"))
print(table(d$income, d$complete, useNA = "ifany"))

# 5. Output ---------------------------------------------------
write.csv(results, "reports/10_complete_case_sensitivity.csv",
          row.names = FALSE)
