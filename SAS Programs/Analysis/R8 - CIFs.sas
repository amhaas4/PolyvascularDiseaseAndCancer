/* 	Programmer:		Allen Haas
	Date Created:	04NOV2026
	Purpose:		Send Data for CIFs to R
*/

libname LOCAL "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files 2/" ACCESS=READONLY;
libname REV "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/";

/* Pull In Macros */
%INCLUDE "/rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/MACRO_LOADER.sas";

/* Set Libnames */
%MKT_LIB_J25;

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



Proc lifetest data=TEMP  outcif=os noprint;
	time MONTH_T_REV * STATUS_NUM_REV(0) / eventcode = 1;
	STRATA POLY_COUNT_REV;
	WHERE MORTALITY_COHORT = 1;
run;


DATA REV.COUNT_CIF;
	SET OS;
	KEEP POLY_COUNT_REV CIF MONTH_T_REV ATRISK;
Run;




Proc lifetest data=TEMP  outcif=os noprint;
	time MONTH_T_REV * STATUS_NUM_REV(0) / eventcode = 1;
	STRATA POLY_COUNT_REV;
	WHERE MORTALITY_COHORT = 1;
run;



DATA REV.TYPE_CIF;
	SET OS;
	KEEP POLY_TYPE_REV CIF MONTH_T_REV ATRISK;
Run;

