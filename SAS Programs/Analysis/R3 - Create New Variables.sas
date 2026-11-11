/* 	Programmer:		Allen Haas
	Date Created:	02NOV2026
	Purpose:		Create Utilization Variable, Update CAD variable, Update CA Outcome 
*/

libname LOCAL "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files 2/" ACCESS=READONLY;
libname REV "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/";

/* Pull In Macros */
%INCLUDE "/rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/MACRO_LOADER.sas";

/* Set Libnames */
%MKT_LIB_J25;

/* Create New CAD and Visits Variables */

PROC PRINT DATA=REV.U_2014 (obs=5); run;

DATA TEMP;
	SET REV.U_2014
		REV.U_2015
		REV.U_2016
		REV.U_2017
		REV.U_2018
		REV.U_2019
		REV.U_2020
		REV.U_2021;

IF SVCDATE NE . THEN DO;
	DATE = SVCDATE;
	OUTPUT;
END;
ELSE IF ADMDATE > DISDATE THEN DELETE;
ELSE DO X = ADMDATE TO DISDATE;
	DATE = X;
	OUTPUT;
END;

KEEP ENROLID DATE;
Run;

PROC SORT DATA=TEMP nodupkey;
	BY ENROLID DATE;
Run;

PROC SQL;
	Create Table TEMP2 as
		Select b.*
			From local.analysis_file_weight3 as a
			INNER JOIN TEMP as b
			ON a.enrolid = b.enrolid and
			a.STUDY_START <= b.DATE <= a.INDEX_DATE;
Quit;

proc freq data=temp2 noprint;
	Tables enrolid / out=jnk;
Run;

Proc Univariate data=jnk;
	VAR COUNT; run;

/* Quartiles are approximately:
	1   - 19
	20  - 34
	35  - 59
	60+
*/

DATA JNK2;
	SET JNK;

	LENGTH UTIL_CAT $20;
	IF COUNT < 20 THEN UTIL_CAT = '1: 1 - 19';
	ELSE IF COUNT < 35 THEN UTIL_CAT = '2: 20 - 34';
	ELSE IF COUNT < 60 THEN UTIL_CAT = '3: 35 - 59';
	ELSE UTIL_CAT = '4: 60+';
Run;

Proc FREQ Data=jnk2;
	Tables UTIL_CAT; run;

Proc SQL;
	Create Table ADD_VIS as
		Select a.*, b.UTIL_CAT
			From local.analysis_file_weight3 as a
			LEFT JOIN JNK2 as b
			ON a.ENROLID = b.enrolid;
Quit;

Proc FREQ data=ADD_VIS;
	Tables UTIL_CAT; run;

/* ADD NEW CAD */ 

%INDY_1_C(CLASS = CAD
		, START_RANGE = STUDY_START
		, END_RANGE = INDEX_DATE
		, DATA_IN = ADD_VIS
		, DATA_OUT = ADD_CAD
		, CODE_FILE = REV.CODES_REV
		, VAR_NAME_OUT = CAD_IND_REV
		, PATKEY = ENROLID
		, START_INC = 1
		, END_INC = 1);


DATA ADD_CAD2;
	SET ADD_CAD;


	POLY_COUNT_REV = CAD_IND_REV + PAD_IND + CERB_IND;


	IF CAD_IND_REV = 1 AND PAD_IND =1 AND CERB_IND = 1 THEN POLY_TYPE_REV = 'CPE';
	ELSE IF  CAD_IND_REV = 1 AND PAD_IND =1 AND CERB_IND = 0 THEN POLY_TYPE_REV = 'CPX';
	ELSE IF  CAD_IND_REV = 1 AND PAD_IND =0 AND CERB_IND = 1 THEN POLY_TYPE_REV = 'CXE';
	ELSE IF  CAD_IND_REV = 0 AND PAD_IND =1 AND CERB_IND = 1 THEN POLY_TYPE_REV = 'XPE';
	ELSE IF  CAD_IND_REV = 1 AND PAD_IND =0 AND CERB_IND = 0 THEN POLY_TYPE_REV = 'CXX';
	ELSE IF  CAD_IND_REV = 0 AND PAD_IND =1 AND CERB_IND = 0 THEN POLY_TYPE_REV = 'XPX';
	ELSE IF  CAD_IND_REV = 0 AND PAD_IND =0 AND CERB_IND = 1 THEN POLY_TYPE_REV = 'XXE';
	ELSE DELETE;
RUN;

PROC FREQ data=ADD_CAD2;
	TABLES CAD_IND_REV * PAD_IND * CERB_IND * POLY_COUNT_REV  CAD_IND_REV * PAD_IND * CERB_IND * POLY_TYPE_REV /list missing;
Run;


proc contents data=add_cad2; run;

%SURV_1_C(CLASS = CANCER
		, START_RANGE = INDEX_DATE
		, END_RANGE = STUDY_END
		, DATA_IN = ADD_CAD2
		, DATA_OUT = ADD_SURV
		, CODE_FILE = REV.CODES_REV
		, PATKEY = ENROLID
		, SURV_VAR_NAME = STATUS_REV
		, SURV_DATE_NAME = EVENT_DATE_REV
		, TIME_VAR_NAME = T_REV
		, MORT_DATE = DATE_OF_DEATH);


DATA REV.REV_PREWEIGHTIN;
	SET ADD_SURV;

	MONTH_T_REV = FLOOR(T_REV/30);
	
	IF MONTH_T_REV > 0;
	/* Dropping patients with bogus death data and invalid follow_up after change to months */
Run;