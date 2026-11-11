



%MACRO SURV_1_C(CLASS
		, START_RANGE
		, END_RANGE
		, DATA_IN
		, DATA_OUT
		, CODE_FILE
		, PATKEY
		, SURV_VAR_NAME = STATUS
		, SURV_DATE_NAME = EVENT_DATE
		, TIME_VAR_NAME = T
		, MORT_DATE = '31DEC2999'd
		);

PROC SQL;
	Create Table ZYNPVNQ1 as
		Select a.*, b.DATE as DATE_ZYNPVNQ
			From &DATA_IN as a
			Left Join &CODE_FILE as b
			ON a.&PATKEY = b.&PATKEY
				AND a.&START_RANGE < b.DATE <= a.&END_RANGE
				AND b.CLASS = "&CLASS";
Quit;

Proc Sort DATA = ZYNPVNQ1;
	BY &PATKEY DATE_ZYNPVNQ;
Run;

DATA &DATA_OUT;
	SET ZYNPVNQ1;
	BY &PATKEY;
	IF FIRST.&PATKEY;
	
	LENGTH &SURV_VAR_NAME $6;

	IF DATE_ZYNPVNQ NE . THEN DO;
		&SURV_VAR_NAME = 'EVENT';
		&SURV_DATE_NAME = DATE_ZYNPVNQ;
		&TIME_VAR_NAME = DATE_ZYNPVNQ - &START_RANGE;
	End;
	ELSE IF &MORT_DATE NE . AND &MORT_DATE <= &END_RANGE THEN DO;
		&SURV_VAR_NAME = 'MORT';
		&SURV_DATE_NAME = &MORT_DATE;
		&TIME_VAR_NAME = &MORT_DATE - &START_RANGE;
	END;		
	Else DO;
		&SURV_VAR_NAME = 'CENSOR';
		&TIME_VAR_NAME = &END_RANGE - &START_RANGE;
	END;

	Label &SURV_VAR_NAME = "Censoring Variable &CLASS Survival Outcome, 1 Code Definition";
	Label &SURV_DATE_NAME = "Date of Survival Outcome for &CLASS if applicable, 1 Code Definition";
	Label &TIME_VAR_NAME = "Time to Event for &CLASS, 1 Code Definition";
	drop DATE_ZYNPVNQ;
Run;

Proc Freq data=&DATA_OUT;
	Tables &SURV_VAR_NAME ;
Run;

Proc univariate data=&DATA_OUT;
	Class &SURV_VAR_NAME;
	VAR &TIME_VAR_NAME;
	histogram;
Run;



%MEND;