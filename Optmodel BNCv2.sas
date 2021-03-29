*Log Reg model includes Intercept, NINQ DELINQ DEROG  ;

*Loan interest rate 0.06;
*risk free rate is 0.01;

proc optmodel;
	/* declare index sets */
	set CUSTOMERS;
	set BETA;
	set VALUE;
	set PROB;
	*set SEGMENTS;

	/* declare paramets */
	num ID{CUSTOMERS};
	num Estimate{BETA};
	num LOAN{VALUE}; *LOAN;
	num P_1{PROB};
	*num SEG {SEGMENT};	*_CLUSTER_ID_;

	/* read data sets to populate data */
	read data BNC.HMEQ_RENEW_7_F into CUSTOMERS=[customer];
	read data BNC.HMEQ_RENEW_7_F into VALUE=[_N_] LOAN; *Price;
	read data BNC.BNC_ESTIMATES_7 into Beta=[_N_] Estimate; *Coefficient Vector B;
	read data BNC.RENEW_7PROB_F into PROB=[_N_] P_1; *Probability of Default;
	
	print LOAN;
	print Estimate;
	print P_1;

	/* declare decision variables */
	var interest {CUSTOMERS} >=0;

	/* declare objective */
	MAX PROFIT = 
		sum {i in CUSTOMERS} (1 - PROB[i]) * VALUE[i] * interest[i];

	/* declare constraints */
	con max_interest {i in CUSTOMERS}: interest{CUSTOMERS} <= 3;
	
	/* display expanded model */
	expand;

	/* call MILP solver (problem type automatically determined) */
	solve;

	/* print solution */
	print interest;

	/* write solution to data sets */
	create data Soldata1 from [i] interest;
	
quit;
