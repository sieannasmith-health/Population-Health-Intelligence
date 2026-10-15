# Requires install.packages('survey') once and a completed Python data audit.
library(survey)
source_path <- 'data/processed/adult_hba1c_audit.csv'
stopifnot(file.exists(source_path))
d <- read.csv(source_path)
d <- subset(d, !is.na(LBXGH) & !is.na(WTMEC2YR) & WTMEC2YR > 0 & !is.na(SDMVSTRA) & !is.na(SDMVPSU))
d$diabetes_range_hba1c <- as.integer(d$LBXGH >= 6.5)
d$pir_group <- cut(d$INDFMPIR, breaks=c(-Inf,1,2,4,Inf), labels=c('<=1','1-2','2-4','>4'))
options(survey.lonely.psu='adjust')
design <- svydesign(id=~SDMVPSU, strata=~SDMVSTRA, weights=~WTMEC2YR, nest=TRUE, data=d)
cat('Survey-weighted proportion HbA1c >=6.5%, adults age 20+:\n')
print(svymean(~diabetes_range_hba1c, design, na.rm=TRUE))
cat('Survey-weighted prevalence by PIR grouping:\n')
print(svyby(~diabetes_range_hba1c,~pir_group, design, svymean, na.rm=TRUE, vartype='ci'))
# Next lesson: confounder selection, model specification, and diagnostics.
