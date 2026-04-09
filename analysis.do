******************************************************************
***   PPS 3200 - Table 1: Descriptive Statistics
***   Dataset: ACS
***   Programmer: Chenaniah Watkins                                              
******************************************************************
** Regression
logit enrolled blackyoungmale i.inc_cat i.empstatus i.region4 i.metrobin, or
outreg2 using "Regression_Table_Watkins.xlsx", replace
excel or bdec(3) pdec(3) rdec(3) ctitle(Logistic)
** Load the ACS Dataset and set the survey weights
*Code:
cd "C:\Users\watkincs\Desktop\Watkins PPS 3200"
use "C:\Users\watkincs\Desktop\Watkins PPS 3200\acs_2023.dta", clear
svyset statefip [pweight = perwt], strata(strata)

** Black or African American Males Age 18-25 years old
*Code:
gen blackyoungmale =. 
replace blackyoungmale = 1 if (sex==1) & (age >= 18 & age <= 25) & (race == 2)
replace blackyoungmale = 0 if (sex==2) & (age >= 18 & age <= 25) & (race == 2)

** Compare Black women and Black men in same age group
cd "C:\Users\watkincs\Desktop\Watkins PPS 3200"
foreach var in enrolled educ3 inc_cat region4 metrobin employed empstatus {
    tabout `var' blackyoungmale using "Men_vs_Women_Black18_25.xls", svy cell(col se) stats(chi2) nlab(count) f(3) sebnone append
}

** "College" Enrollement. Enrolled, Yes or No?
*Code:
gen enrolled =.
replace enrolled = 1 if school == 2
replace enrolled = 0 if school == 1
label define yesno 0 "Not enrolled" 1 "Enrolled"
label values enrolled yesno
label variable enrolled "Currently enrolled"

** Educational Attainment Categories
*Code:
gen educ3 =. 
replace educ3 = 1 if educ==7  
replace educ3 = 2 if educ==8 | educ==9  
replace educ3 = 3 if educ==10 | educ==11  
label define educ3lbl 1 "HS Graduate" 2 "Some College (incl. Associate/Technical)" 3 "College Graduate" 
label values educ3 educ3lbl 
label variable educ3 "Educational Attainment (3 categories)"

** Region variable
*Code:
gen region4 =.
replace region4 = 1 if region==11 | region==12
replace region4 = 2 if region==21 | region==22
replace region4 = 3 if region==31 | region==32 | region==33
replace region4 = 4 if region==41 | region==42
label variable region4 "Census Region (4 categories)"
label define region4lbl 1 "Northeast" 2 "Midwest" 3 "South" 4 "West"
label values region4 region4lbl

** Metropolitan Area. Yes or No?
*Code:
gen metrobin =.
replace metrobin = 1 if metro==1
replace metrobin = 0 if metro==0 | metro==2
label define metrolbl 0 "Non-metropolitan area" 1 "Metropolitan area"
label values metrobin metrolbl
label var metrobin "Metropolitan Area"

** Household Income
*Code:
gen inc_cat =.
replace inc_cat = 1 if hhincome < 25000
replace inc_cat = 2 if hhincome >= 25000 & hhincome < 50000
replace inc_cat = 3 if hhincome >= 50000 & hhincome < 100000
replace inc_cat = 4 if hhincome >= 100000
label define inc_lbl 1 "Under $25,000" 2 "$25,000-49,999" 3 "$50,000-99,999" 4 "$100,000+"
label values inc_cat inc_lbl
label var inc_cat "Household income (categories)"
svy: tab inc_cat enrolled, col

** Employment Status
*Code:
gen employed =.
replace employed = 1 if empstat==1
replace employed = 0 if empstat==2 | empstat==3
label define employedlbl 0 "Not employed" 1 "Employed"
label values employed employedlbl 
label var employed "Employment status"

* Hours worked
codebook uhrswork
gen empstatus =.
replace empstatus = 0 if uhrswork==0 | uhrswork==.
replace empstatus = 1 if uhrswork > 0 & uhrswork < 35
replace empstatus = 2 if uhrswork >= 35
label define empstatus_lbl 0 "Not employed" 1 "Part-time" 2 "Full-time"
label values empstatus empstatus_lbl
label var empstatus "Employment Status based on hours worked per week"

**Table Overall Descriptive Stats
*Code:
cd "C:\Users\watkincs\Desktop\Watkins PPS 3200"
foreach var in educ3 inc_cat region4 metrobin empstatus employed {
        tabout `var' enrolled using "Descriptive_Stats_Table2_Watkins_PPS3200.xls", svy cell(col se) stats(chi2) nlab(count) f(3) sebnone append 
} 
