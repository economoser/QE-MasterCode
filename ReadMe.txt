Log of Changes 
First version April, 19, 2019
This  version July, 05, 2019 
Serdar Ozkan (serdar.ozkan@toronto.ca)
Sergio Salgado (salga010@umn.edu)
----------------

July, 05, 2019 

We have modified some of the calculations in the gen_base and mobility codes. In the first, we have added 

	bys male: egen avgall = mean(totearn)
	gen permearnalt`yr' = avgall*totearn/avg	// This is because we want to control for age effects
	
In lines 388 to have permearnalt in the correct scale. This does not change the results. 
The mobility code has more changes. In particular, we have modified the transition matrix calculation to account for 0. Individuals with 0 permanent earnings are now grouped in one category only, whereas the rest of individuals (with positive permearnalt earnings, are separated in 10 groups, to a total of 11 rows in the transition matrix). See lines 240 to 266. We have also saved some summary stats within each cell (see line 248 for instance).  



April, 19, 2019

The folder contains the first version of the code for the Global Income Dynamics Database project. The code was developed in Stata 13 by Serdar Ozkan and Sergio Salgado. 
The original set of do files is the following 

0_Initialize1_Gen_Base_Sample.do2_DescriptiveStats3_Inequality4_Volatility5_Mobility6_Core_FigsGenDatamyplotsmyprogs

See the file Code_Guidelines_April2019.pdf for additional details. 