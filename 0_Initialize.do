// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// This code specify country-specific variables.  
// This version April 17, 2019
// Serdar Ozkan and Sergio Salgado
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// PLEASE DO NOT CHANGE VALUES FRM LINE 7 TO 20. IF NEEDS TO BE CHANGED, CONTACT Ozkan/Salgado

set more off
set matsize 500
set linesize 255
version 13  // This program uses Stata version 13. 

global begin_age = 25 		// Starting age
global end_age = 55			// Ending age
global base_price = 2010	// The base year nominal values are converted to real. 
global winsor=99.999999		// The values above this percentile are going to be set to this percentile. 
global noise=0.0			// The values above this percentile are going to be set to this percentile. 


// PLEASE MAKE THE APPROPRIATE CHANGES BELOW. 

global unix=1  // Please change this to 1 if you run stata on Unix or Mac

global wide=0  // Please change this to 1 if your raw data is in wide format; 0 if long. 

if($unix==1){
	global sep="/"
}
else{
	global sep="\"
}
// If there are missing observations for earnings between $begin_age and $end_age
// set the below global to 1. Otherwise, the code will convert all missing earnings
// observations to zero.
global miss_earn=0 

//Please change the below to the name of the actual data set
global datafile="$maindir${sep}dta${sep}data_long" 

// Define the variable names in your dataset.
global personid_var="idnr" 	// The variable name for person identity number.
global male_var="male" 		// The variable name for gender: 1 if male, 0 o/w.
global yob_var="b_year" 	// The variable name for year of birth.
global yod_var="yod" 		// The variable name for year of death.
global educ_var="educ" 		// The variable name for year of death.
global labor_var="wage_inc" // The variable name for total annual labor earnings from all jobs during the year.  
global year_var="year" 		// The variable name for year if the data is in long format


// Define these variables for your dataset
global yrfirst = 1993 		// First year in the dataset 
global yrlast = 2013 		// Last year in the dataset

global kyear = 5
	// This controls the years for which the empirical densities will be calculated.
	// The densisity is calculated every mod(year/kyear) == 0. Set to 1 if 
	// every year is needed (If need changes, contact  Ozkan/Salgado)
	
global nquantiles = 40
	// Number of quantiles used in the statistics conditioning on permanent income
	// One additional quintile will be added at the top for a total of 41 (see Guidelines)
		
global hetgroup = `" male age educ "male age" "male educ" "male educ age" "' 
	// Define heterogenous groups for which time series stats will be calculated 


// Price index for converting nominal values to real, e.g., the PCE for the US.  
// IMPORTANT: Please set the CPI starting from year ${yrfirst} and ending in ${yrlast}.

global cpi2018 = 100.0		// Set the value of the CPI in 2018. 

matrix cpimat = /*  CPI between ${yrfirst}  and ${yrlast}
*/ (73.279,74.803,76.356,77.981,79.327,79.936,81.110,83.131,84.736,85.873, /*
*/	87.572,89.703,92.261,94.729,97.101,100.065,100.000,101.653,104.149,106.062, /*
*/	107.333 )'
matrix cpimat = 100*cpimat/${cpi2018}

matrix rmininc = /* Minimum income threshold between ${yrfirst}  and ${yrlast} in REAL TERMS.
*/ (1500,1500,1500,1500,1500,1500,1500,1500,1500,1500,1500,/*
*/  1500,1500,1500,1500,1500,1500,1500,1500,1500,1500)'

matrix exrate = /*  Nominal average exchange rate from FRED between ${yrfirst}  and ${yrlast} (LC per dollar)
*/ (7.101,7.055,6.335,6.459,7.086,7.552,7.807,8.813,8.996,7.984, /*
*/	7.080,6.740,6.441,6.409,5.856,5.637,6.291,6.045,5.602,5.818, /*
*/	5.877)'

// PLEASE DO NOT CHANGE THIS PART. IF NEEDS TO BE CHANGED, CONTACT Ozkan/Salgado
	
*global yrlist = ///
*	"${yrfirst} 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 ${yrlast}"
*	// Define the years for which the inequality and concetration measures are calculated

global  yrlist = ""
forvalues yr = $yrfirst(1)$yrlast{
	global yrlist = "${yrlist} `yr'"
}		
	
*global d1yrlist = ///
*	"1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012"
	// Define years for which one-year log-changes measures are calculated

global d1yrlist = ""
local tempyr = $yrlast-1
forvalues yr = $yrfirst(1)`tempyr'{
	global d1yrlist = "${d1yrlist} `yr'"
}
	
*global d5yrlist = ///
*	"1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008"
	// Define years t for which five-years log-changes between t+5 and t are calculated
	
global d5yrlist = "$yrfirst"
local tempyrb = $yrfirst+1
local tempyr = $yrlast-5
forvalues yr = `tempyrb'(1)`tempyr'{
	local tmp = ",`yr'"
	global d5yrlist = "${d5yrlist}`tmp'"
}	
	
*global perm3yrlist = /// 
*	"1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,${yrlast}"
	// Define the ending years (t) to construct permanent income between t-2 and t 
	
local tempyrb = $yrfirst+2	
global perm3yrlist = "`tempyrb'"
local tempyrb = $yrfirst+3	
local tempyre = $yrlast
forvalues yr = `tempyrb'(1)`tempyre'{
	local tmp = ",`yr'"
	global perm3yrlist = "${perm3yrlist}`tmp'"
}	
