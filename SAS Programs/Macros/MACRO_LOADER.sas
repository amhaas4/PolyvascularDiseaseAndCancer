/*	Programmer:  Allen Haas
	Created:	 07NOV2026
	Purpose: 	 Load Macros for Marketscan Analysis
*/




%LET MACRO_LOC = /rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/;


%MACRO MACRO_LOADER(MACRO_NAME);
	
	%PUT NOTE: LOADING MACRO &MACRO_NAME;
	%INCLUDE "&MACRO_LOC.&MACRO_NAME..sas";
%MEND;

%MACRO_LOADER(INDY_1_C);
%MACRO_LOADER(INDY_2_1);
%MACRO_LOADER(MKT_CODEBOOK_READER);
%MACRO_LOADER(MKT_LIB_D25);
%MACRO_LOADER(MKT_LIB_J25);
%MACRO_LOADER(MKT_PULL_CODES);
%MACRO_LOADER(SURV_1_C);