#Programmer:  Allen Haas
#Created:     05NOV2025
#Purpose:     Create CIF Plots



## CIF PLOT FOR ALL TYPES

library(sas7bdat)
dtm <- read.sas7bdat("V://userspace//amhaas//Nead//Polyvascular Disease//Working Files - Revisions//TYPE_CIF.sas7bdat")
head(dtm)




library(ggplot2)
library(grid)
library(gridExtra)


dtm2 <- dtm[dtm$MONTH_T_REV <= 60,]

table(dtm2$POLY_TYPE_REV)

dtm2$POLY_TYPE_REV <- factor(dtm2$POLY_TYPE_REV, levels = c('CPE','CPX','CXE','XPE','CXX','XPX','XXE'))

head(dtm2)
dtm2[dtm2$MONTH_T_REV  %in% c(0,12,24,36,48,60),c(1,2,3)]

FIRST_ROW_HEIGHT = -0.02
ROW_DIFF = .006
ts = 3.5
FIRST_LABEL = -0.8

nameslist <- c('PAD, CAD and CVD','CAD and PAD','CAD and CVD','PAD and CVD','CAD Only','PAD Only','CVD Only','naCVD','None')
linetypelist = c(rep('longdash',7))
linecolorlist = c('darkred','lightblue','darkgreen','violet','darkblue','orange','pink')
plot1 <- ggplot(data=dtm2, aes(x=MONTH_T_REV/12,y=CIF,group=as.factor(POLY_TYPE_REV))) +
  geom_line(aes(linetype=as.factor(POLY_TYPE_REV),color=as.factor(POLY_TYPE_REV)),size=1.5) +
  scale_linetype_manual(values=linetypelist,name='',labels=nameslist) +
  scale_color_manual(values=linecolorlist,name='',labels=nameslist) +
  ylab("Cumulative Incidence of Any Cancer") +
  xlab("Years Since Enrollment") + 
  scale_x_continuous(expand = c(0, 0),breaks=(c(0,1,2,3,4,5))) + 
  scale_y_continuous(expand = c(0, 0), breaks =(c(0.00,0.05,0.10,0.15,0.20,0.25))) +
  coord_cartesian(xlim = c(0,5),ylim=c(0,0.25),clip="off") +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT, label="PAD, CAD and CVD",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT, label="11823",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT, label="11267",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT, label="7604",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT, label="5716",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT, label="2969",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT, label="2021",size=ts,hjust=1) +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * 1, label="CAD and PAD",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="25063",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="23883",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="16208",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="12167",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="5752",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="3908",size=ts,hjust=1) +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * 2, label="CAD and CVD",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="27168",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="26145",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="17985",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="13548",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="6742",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="4527",size=ts,hjust=1) +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * 3, label="PAD and CVD",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT -  ROW_DIFF*3, label="5669",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT -  ROW_DIFF*3, label="5447",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT -  ROW_DIFF*3, label="3718",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT -  ROW_DIFF*3, label="2845",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT -  ROW_DIFF*3, label="1319",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT -  ROW_DIFF*3, label="908",size=ts,hjust=1) +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * 4, label="CAD Only",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT -  ROW_DIFF*4, label="164713",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT -  ROW_DIFF*4, label="159348",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT -  ROW_DIFF*4, label="110068",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT -  ROW_DIFF*4, label="80867",size=ts,hjust=0)+
  annotate("text",x=4, y=FIRST_ROW_HEIGHT -  ROW_DIFF*4, label="38638",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT -  ROW_DIFF*4, label="24523",size=ts,hjust=1) +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * 5, label="PAD Only",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT -  ROW_DIFF*5, label="30604",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT -  ROW_DIFF*5, label="29470",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT -  ROW_DIFF*5, label="20202",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT -  ROW_DIFF*5, label="15374",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT -  ROW_DIFF*5, label="6321",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT -  ROW_DIFF*5, label="4187",size=ts,hjust=1) +
annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * 6, label="CVD Only",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT -  ROW_DIFF*6, label="34833",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT -  ROW_DIFF*6, label="33804",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT -  ROW_DIFF*6, label="23403",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT -  ROW_DIFF*6, label="17725",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT -  ROW_DIFF*6, label="8423",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT -  ROW_DIFF*6, label="5645",size=ts,hjust=1) +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * -1, label="Patients at Risk",size=ts,hjust=0) +
  theme_bw() + 
  theme(legend.position=c(0.15,.7),panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),axis.title=element_text(size=14), 
        plot.margin = margin(t=8,r=8,l=70,b=85),unit="lines")

plot1


## CIF PLOT BY COUNT OF POLYVASCULAR DISEASE

library(sas7bdat)
dtm_count <- read.sas7bdat("V://userspace//amhaas//Nead//Polyvascular Disease//Working Files - Revisions//count_cif.sas7bdat")
head(dtm)




library(ggplot2)
library(grid)
library(gridExtra)


dtm_count2 <- dtm_count[dtm_count$MONTH_T_REV <= 60,]
head(dtm_count2)


dtm_count2[dtm_count2$MONTH_T_REV  %in% c(0,12,24,36,48,60),c(1,2,3)]

FIRST_ROW_HEIGHT = -0.02
ROW_DIFF = .006
ts = 3.5
FIRST_LABEL = -0.6

nameslist <- c('1 Type','2 Types','3 Types')
linetypelist = c(rep('solid',3))
linecolorlist = c('lightpink','red','darkred')
plot2 <- ggplot(data=dtm_count2, aes(x=MONTH_T_REV/12,y=CIF,group=as.factor(POLY_COUNT_REV))) +
  geom_line(aes(linetype=as.factor(POLY_COUNT_REV),color=as.factor(POLY_COUNT_REV)),size=1.5) +
 scale_linetype_manual(values=linetypelist,name='',labels=nameslist) +
  scale_color_manual(values=linecolorlist,name='',labels=nameslist) +
  ylab("Cumulative Incidence of Any Cancer") +
  xlab("Years Since Enrollment") + 
  scale_x_continuous(expand = c(0, 0),breaks=(c(0,1,2,3,4,5))) + 
  scale_y_continuous(expand = c(0, 0), breaks =(c(0.00,0.05,0.10,0.15,0.20,0.25))) +
  coord_cartesian(xlim = c(0,5),ylim=c(0,0.25),clip="off")+ 
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * -1, label="Patients at Risk",size=ts,hjust=0)+
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT, label="3 Types",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT, label="11823",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT, label="1267",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT, label="7604",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT, label="5716",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT, label="2969",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT, label="2021",size=ts,hjust=1) +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * 1, label="2 Types",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="57900",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="55475",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="37911",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="28560",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="13813",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT -  ROW_DIFF*1, label="9343",size=ts,hjust=1) +
  annotate("text",x=FIRST_LABEL, y=FIRST_ROW_HEIGHT - ROW_DIFF * 2, label="1 Type",size=ts,hjust=0) +
  annotate("text",x=0, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="230150",size=ts,hjust=0) +
  annotate("text",x=1, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="222622",size=ts,hjust=0) +
  annotate("text",x=2, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="153673",size=ts,hjust=0) +
  annotate("text",x=3, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="113966",size=ts,hjust=0) +
  annotate("text",x=4, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="53382",size=ts,hjust=0) +
  annotate("text",x=5, y=FIRST_ROW_HEIGHT -  ROW_DIFF*2, label="34355",size=ts,hjust=1) +
  theme_bw() + 
  theme(legend.position=c(0.25,.75),panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),axis.title=element_text(size=14), 
        plot.margin = margin(t=8,r=8,l=45,b=50),unit="lines")



plot2








