/* 	Programmer:		Allen Haas
	Date Created:	02NOV2026
	Purpose:		Main Model and Smokers Only Sensitivity
*/

libname LOCAL "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files 2/" ACCESS=READONLY;
libname REV "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/";

/* Pull In Macros */
%INCLUDE "/rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/MACRO_LOADER.sas";

/* Set Libnames */
%MKT_LIB_J25;


/* Create Numeric Status and truncate at 60 months */
Data Temp;
	Set REV.AF_WEIGHT_REV;
	
	IF STATUS_REV = 'EVENT' THEN STATUS_NUM_REV = 1;
	ELSE IF STATUS_REV = 'MORT' THEN STATUS_NUM_REV = 2;
	ELSE IF STATUS_REV = 'CENSOR' THEN STATUS_NUM_REV = 0;

	IF MONTH_T_REV > 60 THEN DO;
		MONTH_T_REV = 60;
		STATUS_NUM_REV = 0;
	end;
Run;


Proc Freq data=temp;
	Tables MONTH_T_REV STATUS_NUM_REV * STATUS_REV /list missing;
Run;



/* Poly_Type Model */
PROC PHREG data=temp;
	CLASS POLY_TYPE_REV (REF='XXE') AGE_CAT DM_IND HTN_IND LIPID_IND SMOKE_IND SEX INSURE REGION UTIL_CAT;
	MODEL MONTH_T_REV * STATUS_NUM_REV(0) = POLY_TYPE_REV AGE_CAT DM_IND HTN_IND LIPID_IND  SEX INSURE REGION UTIL_CAT SMOKE_IND/ eventcode = 1;
	WEIGHT WEIGHT_REV;
	HAZARDRATIO POLY_TYPE_REV / diff=ref;
Run;

/* Poly Count Mode */
PROC PHREG data=temp;
	CLASS POLY_COUNT_REV (REF='1') AGE_CAT DM_IND HTN_IND LIPID_IND SMOKE_IND SEX INSURE REGION UTIL_CAT;
	MODEL MONTH_T_REV * STATUS_NUM_REV(0) = POLY_COUNT_REV AGE_CAT DM_IND HTN_IND LIPID_IND  SEX INSURE REGION UTIL_CAT SMOKE_IND/eventcode=1;
	WEIGHT WEIGHT_REV;
	HAZARDRATIO POLY_COUNT_REV / diff=ref;
Run;

/* Smoker's Only Sensitivity */


PROC PHREG data=temp;
	CLASS POLY_TYPE_REV (REF='XXE') AGE_CAT DM_IND HTN_IND LIPID_IND SMOKE_IND SEX INSURE REGION UTIL_CAT;
	MODEL MONTH_T_REV * STATUS_NUM_REV(0) = POLY_TYPE_REV AGE_CAT DM_IND HTN_IND LIPID_IND  SEX INSURE REGION UTIL_CAT / eventcode = 1;
	WEIGHT WEIGHT_REV;
	HAZARDRATIO POLY_TYPE_REV / diff=ref;
	WHERE SMOKE_IND = 1;
Run;

/* Poly Count Mode */
PROC PHREG data=temp;
	CLASS POLY_COUNT_REV (REF='1') AGE_CAT DM_IND HTN_IND LIPID_IND SMOKE_IND SEX INSURE REGION UTIL_CAT;
	MODEL MONTH_T_REV * STATUS_NUM_REV(0) = POLY_COUNT_REV AGE_CAT DM_IND HTN_IND LIPID_IND  SEX INSURE REGION UTIL_CAT /eventcode=1;
	WEIGHT WEIGHT_REV;
	HAZARDRATIO POLY_COUNT_REV / diff=ref;
	WHERE SMOKE_IND = 1;
Run;