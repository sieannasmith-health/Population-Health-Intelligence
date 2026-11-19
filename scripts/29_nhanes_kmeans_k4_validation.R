# NHANES Aug 2021-Aug 2023: four cardiometabolic profiles
# Reproducible K=4 extension to the existing socioeconomic analysis.
# Run from the repository root after downloading DEMO_L, GHB_L, BMX_L, BPXO_L
# XPT files into data/raw. Requires: foreign, cluster, survey.
suppressPackageStartupMessages({
  library(foreign)
  library(cluster)
  library(survey)
})
options(survey.lonely.psu = "adjust")
root <- normalizePath(".", mustWork = TRUE)
raw <- file.path(root, "data", "raw")
out <- file.path(root, "reports", "kmeans_k4")
dir.create(out, recursive = TRUE, showWarnings = FALSE)
read_xpt <- function(name) read.xport(file.path(raw, paste0(name, ".XPT")))
demo <- read_xpt("DEMO_L")
ghb <- read_xpt("GHB_L")
bmx <- read_xpt("BMX_L")
bp <- read_xpt("BPXO_L")
stopifnot(all(vapply(list(demo,ghb,bmx,bp), function(z) !anyDuplicated(z$SEQN), logical(1))))
d <- Reduce(function(x,y) merge(x,y,by="SEQN",all.x=TRUE), list(
 demo[,c("SEQN","RIDAGEYR","SDMVSTRA","SDMVPSU")],
 ghb[,c("SEQN","LBXGH","WTPH2YR")],
 bmx[,c("SEQN","BMXBMI")],
 bp[,c("SEQN","BPXOSY1","BPXOSY2","BPXOSY3")]
))
d$sbp <- apply(d[,c("BPXOSY1","BPXOSY2","BPXOSY3")],1,
 function(z) if(all(is.na(z))) NA_real_ else mean(z, na.rm=TRUE))
features <- c("LBXGH","BMXBMI","sbp")
adult <- subset(d,!is.na(RIDAGEYR) & RIDAGEYR>=20)
keep <- complete.cases(adult[,c(features,"WTPH2YR","SDMVSTRA","SDMVPSU")]) &
  adult$WTPH2YR>0 & adult$BMXBMI>0 & adult$sbp>0
a <- adult[keep,]
stopifnot(nrow(a)>100)
x <- scale(a[,features])
set.seed(20261118)
fit2 <- kmeans(x,centers=2,nstart=100,iter.max=100)
fit4 <- kmeans(x,centers=4,nstart=100,iter.max=100)
# Same subsample for both silhouette calculations.
set.seed(20261118)
ids <- sample.int(nrow(a),min(1500L,nrow(a)))
distance <- dist(x[ids,,drop=FALSE])
sil2 <- silhouette(fit2$cluster[ids],distance)
sil4 <- silhouette(fit4$cluster[ids],distance)
write.csv(data.frame(k=c(2,4),
  withinss=c(fit2$tot.withinss,fit4$tot.withinss),
  mean_silhouette=c(mean(sil2[,3]),mean(sil4[,3])),
  negative_silhouette=c(sum(sil2[,3]<0),sum(sil4[,3]<0)),
  silhouette_sample_n=length(ids)),
  file.path(out,"k2_k4_validation.csv"),row.names=FALSE)
# Adjusted Rand index without an additional package.
ari <- function(a,b) {
  tab <- table(a,b)
  choose2 <- function(x) sum(x*(x-1)/2)
  n <- sum(tab)
  t <- choose2(tab)
  row <- choose2(rowSums(tab))
  col <- choose2(colSums(tab))
  expected <- row*col/choose(n,2)
  upper <- (row+col)/2
  if (upper==expected) return(if(t==upper) 1 else NA_real_)
  (t-expected)/(upper-expected)
}
seeds <- 20261118 + seq_len(8)
runs <- lapply(seeds,function(s) {set.seed(s); kmeans(x,centers=4,nstart=100,iter.max=100)})
pairs <- combn(seq_along(runs),2)
stability <- data.frame(seed_a=seeds[pairs[1,]],seed_b=seeds[pairs[2,]],
  ari=vapply(seq_len(ncol(pairs)),function(i) ari(
    runs[[pairs[1,i]]]$cluster,runs[[pairs[2,i]]]$cluster),numeric(1)))
write.csv(stability,file.path(out,"k4_seed_stability.csv"),row.names=FALSE)
# Labels are arbitrary; name profiles by their observed characteristics,
# rather than assuming a particular cluster number always means the same profile.
centers <- sweep(sweep(fit4$centers,2,attr(x,"scaled:scale"),"*"),
  2,attr(x,"scaled:center"),"+")
centroids <- data.frame(cluster=seq_len(4),
  n=as.integer(tabulate(fit4$cluster,nbins=4)),
  HbA1c_pct=centers[,"LBXGH"],BMI_kg_m2=centers[,"BMXBMI"],
  SBP_mmHg=centers[,"sbp"])
write.csv(centroids,file.path(out,"k4_centroids.csv"),row.names=FALSE)
a$cluster <- factor(fit4$cluster,levels=1:4)
design <- svydesign(ids=~SDMVPSU,strata=~SDMVSTRA,
  weights=~WTPH2YR,nest=TRUE,data=a)
shares <- svymean(~cluster,design)
write.csv(data.frame(cluster=seq_len(4),
  weighted_share=as.numeric(coef(shares)),
  se=as.numeric(SE(shares))),
  file.path(out,"k4_weighted_shares.csv"),row.names=FALSE)
png(file.path(out,"k2_k4_silhouette.png"),width=960,height=640,res=130)
barplot(c(mean(sil2[,3]),mean(sil4[,3])),
  names.arg=c("K=2","K=4"),ylab="Mean silhouette (same subsample)",
  main="NHANES K-means silhouette comparison",ylim=c(0,0.5))
dev.off()
png(file.path(out,"k4_bmi_hba1c.png"),width=1100,height=800,res=130)
palette <- c("#3366AA","#D28B26","#389A7A","#9B62A8")
plot(a$BMXBMI,a$LBXGH,pch=16,cex=0.4,
  col=adjustcolor(palette[fit4$cluster],alpha.f=0.3),
  xlab="BMI (kg/m2)",ylab="HbA1c (%)",
  main="Four cardiometabolic profiles (clustering also uses SBP)")
points(centroids$BMI_kg_m2,centroids$HbA1c_pct,pch=8,cex=2,lwd=3,col=palette)
legend("topright",legend=paste("Cluster",1:4),col=palette,pch=16,bty="n")
dev.off()
cat("Analytic N:",nrow(a),"\n")
print(centroids)
print(stability)
