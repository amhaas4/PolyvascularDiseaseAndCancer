/* 	Programmer:		Allen Haas
	Date Created:	02NOV2026
	Purpose:		Create New Weights And SMDS
*/

libname LOCAL "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files 2/" ACCESS=READONLY;
libname REV "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/";

/* Pull In Macros */
%INCLUDE "/rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/MACRO_LOADER.sas";

/* Set Libnames */
%MKT_LIB_J25;


/* Get predicted probabilities */
PROC LOGISTIC DATA = REV.REV_PREWEIGHTIN ;
	CLASS POLY_TYPE_REV AGE_CAT DM_IND HTN_IND LIPID_IND SMOKE_IND SEX CKD_IND ;
	MODEL POLY_TYPE_REV  = AGE_CAT DM_IND HTN_IND LIPID_IND SMOKE_IND SEX CKD_IND  AGE_CAT AGE_CAT*LIPID_IND AGE_CAT*SMOKE_IND AGE_CAT*DM_IND AGE_CAT*HTN_IND AGE_CAT*CKD_IND / link=glogit;
	OUTPUT out=TEMP_PROB  predprobs=(individual) ;
Run;


PROC FREQ data= REV.REV_PREWEIGHTIN;
	TABLES POLY_TYPE_REV;
Run;



/* Create stabilized multinomial propensity scores */
DATA REV.WEIGHT_REV;
	SET TEMP_PROB;

	KEEP ENROLID POLY_TYPE_REV WEIGHT_REV;

	IF POLY_TYPE_REV = 'CPE' THEN WEIGHT_REV = 0.0395 / IP_CPE;
	IF POLY_TYPE_REV = 'CPX' THEN WEIGHT_REV = 0.0836 / IP_CPX;
	IF POLY_TYPE_REV = 'CXE' THEN WEIGHT_REV = 0.0906 / IP_CXE;
	IF POLY_TYPE_REV = 'XPE' THEN WEIGHT_REV = 0.0189 / IP_XPE;
	IF POLY_TYPE_REV = 'CXX' THEN WEIGHT_REV = 0.5493 / IP_CXX;
	IF POLY_TYPE_REV = 'XPX' THEN WEIGHT_REV = 0.1021 / IP_XPX;
	IF POLY_TYPE_REV = 'XXE' THEN WEIGHT_REV = 0.1161 / IP_XXE;
Run;


Proc Univariate data=REV.WEIGHT_REV;
	CLASS POLY_TYPE_REV;
	VAR WEIGHT_REV;
	histogram;
run;


/* Truncate weights greater than 10 */
DATA REV.WEIGHT_REV;
	SET REV.WEIGHT_REV;

	IF WEIGHT_REV > 10 THEN WEIGHT_REV = 10;
Run;


PROC SQL;
	Create Table TEMP2 AS
		Select a.*, b.WEIGHT_REV
			From REV.REV_PREWEIGHTIN as a
			INNER JOIN REV.WEIGHT_REV as b
			ON a.ENROLID = b.ENROLID;
	
Quit;



/* Make binary variables for use in SMD macro */
DATA REV.AF_WEIGHT_REV;
	Set TEMP2;

	IF AGE_CAT = '60-64' THEN AGE60 = 1;
	ELSE AGE60 = 0;	
	IF AGE_CAT = '65-69' THEN AGE65 = 1;
	ELSE AGE65 = 0;
	IF AGE_CAT = '70-79' THEN AGE70 = 1;
	ELSE AGE70 = 0;
	IF AGE_CAT = '80+' THEN AGE80 = 1;
	ELSE AGE80 = 0;



Run;



Proc Freq data=REV.AF_WEIGHT_REV;
	Tables UTIL_CAT;
Run;



/* Calculate the Maximum pairwise SMDs for all groups */

%MACRO SMD_ALL_ALL;

%MACRO SMD_ALL(VAR_IN);



%MACRO SMD(FILE_IN, VAR, OUTC, WEIGHT_VAR, GROUP1, GROUP2);

DATA TEMP35;
	SET &FILE_IN;
	IF &OUTC = "&GROUP1" THEN OUTC = 1;
	ELSE IF &OUTC = "&GROUP2" THEN OUTC = 0;
	ELSE DELETE;
Run;


proc means data=TEMP35 noprint;
  class OUTC;
  var &VAR;
  weight &WEIGHT_VAR;
  output out=jnk_W;
run;


PROC SQL;
	Create Table MEANS_W as
		Select a.&VAR as MEAN_OUTC_W, b.&VAR as MEAN_CONTROL_W
			From jnk_W as a
			INNER JOIN jnk_W as b
			ON a.OUTC = 1 AND b.OUTC = 0 AND a._STAT_ = b._STAT_ and a._STAT_ = 'MEAN';
Quit;

DATA STD1_W;
	SET MEANS_W;

	KEEP SMD;
	SMD = abs(MEAN_OUTC_W - MEAN_CONTROL_W)/SQRT((MEAN_OUTC_W * (1 - MEAN_OUTC_W) + MEAN_CONTROL_W * (1 - MEAN_CONTROL_W))/2);

Run;

%MEND;

%LET CAT1 = CPE;
%LET CAT2 = CPX;
%LET CAT3 = CXE;
%LET CAT4 = XPE;
%LET CAT5 = CXX;
%LET CAT6 = XPX;
%LET CAT7 = XXE;

%DO I = 1 %TO 6;



%DO J = %EVAL(&I+1) %TO 7;


%SMD(FILE_IN = REV.AF_WEIGHT_REV
			, VAR = &VAR_IN
			, OUTC = POLY_TYPE_REV
			, WEIGHT_VAR = WEIGHT_REV
			, GROUP1 = &&CAT&I
			, GROUP2 = &&CAT&J);

DATA TEMP36;
	SET STD1_W;

	LENGTH GROUP1 GROUP2 VAR $10;

	GROUP1 = "&&CAT&I";
	GROUP2 = "&&CAT&J";
	VAR = "&VAR_IN";
RUN;

DATA SMD_OUT;
	SET SMD_OUT TEMP36;
RUN;

%END;
%END;


%MEND;


DATA SMD_OUT;
RUN;

%LET VAR1 = SMOKE_IND;
%LET VAR2 = HTN_IND;
%LET VAR3 = LIPID_IND;
%LET VAR4 = DM_IND;
%LET VAR5 = CKD_IND;
%LET VAR6 = SEX2;
%LET VAR7 = AGE60;
%LET VAR8 = AGE65;
%LET VAR9 = AGE70;
%LET VAR10 = AGE80;

%DO II = 1 %TO 10;

%SMD_ALL(&&VAR&II);

%END;



PROC SORT DATA=SMD_OUT;
	bY  DESCENDING SMD;
RUN;


PROC MEANS DATA=SMD_OUT MAX;
	CLASS VAR;
	VAR SMD;
RUN;

PROC PRINT DATA=SMD_OUT (OBS=10); RUN;


%MEND;

%SMD_ALL_ALL;

