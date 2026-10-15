# Population Health Intelligence | Survey and Codebook Audit
library(survey)
d <- read.csv("data/processed/adult_hba1c_audit.csv")
stopifnot(all(d$RIDAGEYR >= 20), !anyDuplicated(d$SEQN))
expected <- list(DMDEDUC2 = c(1,2,3,4,5,7,9),
                 RIDRETH3 = c(1,2,3,4,6,7), RIAGENDR = c(1,2))
for (v in names(expected)) {
  stopifnot(all(na.omit(unique(d[[v]])) %in% expected[[v]]))
  cat(v, ": ", paste(names(table(d[[v]])), collapse = ", "), "\n", sep="")
}
cat("Adult source records:", nrow(d), "\n")
cat("Missing HbA1c:", sum(is.na(d$LBXGH)), "\n")
cat("Missing family PIR:", sum(is.na(d$INDFMPIR)), "\n")
cat("Positive MEC weights:", sum(d$WTMEC2YR > 0), "\n")
stopifnot(all(d$LBXGH[!is.na(d$LBXGH)] > 0))

# Recreate full regression eligibility without dropping survey units.
d$education <- ifelse(d$DMDEDUC2 %in% 1:5,
                       d$DMDEDUC2, NA)
d$high <- ifelse(is.na(d$LBXGH), NA,
                 as.integer(d$LBXGH >= 6.5))
req <- c("high", "INDFMPIR", "education", "RIDAGEYR",
         "RIAGENDR", "RIDRETH3", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
d$analytic <- complete.cases(d[req]) & d$WTMEC2YR > 0
cat("Full model sample:", sum(d$analytic), "\n")
cat("Strata:", length(unique(d$SDMVSTRA)), "\n")
cat("Stratum-PSU combinations:", nrow(unique(d[c("SDMVSTRA", "SDMVPSU")])), "\n")
options(survey.lonely.psu = "adjust")
design <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                    weights = ~WTMEC2YR, nest = TRUE, data = d)
a <- subset(design, analytic)
cat("Full design DF:", degf(design), "\n")
cat("Model domain DF:", degf(a), "\n")

# Caveat: the source adult CSV excludes persons younger than age 20,
# so the original all-ages sample cannot be reconstructed from it.
checks <- data.frame(
  check = c("Unique IDs", "Adult age", "Expected category codes",
            "Valid measured HbA1c", "Positive MEC weights",
            "Retained original all-age design"),
  result = c("Pass", "Pass", "Pass", "Pass",
             "Reviewed", "Not in processed adult CSV"))
print(checks, row.names = FALSE)
write.csv(checks, "reports/12_survey_codebook_checks.csv",
          row.names = FALSE)
