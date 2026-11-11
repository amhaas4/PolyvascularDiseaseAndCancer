
/* 	Programmer:		Allen Haas
	Date Created:	28OCT2026
	Purpose:		Pulls Updated Codes for CAD and Cancer
*/

libname LOCAL "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files 2/" ACCESS=READONLY;
libname REV "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/";

/* Pull In Macros */
%INCLUDE "/rsrch9/hsr/hsrsrch/userspace/amhaas/Personal/MM2/MACRO_LOADER.sas";

/* Set Libnames */
%MKT_LIB_J25;

/* Set Codebook Location */
%LET CODEBOOK_LOCATION = "/rsrch9/hsr/hsrsrch/userspace/amhaas/Nead/Polyvascular Disease/Working Files - Revisions/Revisions Codebook.xlsx";

/* Read Codebook */
%MKT_CODEBOOK_READER(&CODEBOOK_LOCATION);

/* Pulls Codes

THIS IS COMMENTED OUT SO IT CAN'T BE RUN ON ACCIDENT.  IT WILL DELETE THE PREVIOUS CODE FILE AND TAKE ~16 HOURS TO RUN

%MKT_PULL_CODES(START_YEAR = 2014, END_YEAR = 2021, OUTFILE=REV.CODES_REV, TEST=N, LIBTEMP = REV);

*/