// Figure 2: Heterogeneity

// Load settings
do "C:\Users\B059633\Dropbox\Work\Research\Projects\Gender Econ\submissions\PUS\Final edits for PUS\Replication Package\scripts\settings.do"
// Load data 
u "data/igm_data.dta",clear

// General graph settings
local y			= "ylab(,grid) ysize(18)  yscale(titlegap(-5))"
local x			= "xlab(-0.0(0.05)0.20,labgap(3) format(%4.2f))  xline(0) xsize(15) "
local markers	= "msize(medsmall) msymbol(D) mcolor(black)"
local ci		= "levels(95 90)  ciopts( lcolor(black%20 black%30) lwidth(2.5 2.5))"
local overall 	= "grid(none) graphregion(margin(5 5 5 5))" 
gl gs= "`y' `x' `markers' `ci' `overall'"
					


replace  j_opinion=1-j_no_opinion
// Test equality across expert and non expert
	eststo m1 : reg j_opinion	 i.i_inst i.i_phdyear i.q_Question i_male  expXmal 	$controls 		,
	eststo m2 : reg j_opinion	 i.i_inst i.i_phdyear i.q_Question  i_male  nonexpXmal 	$controls 	,
	suest m1 m2	,  cluster(q_Question )
	test [m1_mean = m2_mean]:i_male
	
	
	
// Run regressions
eststo clear
// Non-expert 
eststo m_nonexpert: reghdfe j_opinion	i_male  expXmal 	$controls 	, absorb($absorb)  cluster(q_Question )
// Expert
eststo m_expert: 	reghdfe j_opinion	i_male  nonexpXmal 	$controls 	, absorb($absorb)  cluster(q_Question )
	
// Theory
eststo m_theory: 	reghdfe j_opinion i_male $controls	 maleXevidence maleXneither	, absorb($absorb)  cluster(q_Question )
// Evidence
eststo m_evidence: 	reghdfe j_opinion i_male $controls	 maleXtheory maleXneither	, absorb($absorb) cluster(q_Question )
// Neither
eststo m_neither: 	reghdfe j_opinion i_male $controls	 maleXevidence maleXtheory	, absorb($absorb)  cluster(q_Question )
// Development
eststo m_dev: 		reghdfe j_opinion i_male $controls	maleXmac maleXpub maleXio  maleXfin  maleXinter maleXlab 	, absorb($absorb)  cluster(q_Question )
// International
eststo m_int: 		reghdfe j_opinion i_male $controls	maleXmac maleXpub maleXio  maleXfin  maleXdev maleXlab, absorb($absorb)  cluster(q_Question )
// Finance
eststo m_fin: 		reghdfe j_opinion i_male $controls	maleXmac maleXpub maleXio  maleXinter maleXdev maleXlab	, absorb($absorb)  cluster(q_Question )
// IO
eststo m_io: 		reghdfe j_opinion i_male $controls	maleXmac maleXpub maleXfin maleXinter maleXdev maleXlab	, absorb($absorb)  cluster(q_Question )
// Public
eststo m_public: 	reghdfe j_opinion i_male $controls	maleXmac maleXio  maleXfin maleXinter maleXdev maleXlab	, absorb($absorb)  cluster(q_Question )
// Macro
eststo m_macro: 	reghdfe j_opinion i_male $controls	maleXpub maleXio  maleXfin maleXinter maleXdev maleXlab	, absorb($absorb)  cluster(q_Question )
// Labour
eststo m_labour: 	reghdfe j_opinion i_male $controls	maleXmac maleXpub maleXio maleXfin maleXinter maleXdev 	, absorb($absorb)  cluster(q_Question )
// Count 1-24
eststo m_count1: 	reghdfe j_opinion i_male $controls	 i.r maleXcount2 maleXcount3 maleXcount4 maleXcount5, absorb($absorb)  cluster(q_Question )
// Count 25-49
eststo m_count2: 	reghdfe j_opinion i_male $controls	 i.r maleXcount1 maleXcount3 maleXcount4 maleXcount5, absorb($absorb) cluster(q_Question )
// Count 50-74
eststo m_count3: 	reghdfe j_opinion i_male $controls	 i.r maleXcount1 maleXcount2 maleXcount4 maleXcount5, absorb($absorb)  cluster(q_Question )
// Count 75-99
eststo m_count4: 	reghdfe j_opinion i_male $controls	 i.r maleXcount1 maleXcount2 maleXcount3 maleXcount5, absorb($absorb)  cluster(q_Question )
// Count >=100
eststo m_count5: 	reghdfe j_opinion i_male $controls	 i.r maleXcount1 maleXcount2 maleXcount3 maleXcount4, absorb($absorb) cluster(q_Question )



// Create chart
coefplot	 (m_count1			,aseq("Question 1-24")) ///
	         (m_count2			,aseq("Question 25-49")) ///
			 (m_count3			,aseq("Question 50-74")) ///
			 (m_count4			,aseq("Question 75-99")) ///
			 (m_count5			,aseq("Quesion >=100")) ///
			(m_dev			,aseq("Development")) ///
	         (m_int			,aseq("International")) ///
			 (m_fin			,aseq("Finance")) ///
			 (m_io			,aseq("IO")) ///
			 (m_public		,aseq("Public Finance")) ///
			 (m_macro		,aseq("Macro")) ///
			 (m_macro		,aseq("Labor")) ///
			  (m_nonexpert	,aseq("Out of field")) ///
	         (m_expert		,aseq("In field")) ///
			 (m_theory		,aseq("Theory")) ///
			 (m_evidence	,aseq("Empirical")) ///
			 (m_neither		,aseq("Normative")) ///
			 ,keep(i_male)    swapnames   ///
			$gs ///
			xtitle("Male - female difference ")		///
			headings( "Question 1-24"= "{bf:A. By question nr.           }" ///
			"Development" = "{bf:B. By field                        }" ///
			"Out of field"= "{bf:C. By expertise                }" ///
			"Theory"= "{bf:D. By statement type      }"  ///
			,angle(0)) /// 
			yscale(titlegap(-5)) legend(order(3 "Coefficient" 1 "95%" 2 "90%" ) rows(1) position(12))

			
// Save chart
	graph export "output\figure2.png",replace width(2000)
	

	
// Save table
esttab using "output\Table_S2.rtf",  ///
       b(%4.3f)  star(* 0.1 ** 0.05 *** 0.01) label  replace   nogaps  se	    rtf   
	
	
