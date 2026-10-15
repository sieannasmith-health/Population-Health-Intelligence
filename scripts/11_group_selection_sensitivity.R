# Population Health Intelligence | Group Selection Sensitivity
library(survey)
d <- read.csv("data/processed/adult_hba1c_audit.csv")
d$high <- ifelse(is.na(d$LBXGH), NA, as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR, c(-Inf, 1, 2, 4, Inf),
                labels = c("<=1", "1-2", "2-4", ">4"))
d$education <- factor(d$DMDEDUC2, levels = 1:5,
  labels = c("<9th", "9-11th", "HS/GED", "Some college", "College+"))
req <- c("high", "income", "education", "RIDAGEYR", "RIAGENDR",
         "RIDRETH3", "WTMEC2YR", "SDMVSTRA", "SDMVPSU")
d$complete <- complete.cases(d[req]) & d$WTMEC2YR > 0
options(survey.lonely.psu = "adjust")
s <- svydesign(ids = ~SDMVPSU, strata = ~SDMVSTRA,
               weights = ~WTMEC2YR, nest = TRUE, data = d)

# Same subgroup, two nested samples. No inference about their
# overlapping difference is attempted here.
summarize <- function(group) {
  eligible <- !is.na(d$high) & !is.na(d[[group]]) &
              !is.na(d$WTMEC2YR) & d$WTMEC2YR > 0
  output <- lapply(c("Group outcome observed", "Full model complete"),
    function(kind) {
      chosen <- if (kind == "Full model complete") d$complete else eligible
      by <- svyby(~high, as.formula(paste0("~", group)),
                  subset(s, chosen), svymean, na.rm = TRUE,
                  vartype = "se")
      cells <- table(d[[group]][chosen])
      data.frame(dimension = group, sample = kind,
        category = as.character(by[[1]]),
        n = as.integer(cells[as.character(by[[1]])]),
        prevalence = 100 * by$high, se = 100 * by$se)
    })
  do.call(rbind, output)
}
a <- rbind(summarize("income"), summarize("education"))
a$prevalence <- round(a$prevalence, 2)
a$se <- round(a$se, 2)
print(a, row.names = FALSE)
write.csv(a, "reports/11_group_selection_sensitivity.csv",
          row.names = FALSE)
