# Population Health Intelligence | Reconstruct Adult Survey Domain
library(survey)
all <- read.csv("data/processed/all_age_hba1c_survey.csv")
old <- read.csv("data/processed/adult_hba1c_audit.csv")
stopifnot(!anyDuplicated(all$SEQN), sum(all$RIDAGEYR >= 20) == nrow(old))
all$high <- ifelse(is.na(all$LBXGH), NA,
                   as.integer(all$LBXGH >= 6.5))
all$income <- cut(all$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                  labels = c("<=1", "1-2", "2-4", ">4"))
all$education <- factor(all$DMDEDUC2, levels = 1:5,
  labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
old$high <- ifelse(is.na(old$LBXGH), NA,
                   as.integer(old$LBXGH >= 6.5))
old$income <- cut(old$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                  labels = c("<=1", "1-2", "2-4", ">4"))
old$education <- factor(old$DMDEDUC2, levels = 1:5,
  labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
options(survey.lonely.psu = "adjust")
full <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                  weights = ~WTMEC2YR, nest = TRUE, data = all)
prior <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                   weights = ~WTMEC2YR, nest = TRUE, data = old)
adult <- subset(full, RIDAGEYR >= 20)
weighted <- function(s, formula, by = NULL) {
  z <- if (is.null(by)) svymean(formula, s, na.rm = TRUE) else
    svyby(formula, by, s, svymean, na.rm = TRUE, vartype = "se")
  if (is.null(by)) return(data.frame(group = "all", estimate = coef(z)[1],
                                        se = SE(z)[1]))
  data.frame(group = as.character(z[[1]]),
             estimate = z$high, se = z$se)
}
compare <- function(label, formula, by = NULL) {
  before <- weighted(prior, formula, by)
  after <- weighted(adult, formula, by)
  stopifnot(identical(before$group, after$group))
  data.frame(measure = label, group = before$group,
    adult_only_pct = 100 * before$estimate,
    full_domain_pct = 100 * after$estimate,
    estimate_delta_pp = 100 * (after$estimate - before$estimate),
    adult_only_se_pp = 100 * before$se,
    full_domain_se_pp = 100 * after$se)
}
result <- rbind(compare("Overall", ~high),
                compare("Income", ~high, ~income),
                compare("Education", ~high, ~education))
cat("All-age records:", nrow(all), "\n")
cat("Design DF full, adult domain, prior:",
    degf(full), degf(adult), degf(prior), "\n")
print(result, row.names = FALSE, digits = 7)
cat("Maximum estimate difference, pp:",
    max(abs(result$estimate_delta_pp)), "\n")
cat("Maximum SE difference, pp:",
    max(abs(result$full_domain_se_pp - result$adult_only_se_pp)), "\n")
write.csv(result, "reports/13_adult_domain_comparison.csv",
          row.names = FALSE)
