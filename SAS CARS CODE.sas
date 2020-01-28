proc print data=sashelp.cars label noobs 
      contents="Honda Cars";                        
	  label MPG_City="MPG City";
	  var Model MSRP MPG_City;
	  where make="Honda";
run;
