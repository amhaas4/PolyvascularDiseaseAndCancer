#Programmer:  Allen Haas
#Created:     05NOV2025
#Purpose:     Create Main Model Forestplots



library(sas7bdat)
library(ggplot2)
library(dplyr)

### Poly Count Forest

dtm <- read.csv("V://userspace//amhaas//Nead//Polyvascular Disease//pvdforest_rev.csv")
head(dtm)


dtm2 <- dtm[,c(1:2,6)]
dtm3 <- dtm[,3:5]


dtm3

## Using Dplyr package
library(forestplot)
library(tidyr)
library(grid)
dtm3 |>
  forestplot(labeltext=dtm2,
             mean=Value,
             lower=Lower,
             upper=Upper,
             ci.vertices=T,
             ci.vertices.height=0.2,
             clip=c(0.75,5.5),boxsize=.08,
             xticks=c(0.95,1,1.1,1.2,1.3,1.4), 
             hrzl_lines=TRUE,zero=1,
             title='Hazard ratios for cancer by count of poly-vascular disease',
             txt_gp= fpTxtGp(ticks=gpar(cex=1),xlab=gpar(cex=1)))|>
  fp_add_header(Variable="CVD Category", Hazard.Ratio="Hazard Ratio (95% CI)", p="P-Value")


row_styles

### Poly Type Forest

dtm <- read.csv("V://userspace//amhaas//Nead//Polyvascular Disease//pvdforest_nocount_rev.csv")
head(dtm)


p <- as.character(sprintf("%.4f",dtm$p))

dtm2 <- cbind(dtm[,c(1:2)],p)
dtm3 <- dtm[,3:5]



dtm3

## Using Dplyr package
library(forestplot)
library(tidyr)

dtm3 |>
  forestplot(labeltext=dtm2,
             mean=Value,
             lower=Lower,
             upper=Upper,
             ci.vertices=T,
             ci.vertices.height=0.3,
             xlim=c(0.9,2),
             clip=NULL,
             boxsize=.15,
             xticks=c(0.95,1.0,1.1,1.2,1.3,1.4), 
             hrzl_lines=TRUE,
             zero=1,
             title='Hazard ratios for cancer by poly-vascular category',
             txt_gp= fpTxtGp(ticks=gpar(cex=1),xlab=gpar(cex=1)))|>
            fp_add_header(Variable=c("CVD Category"), Hazard.Ratio=c("Hazard Ratio (95% CI)"),p="P-Value")

