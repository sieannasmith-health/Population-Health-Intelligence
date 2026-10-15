# Population Health Intelligence | Model Validation
library(survey)

# 1. Recreate Analysis Variables ------------------------------
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
needed <- c("high_hba1c", "income", "education", "RIDAGEYR",
            "sex", "race_ethnicity", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
d$included <- complete.cases(d[needed]) & d$WTMEC2YR > 0

# 2. Sample Audit ----------------------------------------------
cat("Included / excluded:\n")
print(table(d$included))
cat("Mean age by inclusion:\n")
print(tapply(d$RIDAGEYR, d$included, mean, na.rm = TRUE))
cat("Outcome recorded by inclusion:\n")
print(table(d$included, is.na(d$high_hba1c)))
cat("Income cells (complete cases):\n")
print(table(d$income[d$included], d$high_hba1c[d$included]))
cat("Education cells (complete cases):\n")
print(table(d$education[d$included], d$high_hba1c[d$included]))

# 3. Survey-Weighted Sensitivity Models -----------------------
options(survey.lonely.psu = "adjust")
design <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                    weights = ~WTMEC2YR, nest = TRUE, data = d)
a <- subset(design, included)
base <- svyglm(high_hba1c ~ income + education + RIDAGEYR + sex +
                 race_ethnicity, design = a, family = quasibinomial())
quadratic <- svyglm(high_hba1c ~ income + education + RIDAGEYR +
                      I(RIDAGEYR^2) + sex + race_ethnicity,
                    design = a, family = quasibinomial())

# 4. Compare Specified Contrasts -------------------------------
extract <- function(fit, label) {
  terms <- c("income>4", "educationCollege+", "RIDAGEYR", "sexFemale")
  b <- coef(fit)[terms]
  se <- sqrt(diag(vcov(fit)))[terms]
  crit <- qt(.975, df = degf(a))
  data.frame(model = label, term = terms,
    odds_ratio = round(exp(b), 3),
    lower = round(exp(b - crit * se), 3),
    upper = round(exp(b + crit * se), 3))
}
comparison <- rbind(extract(base, "Linear age"),
                    extract(quadratic, "Quadratic age"))
print(comparison, row.names = FALSE)
cat("Survey df:", degf(a), "\n")
cat("Quadratic age coefficient:",
    coef(quadratic)["I(RIDAGEYR^2)"], "\n")

# 5. Export ----------------------------------------------------
write.csv(comparison, "reports/05_model_sensitivity.csv",
          row.names = FALSE)
