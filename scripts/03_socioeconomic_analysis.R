# Population Health Intelligence | Socioeconomic Analysis
library(survey)

# 1. Data ------------------------------------------------------
d <- read.csv("data/processed/adult_hba1c_audit.csv")
d$hba1c_high <- ifelse(is.na(d$LBXGH), NA,
                       as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                labels = c("<=1", "1-2", "2-4", ">4"))
d$education <- factor(d$DMDEDUC2, levels = 1:5,
  labels = c("<9th grade", "9-11th grade", "HS/GED",
             "Some college/AA", "College+"))

# 2. Missingness -----------------------------------------------
cat("Adult records:", nrow(d), "\n")
print(colSums(is.na(d[c("LBXGH", "income", "education")])))
cat("HbA1c + income complete:",
    sum(complete.cases(d[c("LBXGH", "income")])), "\n")
cat("HbA1c + education complete:",
    sum(complete.cases(d[c("LBXGH", "education")])), "\n")

# 3. Survey Design ---------------------------------------------
options(survey.lonely.psu = "adjust")
design <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                    weights = ~WTMEC2YR, nest = TRUE, data = d)

# 4. Survey-Weighted Prevalence --------------------------------
by_income <- svyby(~hba1c_high, ~income, design,
                   svymean, na.rm = TRUE, vartype = c("se", "ci"))
by_education <- svyby(~hba1c_high, ~education, design,
                      svymean, na.rm = TRUE, vartype = c("se", "ci"))

format_results <- function(x, group) {
  data.frame(group_type = group, category = as.character(x[[1]]),
    prevalence_pct = round(100 * x$hba1c_high, 2),
    se_pp = round(100 * x$se, 2),
    lower_pct = round(100 * x$ci_l, 2),
    upper_pct = round(100 * x$ci_u, 2))
}
results <- rbind(format_results(by_income, "Income-to-poverty ratio"),
                 format_results(by_education, "Education"))
print(results, row.names = FALSE)

# 5. Deliverables ----------------------------------------------
dir.create("reports", showWarnings = FALSE)
write.csv(results, "reports/03_socioeconomic_prevalence.csv",
          row.names = FALSE)
png("reports/03_socioeconomic_prevalence.png", width = 1200,
    height = 850, res = 140)
par(mfrow = c(1, 2), mar = c(9, 4.5, 3, 1))
for (x in list(by_income, by_education)) {
  y <- 100 * x$hba1c_high
  names(y) <- as.character(x[[1]])
  mids <- barplot(y, las = 2, col = "#4B806C",
                  ylim = c(0, max(100 * x$ci_u) * 1.25),
                  ylab = "Weighted prevalence (%)",
                  main = if (identical(x, by_income)) "Income" else "Education")
  arrows(mids, 100 * x$ci_l, mids, 100 * x$ci_u,
         angle = 90, code = 3, length = 0.06)
}
dev.off()
