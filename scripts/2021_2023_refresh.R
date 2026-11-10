[Reading 112 lines from start (total: 112 lines, 0 remaining)]

library(foreign)
library(survey)
options(survey.lonely.psu="adjust")

root <- "/Users/sieannasmith/Documents/Population-Health-Intelligence"
demo <- read.xport(file.path(root,"data/raw/DEMO_L.XPT"))
ghb  <- read.xport(file.path(root,"data/raw/GHB_L.XPT"))

stopifnot(!anyDuplicated(demo$SEQN), !anyDuplicated(ghb$SEQN))
needed_demo <- c("SEQN","RIDAGEYR","RIAGENDR","RIDRETH3","DMDEDUC2","INDFMPIR","SDMVSTRA","SDMVPSU")
stopifnot(all(needed_demo %in% names(demo)), all(c("SEQN","LBXGH","WTPH2YR") %in% names(ghb)))

z <- merge(demo[,needed_demo], ghb[,c("SEQN","LBXGH","WTPH2YR")], by="SEQN", all.x=TRUE)
z$high <- ifelse(is.na(z$LBXGH),NA_real_,as.integer(z$LBXGH>=6.5))
z$income <- cut(z$INDFMPIR,c(-Inf,1,2,4,Inf),labels=c("<=1","1-2","2-4",">4"))
z$education <- factor(z$DMDEDUC2,levels=1:5,labels=c("<9th","9-11th","HS/GED","Some college","College+"))
z$sex <- factor(z$RIAGENDR,levels=1:2,labels=c("Male","Female"))
z$race <- factor(z$RIDRETH3,levels=c(1,2,3,4,6,7))

adult <- z$RIDAGEYR>=20
analytic_vars <- c("high","income","education","RIDAGEYR","sex","race","WTPH2YR","SDMVSTRA","SDMVPSU")
complete <- adult & complete.cases(z[analytic_vars]) & z$WTPH2YR>0
complete[is.na(complete)] <- FALSE

audit <- data.frame(
 metric=c("demographics_total","ghb_records","adults_age20plus","adults_with_hba1c",
          "adult_complete_cases","adult_missing_hba1c","adult_missing_income",
          "adult_missing_education","adult_nonpositive_or_missing_phlebotomy_weight"),
 n=c(nrow(demo),nrow(ghb),sum(adult,na.rm=TRUE),
     sum(adult & !is.na(z$LBXGH),na.rm=TRUE),sum(complete),
     sum(adult & is.na(z$LBXGH),na.rm=TRUE),
     sum(adult & is.na(z$INDFMPIR),na.rm=TRUE),
     sum(adult & !z$DMDEDUC2 %in% 1:5,na.rm=TRUE),
     sum(adult & (is.na(z$WTPH2YR)|z$WTPH2YR<=0),na.rm=TRUE))
)
write.csv(audit,file.path(root,"reports/2021_2023_data_audit.csv"),row.names=FALSE)

design_data <- subset(z,!is.na(WTPH2YR)&WTPH2YR>0&!is.na(SDMVSTRA)&!is.na(SDMVPSU))
s <- svydesign(ids=~SDMVPSU,strata=~SDMVSTRA,weights=~WTPH2YR,nest=TRUE,data=design_data)
a <- subset(s, RIDAGEYR>=20 & complete.cases(high,income,education,RIDAGEYR,sex,race))

by_income <- svyby(~high,~income,a,svymean,na.rm=TRUE,vartype=c("se","ci"))
by_educ <- svyby(~high,~education,a,svymean,na.rm=TRUE,vartype=c("se","ci"))
fmt <- function(x,dimension) data.frame(
 dimension=dimension,category=as.character(x[[1]]),
 prevalence_pct=100*x$high,lower_pct=100*x$ci_l,upper_pct=100*x$ci_u)
unadjusted <- rbind(fmt(by_income,"Income-to-poverty ratio"),fmt(by_educ,"Education"))
write.csv(unadjusted,file.path(root,"reports/2021_2023_unadjusted_prevalence.csv"),row.names=FALSE)

m1 <- svyglm(high~income+education+RIDAGEYR+sex,design=a,family=quasibinomial())
m2 <- svyglm(high~income+education+RIDAGEYR+sex+race,design=a,family=quasibinomial())

or_table <- function(fit,label){
 b<-coef(fit); se<-sqrt(diag(vcov(fit))); crit<-qt(.975,degf(a))
 data.frame(model=label,term=names(b),odds_ratio=exp(b),
            lower_95=exp(b-crit*se),upper_95=exp(b+crit*se),
            p_value=2*pt(-abs(b/se),df=degf(a)))
}
ors <- rbind(or_table(m1,"Age + sex"),or_table(m2,"Age + sex + race/ethnicity"))
write.csv(ors,file.path(root,"reports/2021_2023_adjusted_odds_ratios.csv"),row.names=FALSE)

standardized <- function(fit, variable, group) {
 xdata <- a$variables
 xdata[[variable]] <- factor(group, levels=levels(xdata[[variable]]))
 x <- model.matrix(delete.response(terms(fit)),xdata,contrasts.arg=fit$contrasts)
 p <- plogis(drop(x %*% coef(fit)))
 w <- weights(a,type="sampling")
 g <- colSums(x*as.vector(w*p*(1-p)))/sum(w)
 est <- weighted.mean(p,w)
 se <- sqrt(drop(t(g)%*%vcov(fit)%*%g))
 crit <- qt(.975,degf(a))
 list(estimate=est,lower=max(0,est-crit*se),upper=min(1,est+crit*se),gradient=g)
}

models <- list("Age + sex"=m1,"Age + sex + race/ethnicity"=m2)
rows<-list(); contrasts<-list()
for(model_name in names(models)){
 fit<-models[[model_name]]
 for(variable in c("income","education")){
  lev<-levels(a$variables[[variable]])
  vals<-setNames(lapply(lev,function(g) standardized(fit,variable,g)),lev)
  for(g in lev){
   v<-vals[[g]]
   rows[[length(rows)+1]]<-data.frame(model=model_name,dimension=variable,category=g,
      estimate_pct=100*v$estimate,lower_pct=100*v$lower,upper_pct=100*v$upper)
  }
  ref<-lev[1]; cmp<-tail(lev,1)
  grad<-vals[[cmp]]$gradient-vals[[ref]]$gradient
  delta<-vals[[cmp]]$estimate-vals[[ref]]$estimate
  se<-sqrt(drop(t(grad)%*%vcov(fit)%*%grad)); crit<-qt(.975,degf(a))
  contrasts[[length(contrasts)+1]]<-data.frame(model=model_name,dimension=variable,
    reference=ref,comparison=cmp,difference_pp=100*delta,
    lower_pp=100*(delta-crit*se),upper_pp=100*(delta+crit*se))
 }
}
adjusted_prev<-do.call(rbind,rows); contrast_table<-do.call(rbind,contrasts)
write.csv(adjusted_prev,file.path(root,"reports/2021_2023_adjusted_prevalence.csv"),row.names=FALSE)
write.csv(contrast_table,file.path(root,"reports/2021_2023_adjusted_contrasts.csv"),row.names=FALSE)

overall <- svymean(~high,a,na.rm=TRUE)
overall_ci <- confint(overall)
summary <- data.frame(
 metric=c("analytic_n","survey_design_df","weighted_hba1c_ge6_5_pct"),
 value=c(nrow(a$variables),degf(a),100*coef(overall)[1]),
 lower_95=c(NA,NA,100*overall_ci[1,1]),
 upper_95=c(NA,NA,100*overall_ci[1,2]))
write.csv(summary,file.path(root,"reports/2021_2023_summary.csv"),row.names=FALSE)

cat("ADULTS",sum(adult,na.rm=TRUE),"HBA1C",sum(adult&!is.na(z$LBXGH),na.rm=TRUE),"COMPLETE",nrow(a$variables),"DF",degf(a),"\n")
cat(sprintf("OVERALL %.2f %.2f %.2f\n",100*coef(overall)[1],100*overall_ci[1,1],100*overall_ci[1,2]))
cat("UNADJUSTED\n"); print(unadjusted,row.names=FALSE)
cat("CONTRASTS\n"); print(contrast_table,row.names=FALSE)

[executed on device: Sieannas-MacBook-Pro.local (5aa3f463-85a9-42eb-849f-e2a15e4fbbec)]