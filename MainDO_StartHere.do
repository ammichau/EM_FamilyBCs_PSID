*MainDO_StartHere.do
*-------------------v.11-14-2018; @A. Michaud for AddedWorker w/ K.Ellieroth---------------------------------*
*v.11-23-18: adding more experience variables. We will probably have to start from 1974
*v.11-14-18: add occs and inds
*v.10-25-2018: check HH links
*OG: 6-5-2017
clear all
set more off

*Be sure there is a directory "AddedWorker" with subdirectories CPS and PSID
cd "C:\Users\amichau9\Dropbox\DemogBCtrends\Data"

global PSID_dir "C:\Users\amichau9\Dropbox\DemogBCtrends\Data"
global CPS_dir "C:\Users\amichau9\Dropbox\DemogBCtrends\Data"
global figOUT_dir "Figures"
global tabOUT_dir "Tables"
global InputDTAs_dir "InputDTAs"

***************************************************************************************************************
* As the name would suggest, this is the main shell file that executes all of the data analysis
* The main outputs relate to:
*	-Returns to experience by education over time 
*-------------------------------------------------------------------------------------------------
* Requirements:
* +Do-files called:
*	SET UP DO'S
*		-OccHist.do
*		-DemographicVars.do
*		-jobloss.do
*	COMPUTATION AND OUTPUT DO'S
*		-tba
* +Datasets used:
*		-occ1970_occ1990dd.dta; David Dorn's crosswalk from 1970 to 1990 codes.
*		-occ2000_occ1990dd.dta; David Dorn's crosswalk from 2000 to 1990 codes.
*
*									++++++++IMPORTANT++++++++		
* +PSIDUSE MUST BE INSTALLED AND SET UP!
*	-All of the set-up .do files use psiduse
*	-I have specified the sub-folder "Mdta" as having all of the raw data files.
*	-These files are huge, so we're leaving it to the user to fetch and install them properly. 
*	-O/w the user may download variables directly from PSID. The variable codes are clearly listed in the set-up do-files.
*-------------------------------------------------------------------------------------------------	

***************************************************************************************************************
*Section 1: Set up
************
*Set-up	
	*These do-files clean and create needed variables. See files for details
		*do $PSID_dir\OccHist
		*do $PSID_dir\DemographicVars
		*do $PSID_dir\jobloss
	*Merge completed .dta's from above .do files
		use $InputDTAs_dir\occhist.dta, clear
		merge m:m x11101ll wave using $InputDTAs_dir\jobloss.dta
		drop _merge
		merge m:m x11101ll wave using $InputDTAs_dir\Demographics.dta
		drop _merge
		save $InputDTAs_dir\alldata1.dta, replace
		
		*duplicates list x11101ll wave
		
*SEO sample- these guys have wpts==0
	gen SEO=(x11102<7000)
	gen Latino=(x11102>4999 & x11102<7001)
	
*Clean up
	drop HSelfE HnyrsFT WnyrsFT HnyrsEmp WnyrsEmp hHrsYr wHrsYr ExpWkr
	
*************************************************************************************************
*------------------------------------------------------------------------------------------------
*Coding Chunk 1a: Experience variables
* Retro available avter 1974
*------------------------------------------------------------------------------------------------	
*Years Full-time or any
xtset x11101ll wave
replace YrsFT = . if (Age<YrsFT-17 & YrsFT~=.)
replace YrsEmp = . if (Age<YrsEmp-17 & YrsEmp~=.)
	forvalues y = 1998(2)2014 {
		replace YrsFT= L.YrsFT + 1 if (FTemp==1 & wave==`y')
		replace YrsEmp= L.YrsEmp + 1 if ((FTemp==1 | PTemp==1) & wave==`y')
	}
	

*------------------------------------------------------------------------------------------------
*Coding Chunk 1b: Occupational history risk
*------------------------------------------------------------------------------------------------	
	*Find longest held occupation & industry
	by x11101ll, sort: egen Occ2 = mode(occ), maxmode

	*Calculate number of years held
		*72.5/74.2% HH/HW of observations of "current occ" are equal to longest held occupation
		*	Number increases to 75/76.5% for those over 50
		*27% of the movements are to manager or professional, kind of consistent w/ career ladder.
		*	That's why I use "max" to break ties-- lower numbers are more managerial
		* 16/10.5 yrs average tenure for those over 50; 15/8 mode if in sameocc
		* 15/19 yrs in longest occ, unconditional on current state.
			gen d=1 if occ==Occ2
			replace d=0 if occ~=Occ2
			gen d2 = Tnre if occ==Occ2
	
	by x11101ll, sort: egen yrslifeOcc = sum(d)
	by x11101ll, sort: egen TnrelifeOcc = max(d2)
	gen lifeoccI=((yrslifeOcc>9 | TnrelifeOcc> 9)) 			
	gen LifeOcc=Occ2 if (lifeoccI==1)
	
	gen sameocc= 1 if LifeOcc==occ
	replace sameocc= 0  if LifeOcc~=occ & LifeOcc~=. & occ~=.
	drop d d2
	
	*Repeat for Industry
		*74/76% HH/HW of observations of "current ind" are equal to longest industry
		*	74/78%  for those over 50
		* 16/11 yrs average tenure for those over 50; 16/9 mode if in sameocc
		* 15/19 yrs in longest ind, unconditional on current state.
		by x11101ll, sort: egen ind2 = mode(ind), maxmode
			gen d=1 if ind==ind2
				replace d=0 if ind~=ind2
			gen d2 = Tnre if ind==ind2
	
	by x11101ll, sort: egen yrslifeInd = sum(d)
	by x11101ll, sort: egen TnrelifeInd = max(d2)
	gen lifeindI=((yrslifeInd>9 | TnrelifeInd> 9)) 			
	gen Lifeind=ind2 if (lifeindI==1)
	
	gen sameind= 1 if Lifeind==ind
	replace sameind= 0  if Lifeind~=ind & Lifeind~=. & ind~=.	
	drop  d d2
*************************************************************************************************
*Coding Chunk 2: Age, education catagorical dummies
*------------------------------------------------------------------------------------------------	
*-------------------------------------------------------------------------------------------------	
*Use later to merge Aggregate Data	
		gen ageD1=(Age>17 & Age<26)
		gen ageD2=(Age>25 & Age<40)
		gen ageD3=(Age>39 & Age<55)
		gen ageD4=(Age>54 & Age<65)
		gen old=(Age>64)
	*Next, education levels
		gen noCol= 1 if (HS==1 | lsHS==1)
		replace noCol= 0 if EdBin==3
		gen Educ1=(noCol==1)
		gen Educ2=(Col==1)
	
	gen AgeBin=.
	gen AgeEdBin=.
	*Bins will be the cross products
		forvalues a =1/4{
		replace AgeBin=`a' if ageD`a'==1
			forvalues e=1/2 {
			local aa= `a'*10
				replace AgeEdBin=`aa'+`e' if (ageD`a'==1 & Educ`e'==1)
		}
		}
		
		
drop   Occ2 ind2 EdBin sameocc sameind Rural Urban City Educ1 Educ2
		
save $InputDTAs_dir\calibdata.dta, replace

*************************************************************************************************	
*-------------------------------------------------------------------------------------------------
* Coding Chunk 3: Link everything to the Woman/Wife
*-------------------------------------------------------------------------------------------------	
*do $PSID_dir\HealthTrans.do
*-------------------------------------------------------------------------------------------------	

