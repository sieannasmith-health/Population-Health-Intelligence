# Population Health Intelligence | Adjusted Prevalence
library(survey)

# 1. Prepare Analysis Data -------------------------------------
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

# 2. Survey Design and Model -----------------------------------
options(survey.lonely.psu = "adjust")
design <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
                    weights = ~WTMEC2YR, nest = TRUE, data = d)
a <- subset(design, included)
fit <- svyglm(high_hba1c ~ income + education + RIDAGEYR + sex +
               race_ethnicity, design = a, family = quasibinomial())

# 3. Marginal Standardization ----------------------------------
# For each group, predict every participant as if in that group.
# Keep the observed age, sex, race/ethnicity and other SES variable.
standardize <- function(variable, categories) {
  output <- lapply(categories, function(category) {
    scenario <- a$variables
    scenario[[variable]] <- factor(category,
      levels = levels(a$variables[[variable]]))
    x <- model.matrix(delete.response(terms(fit)), scenario,
                      contrasts.arg = fit$contrasts)
    beta <- coef(fit)
    pred <- plogis(drop(x %*% beta))
    w <- weights(a, type = "sampling")
    average <- weighted.mean(pred, w)
    # Delta-method gradient for the standardized weighted mean.
    gradient <- colSums(x * as.vector(w * pred * (1 - pred))) / sum(w)
    se <- sqrt(drop(t(gradient) %*% vcov(fit) %*% gradient))
    critical <- qt(.975, degf(a))
    data.frame(dimension = variable, category = category,
      estimate = average, se = se,
      lower = max(0, average - critical * se),
      upper = min(1, average + critical * se))
  })
  do.call(rbind, output)
}

income <- standardize("income", levels(d$income))
education <- standardize("education", levels(d$education))
result <- rbind(income, education)
result[, 3:6] <- round(100 * result[, 3:6], 2)
print(result, row.names = FALSE)

# 4. Save ------------------------------------------------------
write.csv(result, "reports/06_adjusted_prevalence.csv",
          row.names = FALSE)
png("reports/06_adjusted_prevalence.png", width = 1200,
    height = 800, res = 140)
par(mfrow = c(1, 2), mar = c(9, 4.5, 3, 1))
for (group in c("income", "education")) {
  z <- subset(result, dimension == group)
  m <- barplot(z$estimate, names.arg = z$category,
    las = 2, col = "#4B806C", ylim = c(0, max(z$upper) * 1.2),
    ylab = "Adjusted prevalence (%)", main = group)
  arrows(m, z$lower, m, z$upper, angle = 90, code = 3,
         length = .06)
}
dev.off()
