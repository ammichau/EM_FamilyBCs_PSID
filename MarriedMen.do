*MarriedMen.do
*-------------------v.12-4-2018; @A. Michaud for AddedWorker w/ K.Ellieroth---------------------------------*

***************************************************************************************************************
* This code creates caclulates the following statistics for husbands (reference is wife):
*	-State transition dynamics between:
*		- 0: Never married
*		- 1: married and employed
*		- 2: involuntary unemployment
*		- 3: recover from involuntary u
*		- 4: single (divorced/widowed, includes extra income still)
*	-Wages:
*		- Lifecycle profile
*		- Individual Fixed Effect (will draw from dist. correlated w/ wife)
*		- Persistant AR(1) component
*		-Wage impact of job loss with exponential decay
*	-Age groups: 25-39; 40-54; 55-65
* Striate all by HS & Less vs some college +
*-------------------------------------------------------------------------------------------------
* Requirements:
*	-calibdata.dta; created by MainCalib_StartHere.do
***************************************************************************************************************

   use $InputDTAs_dir\calibdata, clear
   
 *Not needed or redundant:
	drop Emp Female wEduc educ EdBin2 prob
	
 *-------------------------------------------------------------  
 *Household variables 
 
 	foreach var of varlist x11102 SEO Latino { 			
			rename `var' hh_`var'
		}	
 
   *Figure out who the real head is
		gen hh_Spouse = 1 if ((relhd==20 |  relhd==2 ) & xsqnr==2)
		replace hh_Spouse = 0  if hh_Spouse~=1

		gen hh_Cohb = 1 if (relhd==22  & xsqnr==2)
			replace hh_Cohb = 0  if hh_Cohb~=1
			
    gen hh_MPair=(MPair>0 & MPair<5)
	
	drop MPair
	
 *-------------------------------------------------------------  
 *Individual
 
 	rename married mar2
	gen married=(mar2==1 | hh_MPair==1)
	drop mar2
	
	xtset x11101ll wave
	foreach var of varlist x11101ll MPairNum HH hh_Spouse hh_Cohb relhd Sex { 			
	forvalues y = 1998(2)2014 {
			replace `var' = L.`var' if (`var'==. & wave==`y')
			}
			}	
	
	foreach var of varlist x11101ll Sameocc-ind xsqnr-nChild DeathYr lsHS-widow dead yrslifeOcc-AgeEdBin married{ 			
			gen w_`var' = `var' if ((hh_Spouse==1 | hh_Cohb==1 | HH==1 | relhd==10) & Sex==2)	
			gen h_`var' = `var' if (Sex==1 & (HH==1 | relhd==10))
			drop `var'
			}

gen Female=(Sex==2)
gen Male=(Sex==1)


			
drop if (HH~=1 & HW~=1)		
drop HH HW relhd
drop Sex
					
collapse (firstnm) hh_x11102 hh_SEO-Male, by(MPairNum wave)			

save $InputDTAs_dir\MarriedData.dta, replace


*-------------------------------------------------------------------------------------------------
* Transitions and stationary distributions:
*	-Although, we will likely use stationary dist. from CPS
***************************************************************************************************************

***************************************************************************************************************
* Construct vector for transistion matrix:
*		- 0: Never married
*		- 1: married and employed
*		- 2: involuntary unemployment
*		- 3: recover from involuntary u (need to set average duration of wage scar/ higher u probability)
*		- 4: single (divorced/widowed/disabled, includes extra income still)
***************************************************************************************************************

forvalues c=0/1 {
cd $HOME_dir
use $InputDTAs_dir\MarriedData.dta, clear

drop if (wave>1997 | wave<1974)
drop if w_x11101ll==.
xtset w_x11101ll wave

	local cc=`c'
    cd $HOME_dir/$tabOUT_dir/Col_`cc'
	
	drop if w_Col~=`c'
	
*Check out with just inv U
	gen h_invU=(h_AnyU==1 & h_Quit~=1)
	gen h_FinvU = F.h_invU
*Create short histories
	gen h_irecvr6=((L.h_invU==1 | L2.h_invU | L3.h_invU==1 | L4.h_invU | L5.h_invU | L6.h_invU) & h_CurEmp==1)
	gen h_irecvr5=((L.h_invU==1 | L2.h_invU | L3.h_invU==1 | L4.h_invU | L5.h_invU) & h_CurEmp==1)
	gen h_irecvr4=((L.h_invU==1 | L2.h_invU | L3.h_invU==1 | L4.h_invU ) & h_CurEmp==1)
	gen h_irecvr3=((L.h_invU==1 | L2.h_invU | L3.h_invU==1 ) & h_CurEmp==1)
	gen h_irecvr2=((L.h_invU==1 | L2.h_invU ) & h_CurEmp==1)
	gen h_irecvr1=((L.h_invU==1 ) & h_CurEmp==1)

*Create State vector
	*gen h_state = 0 if w_nevermarried==1 (too few of these)	
		gen h_state = 1 if w_married==1 & h_CurEmp==1 & h_irecvr5==0
		replace h_state = 3 if w_married==1 & h_CurEmp==1 & h_irecvr5==1
		replace h_state = 2 if w_married==1 & h_AnyU==1
		replace h_state = 4 if (w_widow==1 | w_divorced==1 | h_CurDisable==1)

* 1) Transition matrix, by age
	gen h_Fstate = F.h_state
	
svyset w_x11101ll [pw=w_wpts]	
	estpost svy: tab h_state h_Fstate if (w_ageD1==1), row
		esttab  using "Age1_Hmat.csv", b(4) nostar not noobs unstack mtitle(`e(colvar)') plain replace
	estpost svy: tab h_state h_Fstate if (w_ageD2==1), row
		esttab  using "Age2_Hmat.csv", b(4) nostar not noobs unstack mtitle(`e(colvar)') plain replace
	estpost svy: tab h_state h_Fstate if (w_ageD3==1), row
		esttab  using "Age3_Hmat.csv", b(4) nostar not noobs unstack mtitle(`e(colvar)') plain replace
	estpost svy: tab h_state h_Fstate if (w_ageD4==1), row
		esttab  using "Age4_Hmat.csv", b(4) nostar not noobs unstack mtitle(`e(colvar)') plain replace
		
* 2) U probability in the 5 years following inv U, by age

	forvalues a=1/4 {
		forvalues d= 1/6 {
		svy: mean h_FinvU if w_ageD`a'==1 & h_irecvr`d'==1		
		mat hz = e(b) 
		putexcel set "InvUHaz_age`a'.xls", sheet(InvUHaz) modify
		putexcel A`d' = `d', nformat(number_d2)
		putexcel B`d' = matrix(hz), nformat(number_d2) 
	}		
	}

* 3) Stationary dist
svyset w_x11101ll [pw=w_wpts]
	
*husband's state (but will really be using CPS)
drop h_state
	gen h_state = 0 if w_nevermarried==1
		replace h_state = 1 if w_married==1 & h_CurEmp==1 
		replace h_state = 2 if w_married==1 & h_AnyU==1
		replace h_state = 3 if (w_widow==1 | w_divorced==1 | h_CurDisable==1)
	
putexcel set "HstateDist", modify
	putexcel A1 = ("Age group") B1 = ("nevermarried") C1 = ("employed") D1 = ("invU") E1 = ("divorce/widow/disable") ///
	A2= ("Age>17 & Age<26") A3 = ("Age>25 & Age<40") A4 = ("Age>39 & Age<55") A5 = ("Age>54 & Age<65") 

forvalues a=1/4 {
	local aa = `a'+1	
		svy: tabulate h_state  if (w_ageD`a'==1), format(%11.3g) percent	
		matrix b = e(b)	
		putexcel B`aa' = matrix(b) 	
}	
	
*Age
putexcel set "HWageDist", modify
	putexcel B1 = ("Husband Age") B2 = ("Age>17 & Age<26") C2 = ("Age>25 & Age<40") D2 = ("Age>39 & Age<55") E2 = ("Age>54 & Age<65") ///
	A1= ("Wife Age") A3=("Age>17 & Age<26") A4 = ("Age>25 & Age<40") A5 = ("Age>39 & Age<55") A6 = ("Age>54 & Age<65") 
forvalues a=1/4 {
	local aa = `a'+2		
		svy: tabulate h_AgeBin if w_AgeBin==`a', format(%11.3g) percent	
		matrix b = e(b)	
		putexcel B`aa' = matrix(b) 	
	}
	
}	



*-------------------------------------------------------------------------------------------------
***************************************************************************************************************
* Wage process estimation
*		- Life-cycle profile by WIFE age: w_ageD
*		- Individual fixed effect: h_alpha; save for joint distribution w/ wife
*		- wage scar: for 10 years after; will fit decay later
*		- Save residual and estimate AR(1)
*		- Mean college/non-college levels
***************************************************************************************************************

forvalues c=0/1 {

cd $HOME_dir
use $InputDTAs_dir\MarriedData.dta, clear

drop if (wave>1997 | wave<1974)
drop if w_x11101ll==.
xtset w_x11101ll wave

	local cc=`c'
    cd $HOME_dir/$tabOUT_dir/Col_`cc'
	
	drop if w_Col~=`c'

gen h_invU_L0=(h_AnyU==1 & h_Quit~=1)

forvalues el=1/5 {
	gen h_invU_L`el'=(L`el'.h_AnyU==1 & L`el'.h_Quit~=1)
}

gen ln_hLabInc = ln(h_LabInc)

*Main regression
xtreg  ln_hLabInc w_ageD2 w_ageD3 w_ageD4 h_invU_L*, fe
	putexcel set "h_LabIncCoef.xls", sheet("regress results")
	predict h_LabIncFE, u
	predict h_LabIncEPS, residual

*FE distribution
putexcel set "h_LabIncFE", modify
	putexcel A2 = ("mean") A3 = ("stdev") A4 = ("skew") A5 = ("kurtosis")
	sum h_LabIncFE, det
		scalar b1 = r(mean)
		scalar b2 = r(Var)
		scalar b3 = r(skewness)
		scalar b4 = r(kurtosis)
	forvalues b=1/4 {		
		local bb = `b'+1
		putexcel B`bb' = matrix(b`b') 	
	}

*Z process
	reg h_LabIncEPS L.h_LabIncEPS
		mat b1 = e(b) 
		scalar rho = b[1,1] 
	predict h_LabIncAReps, residual
		sum h_LabIncAReps, det
		scalar b2 = r(Var)
putexcel set "h_LabIncZ", modify
	putexcel A2 = ("rho") A3 = ("stdev of eps") 
	putexcel B2 = matrix(rho) 
	putexcel B3 = matrix(b2)
	
}















   
