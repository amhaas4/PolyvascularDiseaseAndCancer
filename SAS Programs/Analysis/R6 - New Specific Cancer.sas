/* 	Programmer:		Allen Haas
	Date Created:	03NOV2026
	Purpose:		Label Events for use in specific cancer model
*/

libname LOCAL "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files 2/" ACCESS=READONLY;
libname REV "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/";

/* Pull In Macros */
%INCLUDE "/rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/MACRO_LOADER.sas";

/* Set Libnames */
%MKT_LIB_J25;


/* Attach Cancer Codes */
Proc SQL;
	CREATE TABLE ADD_CAN as

		Select a.*, b.CODE, b.DATE
			FROM REV.AF_WEIGHT_REV as a
			LEFT JOIN REV.CODES_REV as b
			ON a.ENROLID = b.ENROLID
			AND CLASS = 'CANCER'
			AND a.INDEX_DATE <= b.DATE <= a.STUDY_END;
Quit;


Proc SORT data=ADD_CAN;
	By ENROLID DATE;
Run;

DATA ADD_CAN;
	SET ADD_CAN;
	BY ENROLID;
	IF FIRST.ENROLID;
Run;

Proc FREQ data=ADD_CAN;
	TABLE CODE;
	WHERE STATUS_REV = 'EVENT';
Run;



/* Bring In Cancer Type Labels */
PROC IMPORT datafile="/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/Revisions CancerType.xlsx" 
	out=jnk dbms=xlsx replace;
	getnames=yes;
Run;

DATA JNK2;
	SET JNK;
	CODE2 = COMPRESS(CODE,".");
Run;


/* Label Cancers */
Proc SQL;
	Create TAble ADD_CAN2 as
		Select a.*, b.CAT as CAN_CAT
			FrOM ADD_CAN as a
			LEFT JOIN JNK2 as b
			ON a.CODE = b.CODE2;
Quit;

Proc Freq data=ADD_CAN2;
	Tables CAN_CAT;
	WHERE STATUS_REV = 'EVENT';
RUN;

DATA REV.CAN_CAT;
SET ADD_CAN2;
Run;