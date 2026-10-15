# Population Health Intelligence | Income Missingness Sensitivity
library(survey)
d <- read.csv("data/processed/all_age_hba1c_survey.csv")
d$high <- ifelse(is.na(d$LBXGH), NA, as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                labels=c("<=1", "1-2", "2-4", ">4"))
d$education <- factor(d$DMDEDUC2, levels=1:5,
  labels=c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
d$sex <- factor(d$RIAGENDR, levels=1:2,
                labels=c("Male", "Female"))
d$race <- factor(d$RIDRETH3, levels=c(1,2,3,4,6,7))
d$income_status <- factor(ifelse(is.na(d$income), "Missing", "Observed"),
                          levels=c("Observed", "Missing"))
base_fields <- c("high", "education", "RIDAGEYR", "sex", "race",
                 "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
d$eligible <- d$RIDAGEYR >= 20 & complete.cases(d[base_fields]) &
              d$WTMEC2YR > 0
d$eligible[is.na(d$eligible)] <- FALSE
options(survey.lonely.psu="adjust")
s <- svydesign(ids=~SDMVPSU, strata=~SDMVSTRA,
               weights=~WTMEC2YR, nest=TRUE, data=d)
a <- subset(s, eligible)
cat("Outcome-observed eligible, regardless of income:",
    nrow(a$variables), "\n")
cat("Income status in eligible sample:\n")
print(table(a$variables$income_status))
prev <- svyby(~high, ~income_status, a, svymean,
              na.rm=TRUE, vartype=c("se", "ci"))
print(prev)
# Descriptive adjusted comparison, not imputation or MAR test.
fit <- svyglm(high ~ income_status + education + RIDAGEYR + sex + race,
              design=a, family=quasibinomial())
b <- coef(fit)["income_statusMissing"]
se <- sqrt(vcov(fit)["income_statusMissing","income_statusMissing"])
ci <- exp(b + c(-1,1)*qt(.975,degf(a))*se)
cat("Missing-vs-observed income adjusted OR:",exp(b),
    "95% CI:",ci,"\n")
write.csv(data.frame(status=as.character(prev$income_status),
  n=as.integer(table(a$variables$income_status)[as.character(prev$income_status)]),
  prevalence_pct=100*prev$high,
  lower_pct=100*prev$ci_l,upper_pct=100*prev$ci_u),
  "reports/19_income_missingness_prevalence.csv",row.names=FALSE)
write.csv(data.frame(contrast="Missing vs observed income",
  adjusted_or=exp(b),lower_or=ci[1],upper_or=ci[2]),
  "reports/19_income_missingness_adjusted.csv",row.names=FALSE)
