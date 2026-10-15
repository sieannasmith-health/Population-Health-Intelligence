# Income-item nonresponse scenario stress test
library(survey)
d <- read.csv("data/processed/all_age_hba1c_survey.csv")
d$high <- ifelse(is.na(d$LBXGH), NA, as.integer(d$LBXGH >= 6.5))
d$income <- cut(d$INDFMPIR,c(-Inf,1,2,4,Inf),labels=c("<=1","1-2","2-4",">4"))
d$education <- factor(d$DMDEDUC2,levels=1:5,labels=c("<9th","9-11th","HS/GED","Some college","College+"))
d$sex <- factor(d$RIAGENDR,levels=1:2,labels=c("Male","Female"))
d$race <- factor(d$RIDRETH3,levels=c(1,2,3,4,6,7))
base <- c("high","education","RIDAGEYR","sex","race","WTMEC2YR","SDMVSTRA","SDMVPSU")
d$eligible <- d$RIDAGEYR>=20 & complete.cases(d[base]) & d$WTMEC2YR>0
d$eligible[is.na(d$eligible)]<-FALSE
options(survey.lonely.psu="adjust")
calc <- function(data,label,extended=FALSE) {
 s<-svydesign(ids=~SDMVPSU,strata=~SDMVSTRA,weights=~WTMEC2YR,nest=TRUE,data=data)
 a<-subset(s,eligible & !is.na(income))
 f<-if(extended) high~income+education+RIDAGEYR+sex+race else high~income+education+RIDAGEYR+sex
 fit<-svyglm(f,design=a,family=quasibinomial())
 marg<-function(grp){
  nd<-a$variables;nd$income<-factor(grp,levels=levels(nd$income))
  x<-model.matrix(delete.response(terms(fit)),nd,contrasts.arg=fit$contrasts)
  p<-plogis(drop(x%*%coef(fit)));w<-weights(a,type="sampling")
  weighted.mean(p,w)
 }
 data.frame(scenario=label,model=if(extended)"Extended (+race/ethnicity)" else "Age + sex",n=nrow(a$variables),high_minus_low_pp=100*(marg(">4")-marg("<=1")))
}
all<-list()
for(sc in c("Observed income only","All missing PIR assigned <=1","All missing PIR assigned >4")){
 t<-d
 if(sc!="Observed income only")t$income[is.na(t$income)]<-if(sc=="All missing PIR assigned <=1")"<=1" else ">4"
 for(extended in c(FALSE,TRUE))all[[length(all)+1]]<-calc(t,sc,extended)
}
out<-do.call(rbind,all)
write.csv(out,"reports/20_income_scenario_stress_test.csv",row.names=FALSE)
print(out,row.names=FALSE)
