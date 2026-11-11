/* 	Programmer:		Allen Haas
	Date Created:	03NOV2026
	Purpose:		Specific Cancer Model
*/

libname LOCAL "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files 2/" ACCESS=READONLY;
libname REV "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/";

/* Pull In Macros */
%INCLUDE "/rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/MACRO_LOADER.sas";

/* Set Libnames */
%MKT_LIB_J25;


%MACRO REP_MODEL(CC);

DATA TEMP;
	SET REV.CAN_CAT;

		
	IF STATUS_REV = 'EVENT' THEN STATUS_NUM_REV = 1;
	ELSE IF STATUS_REV = 'MORT' THEN STATUS_NUM_REV = 2;
	ELSE IF STATUS_REV = 'CENSOR' THEN STATUS_NUM_REV = 0;

	IF CAN_CAT NE "&CC" THEN DO;
		IF STATUS_NUM_REV = 1 THEN STATUS_NUM_REV = 3;
	END;

	IF POLY_COUNT_REV = 1 THEN POLY_IND = 0;
	ELSE POLY_IND = 1;

	IF MONTH_T > 60 THEN DO;
		MONTH_T = 60;
		STATUS_NUM_REV = 0;
	end;
Run;


Proc Freq data=TEMP;
	TABLE CAN_CAT * STATUS_NUM_REV;
Run;

ods output HazardRatios=HRs ParameterEstimates = PE;

PROC PHREG data=TEMP;
	CLASS POLY_IND (REF='0') AGE_CAT DM_IND HTN_IND LIPID_IND CKD_IND UTIL_CAT SMOKE_IND SEX INSURE REGION;
	MODEL MONTH_T * STATUS_NUM_REV(0) = POLY_IND AGE_CAT DM_IND HTN_IND UTIL_CAT CKD_IND LIPID_IND SMOKE_IND SEX INSURE REGION / eventcode = 1;
	WEIGHT WEIGHT_REV;
	HAZARDRATIO POLY_IND / diff=ref;
	WHERE MORTALITY_COHORT = 1;
Run;


DATA HRS2;
	SET HRS;
	LENGTH CANCER_TYPE $30.;
	CANCER_TYPE = "&CC";
	DROP DESCRIPTION;
Run;

Proc SQL;
	CREATE Table HRS3 as
		Select a.*, b.PROBCHISQ as P
			From HRS2 as a, PE as b
			Where b.PARAMETER = "POLY_IND";
Quit;


DATA REV.HRS_OUT_REV_NEW;
	Set REV.HRS_OUT_REV_NEW HRS3;
Run;

%MEND;




DATA REV.HRS_OUT_REV_NEW;
run;


%REP_MODEL(Breast);

%REP_MODEL(Bone);
%REP_MODEL(Colon);
%REP_MODEL(Esophagus);
%REP_MODEL(Female Genital);

%REP_MODEL(Head and Neck);
%REP_MODEL(Leukemia);
%REP_MODEL(Liver);
%REP_MODEL(Lung);
%REP_MODEL(Lymphoma);

%REP_MODEL(Male Genital);
%REP_MODEL(Melanoma);
%REP_MODEL(Soft Tissue);
%REP_MODEL(Other Hematologic);
%REP_MODEL(Ovarian);

%REP_MODEL(Pancreas);
%REP_MODEL(Prostate);
%REP_MODEL(Rectum and Anus);
%REP_MODEL(Renal);
%REP_MODEL(Stomach);
%REP_MODEL(Thyroid);
%REP_MODEL(Uterine);


Proc print data=REV.HRS_OUT_REV_NEW; run;


proc sort data=REV.HRS_OUT_REV_NEW;
	BY descending HAZARDRATIO;
Run;


DATA REV.HRS_OUT_REV_NEW;
	SET REV.HRS_OUT_REV_NEW;
		length VALUE $30;
	VALUE = STRIP(PUT(HazardRatio,8.2))||" ("||STRIP(PUT(WaldLower,8.2))||" - "||STRIP(PUT(WALDUPPER,8.2))||")";


	length POUT $10;

	IF P <0.0001 THEN POUT = "<0.0001";
	ELSE POUT = PUT(P,8.4);

	IF  HAZARDRATIO = . THEN DELETE; /* Removes blank line from data set creation */
Run;

Proc Freq data=REV.CAN_CAT;
	Tables CAN_CAT; run;