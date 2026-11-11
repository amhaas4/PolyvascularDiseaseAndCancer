/* 	Programmer:		Allen Haas
	Date Created:	28OCT2026
	Purpose:		Pull Healthy Care Utilization Data and Create Approximate Quartiles
*/

libname LOCAL "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files 2/" ACCESS=READONLY;
libname REV "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/";

/* Pull In Macros */
%INCLUDE "/rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/MACRO_LOADER.sas";

/* Set Libnames */
%MKT_LIB_J25;


%MACRO PULL_DAT;


%LET PROV1 = CCAE;
%LET PROV2 = MDCR;


%LET TYPE1 = S;
%LET TYPE2 = O;
%LET TYPE3 = F;
%LET TYPE4 = I;


%DO YEAR = 2014 %TO 2021;
%DO PROVNUM = 1 %TO 2;


%LET TYPENUM = 4;




PROC SQL;
	CREATE Table U_&&PROV&PROVNUM.._&&TYPE&TYPENUM.._&YEAR as
		SELECT ENROLID, ADMDATE, DISDATE
			FROM &&PROV&PROVNUM...&&PROV&PROVNUM.._&&TYPE&TYPENUM.._&YEAR (KEEP = ENROLID ADMDATE DISDATE)
			WHERE ENROLID IN (SELECT ENROLID FROM LOCAL.ANALYSIS_FILE_WEIGHT3);
Quit;


%DO TYPENUM = 1 %TO 3;


PROC SQL;
	CREATE Table U_&&PROV&PROVNUM.._&&TYPE&TYPENUM.._&YEAR as
		SELECT ENROLID, SVCDATE
			FROM &&PROV&PROVNUM...&&PROV&PROVNUM.._&&TYPE&TYPENUM.._&YEAR (KEEP = ENROLID SVCDATE)
			WHERE ENROLID IN (SELECT ENROLID FROM LOCAL.ANALYSIS_FILE_WEIGHT3);
Quit;


%END;
%END;


DATA REV.U_&YEAR;
	SET 
		%DO PROVNUM = 1 %TO 2;
		%DO TYPENUM = 1 %TO 4;
		U_&&PROV&PROVNUM.._&&TYPE&TYPENUM.._&YEAR
		%END;
		%END;
	;
Run;


%END;




%MEND;

%PULL_DAT;