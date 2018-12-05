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



***************************************************************************************************************
* Construct vector for transistion matrix:
*		- 0: Never married
*		- 1: married and employed
*		- 2: involuntary unemployment
*		- 3: recover from involuntary u (need to set average duration of wage scar/ higher u probability)
*		- 4: single (divorced/widowed/disabled, includes extra income still)
***************************************************************************************************************

drop if w_x11101ll==.
xtset w_x11101ll wave

*Check out with all U- not good
{
/*
gen h_displ=(h_AnyU==1 & L.h_AnyU==0)
gen h_Fdispl = F.h_displ
gen h_recvr5=((L.h_AnyU==1 | L2.h_AnyU | L3.h_AnyU==1 | L4.h_AnyU | L5.h_AnyU) & h_AnyU==0)
gen h_recvr4=((L.h_AnyU==1 | L2.h_AnyU | L3.h_AnyU==1 | L4.h_AnyU ) & h_AnyU==0)
gen h_recvr3=((L.h_AnyU==1 | L2.h_AnyU | L3.h_AnyU==1 ) & h_AnyU==0)
gen h_recvr2=((L.h_AnyU==1 | L2.h_AnyU ) & h_AnyU==0)
gen h_recvr1=((L.h_AnyU==1 ) & h_AnyU==0)
*/
}


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

gen h_state = 0 if w_nevermarried==1
	replace h_state = 1 if w_married==1 & h_CurEmp==1 & h_irecvr5==0
	replace h_state = 2 if w_married==1 & h_AnyU==1
	replace h_state = 3 if w_married==1 & h_CurEmp==1 & h_irecvr5==1
	replace h_state = 4 if (w_widow==1 | w_divorced==1 | h_CurDisable==1)

*Transition matrix, by age
	gen h_Fstate = F.h_state
	
	svyset [pweight=w_wpts]
	estpost svy: tab h_state h_Fstate if (w_ageD1==1), row
		esttab  using $tabOUT_dir\Age1_Hmat.csv, b(4) nostar unstack mtitle(`e(colvar)') plain replace
	estpost svy: tab h_state h_Fstate if (w_ageD2==1), row
		esttab  using $tabOUT_dir\Age2_Hmat.csv, b(4) nostar unstack mtitle(`e(colvar)') plain replace
	estpost svy: tab h_state h_Fstate if (w_ageD3==1), row
		esttab  using $tabOUT_dir\Age3_Hmat.csv, b(4) nostar unstack mtitle(`e(colvar)') plain replace
	estpost svy: tab h_state h_Fstate if (w_ageD4==1), row
		esttab  using $tabOUT_dir\Age4_Hmat.csv, b(4) nostar unstack mtitle(`e(colvar)') plain replace
		
*U probability in the 5 years following inv U, by age

			

*3) Stationary dist
svyset x11101ll [pw=wpts]
	
putexcel set $OUT_dir\Hdist4DW, modify
	putexcel A1 = ("Age group") B1 = ("0") C1 = ("moderate") D1 = ("severe")  ///
	A2= ("Age>29 & Age<46") A3 = ("Age>45 & Age<56") A4 = ("Age>55 & Age<61") A5 = ("Age>60 & Age<66") 
 	
	svy: tabulate WlimitLP  if (Age>29 & Age<46 & WlimitLP<3), format(%11.3g) percent	
	matrix b = e(b)	
	putexcel B2 = matrix(b) 	
	
	svy: tabulate WlimitLP  if (ageD2==1 & WlimitLP<3), format(%11.3g) percent	
	matrix b = e(b)	
	putexcel B3 = matrix(b) 	
	
	svy: tabulate WlimitLP  if (ageD3==1 & WlimitLP<3), format(%11.3g) percent	
	matrix b = e(b)	
	putexcel B4 = matrix(b) 	
	
	svy: tabulate WlimitLP  if (ageD4==1 & WlimitLP<3), format(%11.3g) percent	
	matrix b = e(b)	
	putexcel B5 = matrix(b) 		

****************************************************************************************************
** NOT IN USE ** NOT IN USE ** NOT IN USE ** NOT IN USE ** NOT IN USE ** NOT IN USE ** NOT IN USE **	
****************************************************************************************************
*-------------------------------------------------------------------------------------------------
* Coding Chunk: Markov transitions
*	These are the raw markov transitions for each age group. They do not include the effect of occupation
*-------------------------------------------------------------------------------------------------	
*Short detour to calc summary statistics of the transistion matrix
*svyset [pweight=wpts]
*estpost svy: tab lWlim WlimitLPvAM if (Age>21 & Age<46 & lWlim~=3), row
*	esttab  using "Age1_Hmat.csv", b(4) nostar unstack mtitle(`e(colvar)') plain replace
*estpost svy: tab lWlim WlimitLPvAM if (Age>45 & Age<56 & lWlim~=3), row
*	esttab  using "Age2_Hmat.csv", b(4) nostar unstack mtitle(`e(colvar)') plain replace
*estpost svy: tab lWlim WlimitLPvAM if (Age>55 & Age<61 & lWlim~=3), row
*	esttab  using "Age3_Hmat.csv", b(4) nostar unstack mtitle(`e(colvar)') plain replace
*estpost svy: tab lWlim WlimitLPvAM if (Age>60 & Age<66 & lWlim~=3), row
*	esttab  using "Age4_Hmat.csv", b(4) nostar unstack mtitle(`e(colvar)') plain replace
*estpost svy: tab lWlim dead if (Age>65 & lWlim~=3), row
*	esttab  using "Old_Deathmat.csv", b(4) nostar unstack mtitle(`e(colvar)') plain replace
	
*svy: mean Yrs2Death  if Age==65 & WlimitLPvAM==1 & Yrs2Death<50
*svy: mean Yrs2Death  if Age==65 & WlimitLPvAM==2 & Yrs2Death<50
*svy: mean Yrs2Death  if Age==65 & WlimitLPvAM==0 & Yrs2Death<50

*************************************************************************************************	






   
