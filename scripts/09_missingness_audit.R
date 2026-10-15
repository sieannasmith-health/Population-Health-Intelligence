# Population Health Intelligence | Missingness and Eligibility
library(survey)

# 1. Cohort ----------------------------------------------------
d <- read.csv("data/processed/adult_hba1c_audit.csv")
d$high <- ifelse(is.na(d$LBXGH), NA, as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                labels = c("<=1", "1-2", "2-4", ">4"))
d$education <- factor(d$DMDEDUC2, levels = 1:5,
  labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
vars <- c("high", "income", "education", "RIDAGEYR",
          "RIAGENDR", "RIDRETH3", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
d$included <- complete.cases(d[vars]) & d$WTMEC2YR > 0

# 2. Unweighted Missingness ------------------------------------
summary <- data.frame(
  field = c("HbA1c", "Income PIR", "Education", "Any model field"),
  missing = c(sum(is.na(d$LBXGH)), sum(is.na(d$income)),
              sum(is.na(d$education)), sum(!d$included))
)
summary$percent <- round(100 * summary$missing / nrow(d), 2)
print(summary, row.names = FALSE)
cat("\nAge by inclusion status:\n")
print(aggregate(RIDAGEYR ~ included, d, mean))
cat("\nSex by inclusion status:\n")
print(table(d$RIAGENDR, d$included))
cat("\nRace/ethnicity codes by inclusion status:\n")
print(table(d$RIDRETH3, d$included))
cat("\nEducation by inclusion status:\n")
print(table(d$education, d$included, useNA = "ifany"))
cat("\nIncome by inclusion status:\n")
print(table(d$income, d$included, useNA = "ifany"))

# 3. Weighted Selection Pattern -------------------------------
options(survey.lonely.psu = "adjust")
design <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                    weights = ~WTMEC2YR, nest = TRUE, data = d)
d$included_num <- as.integer(d$included)
design <- update(design, included_num = as.integer(included))
cat("\nWeighted analytic inclusion by sex:\n")
print(svyby(~included_num, ~RIAGENDR, design,
            svymean, na.rm = TRUE, vartype = "ci"))

# 4. Outputs ---------------------------------------------------
write.csv(summary, "reports/09_missingness_summary.csv",
          row.names = FALSE)
