# Population Health Intelligence | Full-Design Model Replication
library(survey)
all <- read.csv("data/processed/all_age_hba1c_survey.csv")
old <- read.csv("data/processed/adult_hba1c_audit.csv")
prepare <- function(d) {
  d$high <- ifelse(is.na(d$LBXGH), NA, as.integer(d$LBXGH >= 6.5))
  d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                  labels = c("<=1", "1-2", "2-4", ">4"))
  d$education <- factor(d$DMDEDUC2, levels = 1:5,
    labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
  d$sex <- factor(d$RIAGENDR, levels = 1:2,
                  labels = c("Male", "Female"))
  d$race <- factor(d$RIDRETH3, levels = c(1, 2, 3, 4, 6, 7))
  needed <- c("high", "income", "education", "RIDAGEYR", "sex",
              "race", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
  d$eligible <- d$RIDAGEYR >= 20 & complete.cases(d[needed]) &
                !is.na(d$WTMEC2YR) & d$WTMEC2YR > 0
  d$eligible[is.na(d$eligible)] <- FALSE
  d
}
all <- prepare(all)
old <- prepare(old)
options(survey.lonely.psu = "adjust")
make_design <- function(d) {
  s <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                 weights = ~WTMEC2YR, nest = TRUE, data = d)
  subset(s, eligible)
}
current <- make_design(all)
previous <- make_design(old)
formula <- high ~ income + education + RIDAGEYR + sex + race
fit_current <- svyglm(formula, current, family = quasibinomial())
fit_previous <- svyglm(formula, previous, family = quasibinomial())
stopifnot(identical(names(coef(fit_current)),
                    names(coef(fit_previous))))
compare <- data.frame(term = names(coef(fit_current)),
  previous_beta = coef(fit_previous),
  full_domain_beta = coef(fit_current),
  previous_se = sqrt(diag(vcov(fit_previous))),
  full_domain_se = sqrt(diag(vcov(fit_current))))
compare$beta_diff <- compare$full_domain_beta - compare$previous_beta
compare$se_diff <- compare$full_domain_se - compare$previous_se
cat("N previous/new:", nrow(previous$variables),
    nrow(current$variables), "\n")
cat("Design DF previous/new:", degf(previous), degf(current), "\n")
cat("Maximum coefficient difference:", max(abs(compare$beta_diff)), "\n")
cat("Maximum SE difference:", max(abs(compare$se_diff)), "\n")
print(compare[, c("term", "beta_diff", "se_diff")], row.names = FALSE)
write.csv(compare, "reports/14_model_replication.csv", row.names = FALSE)
stopifnot(max(abs(compare$beta_diff)) < 1e-8,
          max(abs(compare$se_diff)) < 1e-8)
cat("PASS: all adjusted coefficients and SEs reproduced.\n")

# Marginal standardization against previously saved results.
standardized <- function(fit, design, variable, category) {
  z <- design$variables
  z[[variable]] <- factor(category, levels = levels(z[[variable]]))
  x <- model.matrix(delete.response(terms(fit)), z,
                    contrasts.arg = fit$contrasts)
  p <- plogis(drop(x %*% coef(fit)))
  w <- weights(design, type = "sampling")
  g <- colSums(x * as.vector(w * p * (1 - p))) / sum(w)
  c(prevalence_pct = 100 * weighted.mean(p, w),
    se_pp = 100 * sqrt(drop(t(g) %*% vcov(fit) %*% g)))
}
rows <- list()
for (variable in c("income", "education")) {
  for (category in levels(current$variables[[variable]])) {
    now <- standardized(fit_current, current, variable, category)
    before <- standardized(fit_previous, previous, variable, category)
    rows[[length(rows) + 1L]] <- data.frame(
      dimension = variable, category = category,
      full_domain_pct = now[1], previous_pct = before[1],
      prevalence_difference_pp = now[1] - before[1],
      se_difference_pp = now[2] - before[2])
  }
}
marginal <- do.call(rbind, rows)
print(marginal, row.names = FALSE)
stopifnot(max(abs(marginal$prevalence_difference_pp)) < 1e-8,
          max(abs(marginal$se_difference_pp)) < 1e-8)
write.csv(marginal, "reports/14_marginal_replication.csv",
          row.names = FALSE)
cat("PASS: all standardized prevalences and delta-method SEs reproduced.\n")
