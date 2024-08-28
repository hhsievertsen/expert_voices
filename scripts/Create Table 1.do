// Table 1: Summary Stats for the IGM panel


// Load settings
do "C:\Users\B059633\Dropbox\Work\Research\Projects\Gender Econ\submissions\PUS\Final edits for PUS\Replication Package\scripts\settings.do"
// Load data 
u "data/igm_data.dta",clear

*ssc install ietoolkit
// Panel A

iebaltab  i_US_sample i_age   i_American i_European ///
	i_us_based i_top5inst   i_American ///
		i_European i_us_based i_top5inst ///
		i_cites_all fnumber i_dev i_fin i_io ///
		i_inter i_lab  i_mac i_pub  ///
		if i_count==1, grpvar(i_female)  ///
	save("output\Table_1_panel_A.xlsx") replace pt starsnoadd 

	
// Panel B
	* prepare variables
	replace j_didnotanswer=inlist(j_response,1,2,4)
	replace j_no_opinion=inlist(j_response,6)
	replace j_strdisagree=inlist(j_response,8)
	replace j_uncertain=inlist(j_response,9)
	replace j_disagree=inlist(j_response,5)
	replace j_agree=inlist(j_response,3)
	replace j_stragree=inlist(j_response,7)
	replace j_anycomment=0 if j_didnotanswer==1
	replace j_anycomment=0 if j_no_opinion==1
iebaltab  j_expert j_didnotanswer j_no_opinion ///
		j_strdisagree  j_disagree j_uncertain ///
		j_agree j_stragree j_Confidence ///
		j_anycomment   ///
			, grpvar(i_female)  ///
	save("output\Table_1_panel_B.xlsx") replace pt starsnoadd 


// Panel C
	
	log using "output\Table_1_panel_C.rtf", replace text
	sum q_theory q_evidence q_neither q_dev q_fin q_io q_inter q_lab q_mac q_pub  if q_count==1
	log close

