# Population Health Intelligence | Adjusted Model Comparison
library(survey)
d <- read.csv("data/processed/all_age_hba1c_survey.csv")
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
options(survey.lonely.psu = "adjust")
s <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
               weights = ~WTMEC2YR, nest = TRUE, data = d)
a <- subset(s, eligible)
models <- list(
  `Age + sex` = svyglm(high ~ income + education + RIDAGEYR + sex,
                      design = a, family = quasibinomial()),
  `Age + sex + race/ethnicity` = svyglm(
    high ~ income + education + RIDAGEYR + sex + race,
    design = a, family = quasibinomial()))

# 1. Standardized Prevalence and Uncertainty ------------------
standardized <- function(fit, variable, group) {
  xdata <- a$variables
  xdata[[variable]] <- factor(group, levels = levels(xdata[[variable]]))
  x <- model.matrix(delete.response(terms(fit)), xdata,
                    contrasts.arg = fit$contrasts)
  p <- plogis(drop(x %*% coef(fit)))
  w <- weights(a, type = "sampling")
  g <- colSums(x * as.vector(w * p * (1 - p))) / sum(w)
  est <- weighted.mean(p, w)
  se <- sqrt(drop(t(g) %*% vcov(fit) %*% g))
  crit <- qt(.975, degf(a))
  list(estimate = est, se = se, lower = max(0, est-crit*se),
       upper = min(1, est+crit*se), gradient = g)
}
rows <- list(); contrasts <- list()
for (name in names(models)) {
  fit <- models[[name]]
  for (variable in c("income", "education")) {
    levels_var <- levels(a$variables[[variable]])
    vals <- setNames(lapply(levels_var, function(group)
      standardized(fit, variable, group)), levels_var)
    for (group in levels_var) {
      z <- vals[[group]]
      rows[[length(rows)+1L]] <- data.frame(model = name,
        dimension = variable, category = group,
        estimate_pct = 100*z$estimate,
        lower_pct = 100*z$lower, upper_pct = 100*z$upper)
    }
    ref <- levels_var[1]; last <- tail(levels_var, 1)
    g <- vals[[last]]$gradient - vals[[ref]]$gradient
    delta <- vals[[last]]$estimate - vals[[ref]]$estimate
    se <- sqrt(drop(t(g) %*% vcov(fit) %*% g))
    crit <- qt(.975, degf(a))
    contrasts[[length(contrasts)+1L]] <- data.frame(model = name,
      dimension = variable, reference = ref, comparison = last,
      difference_pp = 100*delta, lower_pp = 100*(delta-crit*se),
      upper_pp = 100*(delta+crit*se))
  }
}
result <- do.call(rbind, rows)
contrast_result <- do.call(rbind, contrasts)
print(round_numeric <- transform(result,
 estimate_pct=round(estimate_pct,2),lower_pct=round(lower_pct,2),
 upper_pct=round(upper_pct,2)), row.names = FALSE)
print(contrast_result, row.names = FALSE)
write.csv(result, "reports/16_model_comparison_prevalence.csv",
          row.names = FALSE)
write.csv(contrast_result, "reports/16_model_comparison_contrasts.csv",
          row.names = FALSE)

# 2. Figure: estimate + design-based uncertainty --------------
png("reports/16_model_comparison.png", width = 1600,
    height = 950, res = 150)
par(mfrow = c(1,2), mar = c(9,5,4,1), oma = c(0,0,2,0))
for (variable in c("income", "education")) {
  z <- subset(result, dimension == variable)
  lab <- unique(z$category)
  k <- length(lab)
  y1 <- z$estimate_pct[z$model == names(models)[1]]
  y2 <- z$estimate_pct[z$model == names(models)[2]]
  l1 <- z$lower_pct[z$model == names(models)[1]]
  u1 <- z$upper_pct[z$model == names(models)[1]]
  l2 <- z$lower_pct[z$model == names(models)[2]]
  u2 <- z$upper_pct[z$model == names(models)[2]]
  pos <- seq_len(k)
  plot(pos, y1, type="n", xlim=c(.5,k+.5),
       ylim=c(0,max(z$upper_pct)*1.18), xaxt="n",
       xlab="", ylab="Adjusted prevalence (%)",
       main=if (variable=="income") "Income-to-poverty ratio" else "Education")
  axis(1,at=pos,labels=lab,las=2)
  arrows(pos-.10,l1,pos-.10,u1,angle=90,code=3,length=.04,
         col="#346B59")
  arrows(pos+.10,l2,pos+.10,u2,angle=90,code=3,length=.04,
         col="#777777")
  points(pos-.10,y1,pch=19,col="#346B59",cex=1.2)
  points(pos+.10,y2,pch=17,col="#777777",cex=1.2)
  legend("topright",legend=c("Age + sex","Age + sex + race/ethnicity"),
         col=c("#346B59","#777777"),pch=c(19,17),cex=.75,bty="n")
}
mtext("NHANES 2017-2018 | HbA1c >=6.5% | 95% design-based intervals",
      outer=TRUE,side=3,line=.4,cex=1.1)
dev.off()
