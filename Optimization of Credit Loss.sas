%let loss_limit = 10000;
%let min_offers = 50;
proc optmodel;
   /* declare sets and parameters */
   set CUSTOMERS;
   set PRODUCTS = 1..3;
   num exp_profit {CUSTOMERS, PRODUCTS}, 
     credit_loss {CUSTOMERS, PRODUCTS};

   /* read data from SAS data sets */
   read data opt.bank_offers into CUSTOMERS=[ID]
     {j in PRODUCTS} <exp_profit[ID,j]=col('exprofit'||j)
       credit_loss[ID,j]=col('creditloss'||j)>;

   /* declare variables */
   var MakeOffer {CUSTOMERS, PRODUCTS} binary;

   impvar NumOffers {j in PRODUCTS} = 
     sum {i in CUSTOMERS} MakeOffer[i,j];

   /* declare constraints */
   con At_most_one_offer {i in CUSTOMERS}: 
     sum {j in PRODUCTS} MakeOffer[i,j] <= 1;

   con Min_offers_con {j in PRODUCTS}: 
     NumOffers[j] >= &min_offers;

   con Max_credit_loss: sum {i in CUSTOMERS, j in PRODUCTS} 
     credit_loss[i,j] * MakeOffer[i,j] <= &loss_limit;

   /* declare objective */
   max ExpectedProfit = sum {i in CUSTOMERS, j in PRODUCTS}
     exp_profit[i,j] * MakeOffer[i,j];

   reset printlevel=0;

   set VALUES = 15000..35000 by 5000;
   num profit {VALUES};

   for {v in VALUES} do;
     Max_credit_loss.ub = v;

     solve with milp / primalin allcuts=none;

     profit[v] = ExpectedProfit;
	 
     print Max_credit_loss.ub ExpectedProfit NumOffers; 
   end;

   create data credit_offer_data from [Credit_Loss]=VALUES 
     Expected_Profit=profit;

   quit;
title 'Expected Profit from Product Offers';
proc sgplot data=credit_offer_data;
   pbspline x=Credit_Loss y=Expected_Profit 
     / lineattrs=(color=red thickness=2)
       nolegfit nomarkers; 
   xaxis values=(15000 to 35000 by 5000);
   yaxis values=(125 to 275 by 25);
run;
