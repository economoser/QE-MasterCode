/*
	This code plots the time series of the moments geneated for the QE project
	First version, March,03,2019
    Last edition April, 29, 2019
	
	This code might need to be updated to accomodate the particular characteristics of 
	the data in each country. If you have problems, contact Ozkan/Salgado on Slack
*/

*DEFINE PLOTING FUNCTIONS
capture program drop  dnplot tsplt tsplt2sc tsplt2scREC

/*
	dnplot: THIS PROGRAM GENERATES DENSITY/RANK PLOTS

*/
program dnplot

graph set window fontface "${fontface}"

*Defines variable y-axis
	local yvar = "`1'"
	
	*Defines variable in the x-axis
	local xvar = "`2'"
		
	/*Define limits of x-axis. If need to set axis, contact Ozkan/Salgado on Slack
	local xmin = `3'
	local xmax = `4'
	local xdis = `5'
	
	local ymin = `6'
	local ymax = `7'
	local ydis = `8'
	*/
	
	*Define Title, Subtitle, and axis labels 
	local xtitle = "`3'"
	local ytitle = "`4'"
	local xtitlesize = "`5'"
	local ytitlesize = "`6'"

	local title = "`7'"
	local subtitle = "`8'"
	local titlesize = "`9'"
	local subtitlesize = "`10'"
	
	*Define labels
	local lab1 = "`11'"
	local lab2 = "`12'"
	local lab3 = "`13'"
	local lab4 = "`14'"
	local lab5 = "`15'"
	local lab6 = "`16'"
	
	
	*Whether drop legend
	local off = "`17'"
	
	*What is the position of the legend
	local posleg = `18'
	
	*Define name and output file 
	local namefile = "`19'"
	
	
	*Some globals defined
	local formatfile = "${formatfile}"			// format of saved file 
	local folderfile = "${folderfile}"			// folder where the plot is saved	

	tw line `yvar' `xvar' , ///
	lcolor(red blue green maroon navy forest_green)  ///			Line color
	lpattern(solid longdash dash solid longdash dash )  ///			Line pattern
	lwidth(medthick medthick medthick medthick medthick medthick) /// Thickness of plot
	ytitle(`ytitle', axis(1) size(`ytitlesize')) ylabel(,axis(1))  /// y-axis options 
	xtitle("") xtitle(`xtitle',size(`xtitlesize')) xlabel(,grid) ///		xaxis options
	legend(`off' ring(0) position(`posleg') col(2) order(1 "`lab1'" 2 "`lab2'" 3 "`lab3'" 4 "`lab4'" 5 "`lab5'" 6 "`lab6'") ///
	region(lcolor(white))) graphregion(color(white)) /// Legend options 
	graphregion(color(white)  ) ///				Graph region define
	plotregion(lcolor(black))  ///				Plot regione define
	title(`title', color(black) size(`titlesize')) subtitle(`subtitle', color(black) size(`subtitlesize'))  // Title and subtitle
	cap: graph export `folderfile'/`namefile'.`formatfile', replace 

end 


/*
tsplt: THE FOLLOWING PROGRAMS GENERATE TIME SERIES PLOTS FOR UP TO NINE TIME SERIES

This is an example using three time series

tsplt "p90researn p50researn p10researn" /// Which variables 
	  "year" 							 /// Time variable for the x axis
	  "rece"							/// Name of variable for recessions (must be 0 and 1)
	  -2 2 0.5 1993 2013 5 					 /// What are the x and y limits and jump in between
	  "P90" "P50" "P10" "" "" "" 		 /// What are the labels?
	  "" "Moments of Log Earnings" 		 /// What is the x-title and y-title?
	  "medium" "medium"					 /// What are the x-title and y-title font sizes?
	  "Moments of Residual Log Earnings" "" 		 /// What are the title and subtitle of the plot?
	  "large" "medium"					 /// What are the title and subtitle font sizes?
	  "p90andp10researn" "pdf"			 //  Name and format of output file 

*/

program tsplt

graph set window fontface "${fontface}"

 
*Define which variables are plotted
local varilist = "`1'"

*Defime the time variable
local timevar = "`2'"

*Define limits of y-axis
*local ymin = `4'
*local ymax = `5'
*local ydis = `6'

*Define limits of x-axis
local xmin = `3'
local xmax = `4'
local xdis = `5'

*Define labels
local lab1 = "`6'"
local lab2 = "`7'"
local lab3 = "`8'"
local lab4 = "`9'"
local lab5 = "`10'"
local lab6 = "`11'"
local lab7 = "`12'"
local lab8 = "`13'"
local lab9 = "`14'"

*Define Title, Subtitle, and axis labels 
local xtitle = "`15'"
local ytitle = "`16'"
local title = "`17'"
local subtitle = "`18'"

*Define name and output file 
local namefile = "`19'"

*Some global defined 

local xtitlesize = "${xtitlesize}" 			// Size of xtitle font
local ytitlesize = "${ytitlesize}" 			// Size of ytitle font
local titlesize = "${titlesize}"			// Size of title font
local subtitlesize = "${subtitlesize}"		// Size of subtiotle font
local formatfile = "${formatfile}"			// format of saved file 
local folderfile = "${folderfile}"			// folder where the plot is saved
local marksize = "${marksize}"				// Marker size 


*Calculating plot limits
	local it = 1
	foreach vv of local varilist{
		if `it' == 1{
			
			qui: sum `vv'
			local upt = r(min)
			local ipt = r(max)
	
			local opt1 = "`upt'"
			local opt2 = "`ipt'"
			local it = 0
		}
		else{
			qui: sum `vv'
			local upt = r(min)
			local ipt = r(max)
			
			local opt1 = "`opt1',`upt'"
			local opt2 = "`opt2',`ipt'"
			local it = 2
		}
	
	}
	
	if `it' == 0 {
		local rmin = `upt'
		local rmax = `ipt'
	}
	else{
		local rmin = min(`opt1')
		local rmax = max(`opt2')
	}
	
				
	
	local ymin1 : di %4.2f  round(`rmin'*(0.9),0.1)
	local ymax1 : di %4.2f round(`rmax'*(1+0.1),0.1)
	local ydis1 = (`ymax1' - `ymin1')/5
	
*Plot
tw  (connected `varilist'  `timevar', 				 /// Plot
	lcolor(red blue green maroon navy forest_green navy magenta orange)  ///			Line color
	lpattern(solid longdash dash solid longdash dash solid longdash dash)  ///			Line pattern
	msymbol(O T D O T D O T D)		/// Marker
	msize("`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" )		/// Marker size
	mfcolor(red*0.25 blue*0.25 green*0.25 maroon*0.25 navy*0.25 forest_green*0.25  navy*0.25 magenta*0.25 orange*0.25)  ///	Fill color
	mlcolor(red blue green maroon navy forest_green navy magenta orange)  ///			Marker  line color
	yaxis(1)  ytitle(`ytitle', axis(1) size(`ytitlesize')) ylabel(,axis(1))) , /// yaxis optins
	xtitle("") xtitle(`xtitle',size(`xtitlesize')) xlabel(`xmin'(`xdis')`xmax',grid) ///		xaxis options
	legend(col(2) symxsize(7.0) ring(0) position(11) ///
	order(1 "`lab1'" 2 "`lab2'" 3 "`lab3'" 4 "`lab4'" 5 "`lab5'" 6 "`lab6'" 7 "`lab7'" 8 "`lab8'" 9 "`lab9'") ///
	region(lcolor(white))) graphregion(color(white)) /// Legend options 
	graphregion(color(white)  ) ///				Graph region define
	plotregion(lcolor(black))  ///				Plot regione define
	title(`title', color(black) size(`titlesize')) subtitle(`subtitle', color(black) size(`subtitlesize'))  // Title and subtitle
	cap noisily: graph export `folderfile'/`namefile'.`formatfile', replace 

end

program tspltAREA

graph set window fontface "${fontface}"

 
*Define which variables are plotted
local varilist = "`1'"

*Defime the time variable
local timevar = "`2'"

*Define limits of y-axis
*local ymin = `4'
*local ymax = `5'
*local ydis = `6'

*Define limits of x-axis
local xmin = `3'
local xmax = `4'
local xdis = `5'

*Define labels
local lab1 = "`6'"
local lab2 = "`7'"
local lab3 = "`8'"
local lab4 = "`9'"
local lab5 = "`10'"
local lab6 = "`11'"
local lab7 = "`12'"
local lab8 = "`13'"
local lab9 = "`14'"

*Define Title, Subtitle, and axis labels 
local xtitle = "`15'"
local ytitle = "`16'"
local title = "`17'"
local subtitle = "`18'"

*Define name and output file 
local namefile = "`19'"

*Some global defined 

local xtitlesize = "${xtitlesize}" 			// Size of xtitle font
local ytitlesize = "${ytitlesize}" 			// Size of ytitle font
local titlesize = "${titlesize}"			// Size of title font
local subtitlesize = "${subtitlesize}"		// Size of subtiotle font
local formatfile = "${formatfile}"			// format of saved file 
local folderfile = "${folderfile}"			// folder where the plot is saved
local marksize = "${marksize}"				// Marker size 


*Calculating plot limits
	local it = 1
	foreach vv of local varilist{
		if `it' == 1{
			
			qui: sum `vv'
			local upt = r(min)
			local ipt = r(max)
	
			local opt1 = "`upt'"
			local opt2 = "`ipt'"
			local it = 0
		}
		else{
			qui: sum `vv'
			local upt = r(min)
			local ipt = r(max)
			
			local opt1 = "`opt1',`upt'"
			local opt2 = "`opt2',`ipt'"
			local it = 2
		}
	
	}
	
	if `it' == 0 {
		local rmin = `upt'
		local rmax = `ipt'
	}
	else{
		local rmin = min(`opt1')
		local rmax = max(`opt2')
	}
	
				
	
	local ymin1 : di %4.2f  round(`rmin'*(0.9),0.1)
	local ymax1 : di %4.2f round(`rmax'*(1+0.1),0.1)
	local ydis1 = (`ymax1' - `ymin1')/5
	
*Plot
tw   (bar rece year, c(l) color(gray*0.5) yscale(off)) ///
	(connected `varilist'  `timevar',  				 /// Plot
	lcolor(red blue green maroon navy forest_green navy magenta orange)  ///			Line color
	lpattern(solid longdash dash solid longdash dash solid longdash dash)  ///			Line pattern
	msymbol(O T D O T D O T D)		/// Marker
	msize("`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" )		/// Marker size
	mfcolor(red*0.25 blue*0.25 green*0.25 maroon*0.25 navy*0.25 forest_green*0.25  navy*0.25 magenta*0.25 orange*0.25)  ///	Fill color
	mlcolor(red blue green maroon navy forest_green navy magenta orange)  ///			Marker  line color
	yaxis(2)  yscale(alt axis(2)) ytitle(`ytitle', axis(2) size(`ytitlesize')) ylabel(,axis(2))) , /// yaxis optins
	xtitle("") xtitle(`xtitle',size(`xtitlesize')) xlabel(`xmin'(`xdis')`xmax',grid) ///		xaxis options
	legend(col(1) symxsize(7.0) ring(0) position(11) ///
	order(2 "`lab2'" 3 "`lab3'" 4 "`lab4'" 5 "`lab5'" 6 "`lab6'" 7 "`lab7'" 8 "`lab8'" 9 "`lab9'") ///
	region(lcolor(white))) graphregion(color(white)) /// Legend options 
	graphregion(color(white)  ) ///				Graph region define
	plotregion(lcolor(black))  ///				Plot regione define
	title(`title', color(black) size(`titlesize')) subtitle(`subtitle', color(black) size(`subtitlesize'))  // Title and subtitle
	cap noisily: graph export `folderfile'/`namefile'.`formatfile', replace 

end


program tsplt2sc

graph set window fontface "${fontface}"

 
*Define which variables are plotted
local varilist1 = "`1'"
local varilist2 = "`2'"

*Defime the time variable
local timevar = "`3'"

/*Define limits of y-axis 1
local ymin1 = `4'
local ymax1 = `5'
local ydis1 = `6'

*Define limits of y-axis 2
local ymin2 = `7'
local ymax2 = `8'
local ydis2 = `9'
*/

*Define limits of x-axis
local xmin = `4'
local xmax = `5'
local xdis = `6'

*Define labels
local lab1 = "`7'"
local lab2 = "`8'"

*Define Title, Subtitle, and axis labels 
local xtitle = "`9'"
local ytitle1 = "`10'"
local ytitle2 = "`11'"
local title = "`12'"
local subtitle = "`13'"

*Define name and output file 
local namefile = "`14'"

*Some global defined 

local xtitlesize = "${xtitlesize}" 			// Size of xtitle font
local ytitlesize = "${ytitlesize}" 			// Size of ytitle font
local titlesize = "${titlesize}"			// Size of title font
local subtitlesize = "${subtitlesize}"		// Size of subtiotle font
local formatfile = "${formatfile}"			// format of saved file 
local folderfile = "${folderfile}"			// folder where the plot is saved
local marksize = "${marksize}"				// Marker size 


*Calculating plot limits
qui: sum `varilist1'
	
	local aux1 = r(rmin) 
	if `aux1' < 0 {
		local mfact = 1.1
	}
	else {
		local mfact = 0.9
	}
	
	local ymin1: di %4.2f round(r(min)*`mfact',0.1)
	local ymax1: di %4.2f round(r(max)*(1+0.1),0.1)
	local ydis1 = (`ymax1' - `ymin1')/5
	
qui: sum `varilist2'
	local aux1 = r(min) 
	if `aux1' < 0 {
		local mfact = 1.1
	}
	else {
		local mfact = 0.9
	}
	local ymin2: di %4.2f round(r(min)*`mfact',0.1)
	local ymax2: di %4.2f round(r(max)*(1+0.1),0.1)
	local ydis2 = (`ymax2' - `ymin2')/5


*Plot
tw  (connected `varilist1'  `timevar', 				 /// Plot
	lcolor(red blue green maroon navy forest_green navy magenta orange)  ///			Line color
	lpattern(solid longdash dash solid longdash dash solid longdash dash)  ///			Line pattern
	msymbol(O T D O T D O T D)		/// Marker
	msize("`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" )		/// Marker size
	mfcolor(red*0.25 blue*0.25 green*0.25 maroon*0.25 navy*0.25 forest_green*0.25  navy*0.25 magenta*0.25 orange*0.25)  ///	Fill color
	mlcolor(red blue green maroon navy forest_green navy magenta orange)  ///			Marker  line color
	yaxis(1)  ytitle(`ytitle1', axis(1) size(`ytitlesize')) ylabel(`ymin1'(`ydis1')`ymax1',axis(1))) ///
	///
	(connected `varilist2'  `timevar', 				 /// Plot
	lcolor(blue green maroon navy forest_green navy magenta orange red)  ///			Line color
	lpattern(longdash dash solid longdash dash solid longdash dash solid)  ///			Line pattern
	msymbol(O T D O T D O T D)		/// Marker
	msize("`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" )		/// Marker size
	mfcolor(blue*0.25 green*0.25 maroon*0.25 navy*0.25 forest_green*0.25  navy*0.25 magenta*0.25 orange*0.25 red*0.25 )  ///	Fill color
	mlcolor(blue green maroon navy forest_green navy magenta orange red )  ///			Marker  line color
	yaxis(2)  ytitle(`ytitle2', axis(2) size(`ytitlesize')) ylabel(`ymin2'(`ydis2')`ymax2',axis(2))) ///
	///
	,xtitle("") xtitle(`xtitle',size(`xtitlesize')) xlabel(`xmin'(`xdis')`xmax',grid) ///		xaxis options
	legend(col(2) symxsize(7.0) ring(0) position(11) ///
	order(1 "`lab1'" 2 "`lab2'") ///
	region(lcolor(white))) graphregion(color(white)) /// Legend options 
	graphregion(color(white)  ) ///				Graph region define
	plotregion(lcolor(black))  ///				Plot regione define
	title(`title', color(black) size(`titlesize')) subtitle(`subtitle', color(black) size(`subtitlesize'))  // Title and subtitle
	cap noisily: graph export `folderfile'/`namefile'.`formatfile', replace 

end



program tsplt2scREC

graph set window fontface "${fontface}"

 
*Define which variables are plotted
local varilist1 = "`1'"
local varilist2 = "`2'"
local rece = "`3'"

*Defime the time variable
local timevar = "`4'"

/*Define limits of y-axis 1
local ymin1 = `4'
local ymax1 = `5'
local ydis1 = `6'

*Define limits of y-axis 2
local ymin2 = `7'
local ymax2 = `8'
local ydis2 = `9'
*/

*Define limits of x-axis
local xmin = `5'
local xmax = `6'
local xdis = `7'

*Define labels
local lab1 = "`8'"
local lab2 = "`9'"

*Define Title, Subtitle, and axis labels 
local xtitle = "`10'"
local ytitle1 = "`11'"
local ytitle2 = "`12'"
local title = "`13'"
local subtitle = "`14'"

*Define name and output file 
local namefile = "`15'"

*Some global defined 

local xtitlesize = "${xtitlesize}" 			// Size of xtitle font
local ytitlesize = "${ytitlesize}" 			// Size of ytitle font
local titlesize = "${titlesize}"			// Size of title font
local subtitlesize = "${subtitlesize}"		// Size of subtiotle font
local formatfile = "${formatfile}"			// format of saved file 
local folderfile = "${folderfile}"			// folder where the plot is saved
local marksize = "${marksize}"				// Marker size 


*Calculating plot limits
	qui: sum `varilist1'
	local ymin1 : di %4.2f  round(r(min),0.1)
	local ymax1 : di %4.2f round(r(max),0.1)
	local ydis1 = (`ymax1' - `ymin1')/5
	
	qui: sum `varilist2'
	local ymin2 : di %4.2f round(r(min),0.1)
	local ymax2 : di %4.2f round(r(max),0.1)
	local ydis2 = (`ymax2' - `ymin2')/5


*Re scale recession vars 
	replace `rece' = `ymax1' if `rece' > `ymax1'
	
*Plot
tw  (bar `rece' `timevar' if `timevar' >= `xmin' & `timevar' <= `xmax', color(gs12)) ///
	///
	(connected `varilist1'  `timevar' if `timevar' >= `xmin' & `timevar' <= `xmax', 				 /// Plot
	lcolor(red blue green maroon navy forest_green navy magenta orange)  ///			Line color
	lpattern(solid longdash dash solid longdash dash solid longdash dash)  ///			Line pattern
	msymbol(O T D O T D O T D)		/// Marker
	msize("`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" )		/// Marker size
	mfcolor(red*0.25 blue*0.25 green*0.25 maroon*0.25 navy*0.25 forest_green*0.25  navy*0.25 magenta*0.25 orange*0.25)  ///	Fill color
	mlcolor(red blue green maroon navy forest_green navy magenta orange)  ///			Marker  line color
	yaxis(1)  ytitle(`ytitle1', axis(1) size(`ytitlesize')) ylabel(`ymin1'(`ydis1')`ymax1',axis(1))) ///
	///
	(connected `varilist2'  `timevar' if `timevar' >= `xmin' & `timevar' <= `xmax', 				 /// Plot
	lcolor(blue green maroon navy forest_green navy magenta orange red)  ///			Line color
	lpattern(longdash dash solid longdash dash solid longdash dash solid)  ///			Line pattern
	msymbol(O T D O T D O T D)		/// Marker
	msize("`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" "`marksize'" )		/// Marker size
	mfcolor(blue*0.25 green*0.25 maroon*0.25 navy*0.25 forest_green*0.25  navy*0.25 magenta*0.25 orange*0.25 red*0.25 )  ///	Fill color
	mlcolor(blue green maroon navy forest_green navy magenta orange red )  ///			Marker  line color
	yaxis(2)  ytitle(`ytitle2', axis(2) size(`ytitlesize')) ylabel(`ymin2'(`ydis2')`ymax2',axis(2))) ///
	///
	,xtitle("") xtitle(`xtitle',size(`xtitlesize')) xlabel(`xmin'(`xdis')`xmax',grid) ///		xaxis options
	legend(col(2) symxsize(7.0) ring(0) position(11) ///
	order(1 "`lab1'" 2 "`lab2'") ///
	region(lcolor(white))) graphregion(color(white)) /// Legend options 
	graphregion(color(white)  ) ///				Graph region define
	plotregion(lcolor(black))  ///				Plot regione define
	title(`title', color(black) size(`titlesize')) subtitle(`subtitle', color(black) size(`subtitlesize'))  // Title and subtitle
	cap noisily: graph export `folderfile'/`namefile'.`formatfile', replace 

end







