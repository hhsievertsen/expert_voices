// Create Figure 1

// Load settings
do "C:\Users\B059633\Dropbox\Work\Research\Projects\Gender Econ\submissions\PUS\Final edits for PUS\Replication Package\scripts\settings.do"
// Load data 
u "data/igm_data.dta",clear

// General graph settings
local y			= "ylab(,grid) ysize(12)  yscale(titlegap(-5))"
local x			= "xlab(,labgap(3) format(%4.2f)) xline(0) xsize(15) "
local markers	= "msize(medsmall) msymbol(D) mcolor(black)"
local ci		= "levels(95 90)  ciopts( lcolor(black%20 black%30) lwidth(3 3))"
local overall 	= "grid(none) graphregion(margin(5 5 5 5))" 
gl gs= "`y' `x' `markers' `ci' `overall'"
					
					
// Run regressions
gen responded=1-j_didnotanswer
gen opinion=1-j_no_opinion
gen certain=1-j_uncertain
eststo clear
eststo m1: reghdfe opinion 		i_male $controls, absorb($absorb)  cluster(q_Question )
eststo m2: reghdfe responded    i_male $controls , absorb($absorb)  cluster(q_Question )
eststo m3: reghdfe certain      i_male $controls, absorb($absorb)  cluster(q_Question )
eststo m4: reghdfe j_strong     i_male $controls if j_likert!=0, absorb($absorb)  cluster(q_Question )
eststo m5: reghdfe j_Confidence i_male  $controls , absorb($absorb) cluster(q_Question )

// Create chart
coefplot  ///
		  (m1, aseq("Opinion")) 			 						///
		  (m2, aseq("Responding")) 			 						///
		  (m3, aseq("Certain")) 			 						///
		  (m4, aseq("Strong opinion")) 						  		 	///
		  (m5, aseq("Confidence")) 		 								///  
		 ,keep(i_male)    swapnames  									///
		$gs 															///
		xtitle("Male - female difference ")								///
		headings("Opinion"= "{bf:Outcomes                   }"  ) 					///
		legend(order(3 "Coefficient" 1 "95%" 2 "90%" ) rows(1) 			///
		position(12)) mlabel format(%9.3f) mlabposition(12) mlabgap(*3)
		
// Save chart
	graph export "output\figure1.png",replace	width(2000)

	
// Save table
esttab using "output\\Table_S1.rtf",  ///
       b(%4.3f)  star(* 0.1 ** 0.05 *** 0.01) label  replace   nogaps  se	    rtf   
	
	
