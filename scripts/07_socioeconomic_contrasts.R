# Population Health Intelligence | Adjusted Contrasts
library(survey)
source("scripts/06_adjusted_prevalence.R", echo = FALSE)

# 1. Standardized Estimate and Gradient -----------------------
standardized <- function(variable, category) {
  z <- a$variables
  z[[variable]] <- factor(category, levels = levels(z[[variable]]))
  x <- model.matrix(delete.response(terms(fit)), z,
                    contrasts.arg = fit$contrasts)
  p <- plogis(drop(x %*% coef(fit)))
  w <- weights(a, type = "sampling")
  g <- colSums(x * as.vector(w * p * (1 - p))) / sum(w)
  list(p = weighted.mean(p, w), gradient = g)
}

# 2. Contrast Two Standardized Groups -------------------------
contrast <- function(variable, reference, comparison) {
  r <- standardized(variable, reference)
  c <- standardized(variable, comparison)
  difference <- c$p - r$p
  g <- c$gradient - r$gradient
  se <- sqrt(drop(t(g) %*% vcov(fit) %*% g))
  df <- degf(a)
  crit <- qt(.975, df)
  data.frame(factor = variable, reference = reference,
    comparison = comparison, difference_pp = 100 * difference,
    se_pp = 100 * se, lower_pp = 100 * (difference - crit * se),
    upper_pp = 100 * (difference + crit * se),
    p_value = 2 * pt(-abs(difference / se), df))
}

contrasts <- rbind(
  contrast("income", "<=1", ">4"),
  contrast("education", "<9th", "College+")
)
print(contrasts, row.names = FALSE)

# 3. Overall Tests for Socioeconomic Terms --------------------
income_test <- regTermTest(fit, ~income)
education_test <- regTermTest(fit, ~education)
cat("\nOverall income effect:\n")
print(income_test)
cat("\nOverall education effect:\n")
print(education_test)

# 4. Save -----------------------------------------------------
write.csv(contrasts, "reports/07_adjusted_contrasts.csv",
          row.names = FALSE)
