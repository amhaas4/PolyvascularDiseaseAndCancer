#Programmer:  Allen Haas
#Created:     05NOV2025
#Purpose:     Create Cancer Specific Forest Plots


library(sas7bdat)
library(ggplot2)
library(dplyr)

dtm <- read.sas7bdat("V://userspace//amhaas//Nead//Polyvascular Disease//Working Files - Revisions//hrs_out_rev_new.sas7bdat")
head(dtm)


plot.data <- dtm

head(plot.data)



labels <- plot.data$CANCER_TYPE
value <- plot.data$HazardRatio
lb <-    plot.data$WaldLower
ub <-    plot.data$WaldUpper
df <- data.frame(labels,value,lb,ub)
df$labels <- factor(df$labels, levels=rev(df$labels))

head(df)

fp <- ggplot(data=df, aes(x=labels,y=value,ymin=lb,ymax=ub)) +
  geom_pointrange() + 
  geom_hline(yintercept=1, lty=2) +  # add a dotted line at x=1 after flip
  coord_flip() +  # flip coordinates (puts labels on y axis)
  xlab("") + ylab("Hazard Ratio (95% CI)") +
  theme_bw() +
  theme(axis.text=element_text(size=12)) +
  ggtitle("Hazard Ratios for Specific Cancers (AAA vs. NO CVD)")

fp

head(dtm)

mean <- dtm$HazardRatio
lower <- dtm$WaldLower
upper <- dtm$WaldUpper
 

dtm2 <- data.frame(dtm$CANCER_TYPE,dtm$VALUE,dtm$POUT)
head(dtm2)
colnames(dtm2) <- c('cancer','value','p')
temp <- rep(NA,3)

dtm3 <- cbind(mean,lower,upper)

dtm2

## Using Dplyr package
library(forestplot)
library(tidyr)

xplot <- dtm3 |>
  forestplot(labeltext=dtm2, boxsize=.2, hrzl_lines=TRUE,zero=1,xlab='Hazard Ratios (95% CI)',title='Hazard Ratios for Specific Cancers (2+ Types vs. 1 Type)', txt_gp= fpTxtGp(ticks=gpar(cex=1),xlab=gpar(cex=1)))|>
  fp_add_header(cancer=c("Cancer Type",""), value=c("Hazard Ratio", "(95% CI)"),p=c("P-Value",""))

xplot

