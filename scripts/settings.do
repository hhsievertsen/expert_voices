// settings
set matsize 5000


// set working directory
cd "C:\Users\B059633\Dropbox\Work\Research\Projects\Gender Econ\submissions\PUS\Final edits for PUS\Replication Package" 

// schemes

*ssc install blindschemes
set scheme plotplain

// globals
gl controls "i_cites_all i_hi_all  i_US_sample i_American i_European j_expert"
gl controls1 "i_hi_all i_US_sample i_American i_European j_expert"  
gl absorb   "q_Question i_inst i_phdyear"
gl absorb1  "i_inst i_phdyear"


// Functions
			
* net install grc1leg,from( http://www.stata.com/users/vwiggins/)
 *net install grc1leg2.pkg, from (http://digital.cgdev.org/doc/stata/MO/Misc/)
	