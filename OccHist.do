*OccHist.do
*-------------------v.5-1-2017; @A. Michaud for AddedWorker w/ K.Ellieroth---------------------------------*
cd $PSID_dir
***************************************************************************************************************
* This code reads in and cleans occupation variables from PSID
*-------------------------------------------------------------------------------------------------
* Requirements:
*	-You have to have files set up for psiduse in folder "Mdta", a subdirectory of PSID_dir set in main file
*	-"occ1970_occ1990dd.dta"; David Dorn's crosswalk from 1970 to 1990 codes.
*	-This has to be done in two steps since the codes change
***************************************************************************************************************

clear all
set more off
ssc install psidtools
*help psid
*psid install using Mdta
*psid install 1968(1)1992 using Mdta


psid use || HretroOcc [68]V197_A [69]V640_A [70]V1279_A [71]V1984_A [72]V2582_A [73]V3115_A [74]V3530_A [75]V3968_A [76]V4459_A [77]V5374_A [78]V5873_A [79]V6497_A [80]V7100_A ///
		 || WretroOcc [68]V243_A [69]V609_A [70]V1367_A [71]V2074_A [72]V2672_A [73]V3183_A [74]V3601_A [75]V4055_A [76]V4605_A [77]V5507_A [78]V6039_A [79]V6596_A [80]V7198_A ///
		 || HretroInd [68]V197_B [69]V640_B [70]V1279_B [71]V1985_A [72]V2583_A [73]V3116_A [74]V3531_A [75]V3969_A [76]V4460_A [77]V5375_A [78]V5874_A [79]V6498_A [80]V7101_A ///
		 || WretroInd [68]V243_B [69]V609_B [70]V1367_B [71]V2075_A [72]V2673_A [73]V3184_A [74]V3602_A [75]V4056_A [76]V4606_A [77]V5508_A [78]V6040_A [79]V6597_A [80]V7199_A ///
		 || HoccCur   [81]V7712 [82]V8380 [83]V9011 [84]V10460 [85]V11651 [86]V13054 [87]V14154 [88]V15162 [89]V16663 [90]V18101 [91]V19401 [92]V20701 [93]V22456 [94]ER4017 [95]ER6857 ///
					  [96]ER9108 [97]ER12085 [99]ER13215 [01]ER17226 ///
		 || WoccCur   [81]V7885 [82]V8544 [83]V9194 [84]V10678 [85]V12014 [86]V13233 [87]V14329 [88]V15464 [89]V16982 [90]V18403 [91]V19703 [92]V21003 [93]V22809 [94]ER4048 [95]ER6888 ///
					  [96]ER9139 [97]ER12116 [99]ER13727 [01]ER17796 ///
		 || HIndCur   [81]V7713 [82]V8381 [83]V9012 [84]V10461 [85]V11652 [86]V13055 [87]V14155 [88]V15163 [89]V16664 [90]V18102 [91]V19402 [92]V20702 [93]V22457 [94]ER4018 [95]ER6858 [96]ER9109 [97]ER12086 [99]ER13216 [01]ER17227 ///
		 || WIndCur   [81]V7886 [82]V8545 [83]V9195 [84]V10679 [85]V12015 [86]V13234 [87]V14330 [88]V15465 [89]V16983 [90]V18404 [91]V19704 [92]V21004 [93]V22810 [94]ER4049 [95]ER6889 [96]ER9140 [97]ER12117 [99]ER13728 [01]ER17797 ///					   
		 || hTenure   [68]V200 [76]V4480 [77]V5384 [78]V5941 [81]V7711 [82]V8379 [83]V9010 [84]V10519 [85]V11668 [86]V13068 [87]V14166 [88]V15181 [89]V16682 [90]V18120 [91]V19420 [92]V20720 [93]V22489 ///
		 || hTenurem  [94]ER2099 [95]ER5098 [96]ER7194 [97]ER10118 [99]ER13244 [01]ER17255 [03]ER21172 [05]ER25161 [07]ER36166 [09]ER42201 [11]ER47514 [13]ER53214  ///
		 || hTenurey  [94]ER2098 [95]ER5097 [96]ER7193 [97]ER10117 [99]ER13243 [01]ER17254 [03]ER21171 [05]ER25160 [07]ER36165 [09]ER42200 [11]ER47513 [13]ER53213  ///
		 || wTenure   [76]V4863 [78]V6057 [81]V7884 [82]V8543 [83]V9193 [84]V10733 [85]V12031 [86]V13245 [87]V14339 [88]V15483 [89]V17001 [90]V18422 [91]V19722 [92]V21022 [93]V22842  ///
		 || wTenurem  [94]ER2593 [95]ER5592 [96]ER7688 [97]ER10600 [99]ER13756 [01]ER17825 [03]ER21422 [05]ER25419 [07]ER36424 [09]ER42453 [11]ER47771 [13]ER53477  ///
		 || wTenurey  [94]ER2592 [95]ER5591 [96]ER7687 [97]ER10599 [99]ER13755 [01]ER17824 [03]ER21421 [05]ER25418 [07]ER36423 [09]ER42452 [11]ER47770 [13]ER53476  ///
		 || Sameocc   [70]V1460 [71]V2172 [72]V2798 [73]V3224 [74]V3646 [75]V4121 [76]V4665 [77]V5585 [78]V6134 [79]V6731 [80]V7364 [81]V8016 ///
					  [82]V8640 [83]V9326 [84]V10973 [85]V11913 [86]V13540 [87]V14587 [88]V16061 [89]V17458 [90]V18789 [91]V20089 [92]V21395 ///
					  [93]V23252 [94]ER3918 [95]ER6788 [96]ER9034 [97]ER11899 [99]ER15983 [01]ER20044 [03]ER23480 [05]ER27448 ///	
		 || WSameocc  [76]V4994 [85]V12268 ///	
		 || hXtraJob  [68]V227 [69]V660 [70]V1298 [71]V2004 [72]V2602 [73]V3135 [74]V3550 [75]V4005 [76]V4518 [77]V5428 [78]V5915 [79]V6526 [80]V7129 [81]V7744 [82]V8406 [83]V9037 [84]V10564 [85]V11708 [86]V13108 [87]V14206 ///
					  [88]V15260 [89]V16761 [90]V18199 [91]V19499 [92]V20799 [93]V22580 [94]ER2228 [95]ER5227 [96]ER7323 [97]ER10235 [99]ER13366 [01]ER17398 ///
		 || wXtraJob  [76]V4901 [79]V6618 [80]V7220 [81]V7907 [82]V8565 [83]V9215 [84]V10778 [85]V12071 [86]V13285 [87]V14379 [88]V15562 [89]V17080 [90]V18501 [91]V19801 [92]V21101 [93]V22933 [94]ER2722 [95]ER5721 [96]ER7817 ///
					  [97]ER10717 [99]ER13878 [01]ER17968 ///
		 || HoccCurJ1_ [03]ER21145 [05]ER25127 [07]ER36132 [09]ER42167 [11]ER47479 [13]ER53179 [15]ER60194 ///
		 || HoccCurJ2_ [03]ER21201 [05]ER25190 [07]ER36195 [09]ER42228 [11]ER47541 [13]ER53241 [15]ER60256 ///
		 || HoccCurJ3_ [03]ER21233 [05]ER25222 [07]ER36227 [09]ER42258 [11]ER47571 [13]ER53271 [15]ER60286 ///
		 || WoccCurJ1_ [03]ER21395 [05]ER25385 [07]ER36390 [09]ER42419 [11]ER47736 [13]ER53442 [15]ER60457 ///
		 || WoccCurJ2_ [03]ER21451 [05]ER25448 [07]ER36453 [09]ER42480 [11]ER47798 [13]ER53504 [15]ER60519 ///
		 || WoccCurJ3_ [03]ER21483 [05]ER25480 [07]ER36485 [09]ER42510 [11]ER47828 [13]ER53534 [15]ER60549 ///
		 || HindCurJ1_ [03]ER21146 [05]ER25128 [07]ER36133 [09]ER42168 [11]ER47480 [13]ER53180 [15]ER60195 ///
		 || HindCurJ2_ [03]ER21202 [05]ER25191 [07]ER36196 [09]ER42229 [11]ER47542 [13]ER53242 [15]ER60257 ///
		 || HindCurJ3_ [03]ER21234 [05]ER25223 [07]ER36228 [09]ER42259 [11]ER47572 [13]ER53272 [15]ER60287 ///
		 || WindCurJ1_ [03]ER21396 [05]ER25386 [07]ER36391 [09]ER42420 [11]ER47737 [13]ER53443 [15]ER60458 ///
		 || WindCurJ2_ [03]ER21452 [05]ER25449 [07]ER36454 [09]ER42481 [11]ER47799 [13]ER53505 [15]ER60520 ///
		 || WindCurJ3_ [03]ER21484 [05]ER25481 [07]ER36486 [09]ER42511 [11]ER47829 [13]ER53535 [15]ER60550 ///		 
		 || HearnJ1_   [03]ER21182 [05]ER25171 [07]ER36176 [09]ER42209 [11]ER47522 [13]ER53222 [15]ER60237 ///		
		 || HearnJ2_   [03]ER21214 [05]ER25203 [07]ER36208 [09]ER42239 [11]ER47552 [13]ER53252 [15]ER60267 ///
		 || HearnJ3_   [03]ER21246 [05]ER25235 [07]ER36240 [09]ER42269 [11]ER47582 [13]ER53282 [15]ER60297 ///
		 || WearnJ1_   [03]ER21432 [05]ER25429 [07]ER36434 [09]ER42461 [11]ER47779 [13]ER53485 [15]ER60500 ///		
		 || WearnJ2_   [03]ER21464 [05]ER25461 [07]ER36466 [09]ER42491 [11]ER47809 [13]ER53515 [15]ER60530 ///
		 || WearnJ3_   [03]ER21496 [05]ER25493 [07]ER36498 [09]ER42521 [11]ER47839 [13]ER53545 [15]ER60560 ///	
		 || Hxtrajobs  [03]ER21281 [05]ER25270 [07]ER36275 [09]ER42302 [11]ER47615 [13]ER53315 [15]ER60330 ///
		 || Wxtrajobs  [03]ER21531 [05]ER25528 [07]ER36533 [09]ER42554 [11]ER47872 [13]ER53578 [15]ER60593 ///	
		 || HselfEmp   [68]V198 [69]V641 [70]V1280 [71]V1986 [72]V2584 [73]V3117 [74]V3532 [75]V3970 [76]V4461 [77]V5376 [78]V5875 [79]V6493 [80]V7096 ///
					   [81]V7707 [82]V8375 [83]V9006 [84]V10456 [85]V11640 [86]V13049 [87]V14149 [88]V15157 [89]V16658 [90]V18096 [91]V19396 [92]V20696 ///
					   [93]V22451 [94]ER2074 [95]ER5073 [96]ER7169 [97]ER10086 [99]ER13210 [01]ER17221 ///	
		 || WselfEmpE  [76]V4844 [79]V6592 [80]V7194 [81]V7880 [82]V8539 [83]V9189 [84]V10674 [85]V12003 [86]V13228 ///
					   [87]V14324 [88]V15459 [89]V16977 [90]V18398 [91]V19698 [92]V20998 [93]V22804 [94]ER2568 [95]ER5567 [96]ER7663 [97]ER10568 [99]ER13722 [01]ER17791 ///
		 || WselfEmpU  [84]V10807 [85]V12123 [86]V13324 [87]V14418 [88]V15627 [89]V17159 [90]V18566 [91]V19866 [92]V21166 [93]V23005 [94]ER2835 [95]ER5834 [96]ER7930 [97]ER10836 [99]ER14007 [01]ER18106 ///
		 || HselfEmpJ1_   [03]ER21147 [05]ER25129 [07]ER36134 [09]ER42169 [11]ER47482 [13]ER53182 [15]ER60197 ///		
		 || HselfEmpJ2_   [03]ER21203 [05]ER25192 [07]ER36197 [09]ER42230 [11]ER47543 [13]ER53243 [15]ER60258  ///
		 || HselfEmpJ3_   [03]ER21235 [05]ER25224 [07]ER36229 [09]ER42260 [11]ER47573 [13]ER53273 [15]ER60288 /// 
		 using Mdta , clear design(3)
		save $InputDTAs_dir\occHist, replace

***************************************************************************************************************************		
	
***************************************************************************************************************************		
*Notes:
*	-CurrOcc uses 1970s census codes
*	-#retroOcc recoded retrospectively into 1970s Census codes
*	-After 2001, important changes. Call occhistory2000 separately
*   -Head =10, wife =20 or 22	
*	-For Occs coded 1-7:
* 		1	Professional, technical, and kindred workers
*		2	Managers, officials, and proprietors
*		3	Self-employed businessmen
*		4	Clerical and sales workers
*		5	Craftsmen, foremen, and kindred workers
*		6	Operatives and kindred workers
*		7	Laborers and service workers, farm laborers
*		8	Farmers and farm managers
*		9	Miscellaneous (armed services, protective workers); NA; DK
*		0	Inap.: no father/surrogate; deceased; never worked
*	-Occupations after 1999 coded in 2000 codes
*	-IndCur coded into 1970s census codes until 2001.
*		-Switch to 1990 Census using "alm_ind1970_ind1990.dta"
*	-IndCur coded into 2000s census codes after 2001
*		-Switch into 1990 Census using "cw_ind2000_ind1990ddx.dta"
*************************************************************************************************
*Set up
*------------------------------------------------------------------------------------------------
* Go long
psid long

gen HH=(xsqnr==1)
gen HW=(xsqnr==2)

xtset x11101ll wave

* Extra job indicator
	*Early period
	gen XtraJob = hXtraJob if HH==1
		replace XtraJob = wXtraJob if HW==1
		replace XtraJob = 1 if ( XtraJob==1 | XtraJob==3)
		replace XtraJob = 0 if ( XtraJob==4 | XtraJob==5)
		replace XtraJob = . if ( XtraJob==9 | XtraJob==8 )
	*Late period- different coding
	gen XtraJob2 = Hxtrajobs if HH==1
		replace XtraJob2 = Wxtrajobs if HW==1
		replace XtraJob2 = . if (XtraJob2==8 | XtraJob2==9)
		replace XtraJob2 = 1 if XtraJob2>0	& XtraJob2<7
	replace XtraJob = XtraJob2 if wave>2001	
		drop XtraJob2
		
* Self Employment indicator
	gen SelfEmp = 1 if HselfEmp==3 & HH==1
	replace SelfEmp = 1 if ((WselfEmpE==3 | WselfEmpU==3) & HW==1)
	replace SelfEmp = 0 if (((WselfEmpE==1 | WselfEmpU==2) & HW==1) | ((HselfEmp==1 | HselfEmp==2) & HH==1)) 
	

* Find Main Job
	
	*Code Head's occ as current if reported in current survey, retro if reported later.
	gen Hocc = HoccCur
	replace Hocc = HretroOcc if Hocc==.
	gen Hind = HIndCur
	replace Hind = HretroInd if Hind==.
	*Assign to person
	gen occ = Hocc if HH==1
	gen industry = Hind if HH==1
	
	*Same for Wifey
    gen Wocc = WoccCur
	replace Wocc = WretroOcc if Wocc==.
	gen Wind = WIndCur
	replace Wind = WretroInd if Wind==.	
	replace occ = Wocc if HW==1
	replace industry = Wind if HW==1
	replace occ =. if occ==0
	replace industry=. if industry==0
	
* Merge with David Dorn's nice stuff to go 1970>1990
    merge m:1 occ using $InputDTAs_dir\occ1970_occ1990dd.dta
	drop occ 
	rename occ1990dd occ
	drop if _merge==2
	drop _merge 
* Merge with ALM's nice stuff to go 1970>1990
	rename ind ind1970
    merge m:1 ind1970 using $InputDTAs_dir\alm_ind1970_ind1990.dta
	drop ind1970 
	rename ind1990 ind
	drop if _merge==2
	drop _merge 
	
*Clean house
drop HoccCur WoccCur Hretro* Wretro* Hind HInd Wind WInd Hocc WSame Wocc

*************************************************************************************************
*Tenure variables, only need for quite old jobs and need to check >5yrs.
* 1969-1975
*	1	Under 12 months
*   2	1 year, but not more than 19 months
*   3	2 - 3 years or 19 - 42 months
*   4	4 - 9 years
*   5   10 - 19 years
*	6	20 years or more
* 1976-1987
* 	number of months, 998=998 or more, 999= missing
gen Tenure = hTenure if HH==1
replace Tenure = wTenure if HW==1

	gen Tnre = 1 if (Tenure==1 & wave<1976)
	replace Tnre = 2 if (Tenure==1 & wave<1976)
	replace Tnre = 3 if (Tenure==2 & wave<1976)
	replace Tnre = 5 if (Tenure==3 & wave<1976)
	replace Tnre = 15 if (Tenure==4 & wave<1976)
	replace Tnre = 25 if (Tenure==5 & wave<1976)
	replace Tnre = Tenure if (Tenure<999 & wave<1975)

	drop Tenure hTenure wTenure
	gen hTenure = hTenurem if HH==1 & hTenurem<13
		replace hTenure=0 if hTenure==.
		replace hTenure = hTenurey+hTenure if HH==1 & hTenurey<90
	gen wTenure = wTenurem if HW==1 & wTenurem<13
		replace wTenure=0 if wTenure==.
		replace wTenure = wTenurey+wTenure if HW==1 & wTenurey<90	

	replace Tnre = hTenure if HH==1 & wave>1993
	replace Tnre = wTenure if HW==1 & wave>1993
	
		drop wTen* hTen* hXtraJob wXtraJob
	
	save $InputDTAs_dir\occhist, replace
	
	
***************************************************************************************************************************		
*Notes:
*	-After 2001 start asking about several jobs, need to figure out which to use. Choose highest earnings	
*	-Occupations after 1999 coded in 2000 codes

		
***************************************************************************************************************************		
	

* Find Main Job	
	*Classify main occupation as the one with the highest earnings
    gen Mocc= HearnJ1_	
	replace Mocc =. if (Mocc>35000000 | Mocc<1000)
	gen Hocc = HoccCurJ1_
	gen Hind = HindCurJ1_
	gen HSelfE = HselfEmpJ1_
	
    gen Mocc2= HearnJ2
	replace Mocc2 =. if (Mocc2>35000000 | Mocc2<1000)
	replace Hocc = HoccCurJ2_ if (Mocc2>Mocc & Mocc2~=.)
	replace Hind = HindCurJ2_ if (Mocc2>Mocc & Mocc2~=.)
	replace HSelfE = HselfEmpJ2_ if (Mocc2>Mocc & Mocc2~=.)
	replace Mocc = Mocc2 if (Mocc2>Mocc & Mocc2~=.)
	
	replace Mocc2 = HearnJ3 
	replace Mocc2 =. if (Mocc2>35000000 | Mocc2<1000)
	replace Hocc = HoccCurJ3_ if (Mocc2>Mocc & Mocc2~=.)
	replace Hind = HindCurJ3_ if (Mocc2>Mocc & Mocc2~=.)
	replace HSelfE = HselfEmpJ3_ if (Mocc2>Mocc & Mocc2~=.)
	
	drop Mocc* 
	
	*Same for Wifey
    gen Mocc= WearnJ1_	
	replace Mocc =. if (Mocc>35000000 | Mocc<1000)
	gen Wocc = WoccCurJ1_
	gen Wind = WindCurJ1_
	
    gen Mocc2= WearnJ2_
	replace Mocc2 =. if (Mocc2>35000000 | Mocc2<1000)
	replace Wocc = WoccCurJ2_ if (Mocc2>Mocc & Mocc2~=.)
	replace Wind = WindCurJ2_ if (Mocc2>Mocc & Mocc2~=.)
	replace Mocc = Mocc2 if (Mocc2>Mocc & Mocc2~=.)
	
	replace Mocc2 = WearnJ3_
	replace Mocc2 =. if (Mocc2>35000000 | Mocc2<1000)
	replace Wocc = WoccCurJ3_ if (Mocc2>Mocc & Mocc2~=.)
	replace Wind = WindCurJ3_ if (Mocc2>Mocc & Mocc2~=.)
	
	drop Mocc* 

	rename occ occ1
	rename ind ind1
	
	gen occ = Hocc if HH==1	
	replace occ = Wocc if HW==1
	replace occ=. if occ==0
	gen ind = Hind if HH==1	
	replace ind = Wind if HW==1
	replace ind=. if ind==0
	
	replace SelfEmp = 1 if (HSelfE==3 & HH==1 & wave>2001)
	replace SelfEmp = 0 if ((HselfEmp==1 | HselfEmp==2) & HH==1 & wave>2001) 
	
	drop Hocc* Wocc* Hearn* Wearn* Hind* Wind* Hxtrajobs Wxtrajobs Hself* Wself*

	
* Merge with David Dorn's nice stuff to go 2000>1990
	*Current Occ
    merge m:1 occ using $InputDTAs_dir/occ2000_occ1990dd.dta
	drop occ 
	rename occ1990dd occ
	drop if _merge==2
	drop _merge 
	
* Merge with David Dorn's nice stuff to go 2000>1990
	*Cleaning code, map to ind with highest weight:
		*rename ind1990ddx ind1990
		*by ind2000 (weight), sort: keep if _n == 1
	rename ind ind2000
    merge m:1 ind2000 using $InputDTAs_dir\cw_ind2000_ind1990ddx.dta
	drop ind2000
	rename ind1990 ind
	drop if _merge==2
	drop _merge 
		
	replace ind=ind1 if wave<2003
	replace occ=occ1 if wave<2003
	
	drop SOC HW HH  ind1 occ1
	save $InputDTAs_dir\occhist, replace

*------------------------------------------------------------------------
* Add labels
***********************************************************************	
la drop SOC_lbl

	gen SOC = 1 if (occ>002 & occ<38)
		replace SOC = 2 if (occ>042 & occ<236)
		replace SOC = 3 if (occ>242 & occ<286)
		replace SOC = 4 if (occ>302 & occ<390)
		replace SOC = 5 if (occ>402 & occ<408)
		replace SOC = 6 if (occ>412 & occ<428)
		replace SOC = 7 if (occ>432 & occ<445)
		replace SOC = 8 if (occ>444 & occ<448)
		replace SOC = 9 if (occ>447 & occ<470)
		replace SOC = 10 if (occ>472 & occ<500)
		replace SOC = 11 if (occ>502 & occ<550)
		replace SOC = 12 if (occ>552 & occ<618)
		replace SOC = 13 if (occ>632 & occ<700)
		replace SOC = 14 if (occ>702 & occ<800)
		replace SOC = 15 if (occ>802 & occ<860)
		replace SOC = 16 if (occ>862 & occ<890)

		label define SOC_lbl 1 `"Managerial specialty (003-037)"'
		label define SOC_lbl 2 `"Professional specialty operation and technical support(043-235)"', add
		label define SOC_lbl 3 `"Sales (243-285)"', add
		label define SOC_lbl 4 `"Clerical, administrative support (303-389)"', add
		label define SOC_lbl 5 `"Service: private household, cleaning and building services (403-407)"', add
		label define SOC_lbl 6 `"Service: protection (413-427)"', add
		label define SOC_lbl 7 `"Service: food preparation (433-444)"', add
		label define SOC_lbl 8 `"Health services (445-447)"', add
		label define SOC_lbl 9 `"Personal services (448-469)"', add
		label define SOC_lbl 10 `"Farming, forestry, fishing (473-499)"', add
		label define SOC_lbl 11 `"Mechanics and repair (503-549)"', add
		label define SOC_lbl 12 `"Construction trade and extractors (553-617)"', add
		label define SOC_lbl 13 `"Precision production (633-699)"', add
		label define SOC_lbl 14 `"Operators: machine (703-799)"', add
		label define SOC_lbl 15 `"Operators: transport, etc. (803-859)"', add
		label define SOC_lbl 16 `"Operators: handlers, etc. (863-889)"', add
		
		label values SOC SOC_lbl 
		drop occ
		rename SOC occ
		
	gen SIC = 1 if (ind>002 & ind<33)
		replace SIC = 2 if (ind>39 & ind<51)
		replace SIC = 3 if (ind>50 & ind<100)
		replace SIC = 4 if (ind>99 & ind<230)
		replace SIC = 5 if (ind>229 & ind<400)
		replace SIC = 6 if (ind>399 & ind<500)
		replace SIC = 7 if (ind>499 & ind<540)
		replace SIC = 8 if (ind>539 & ind<580)
		replace SIC = 9 if (ind>579 & ind<700)
		replace SIC = 10 if (ind>699 & ind<721)
		replace SIC = 11 if (ind>720 & ind<761)
		replace SIC = 12 if (ind>760 & ind<800)
		replace SIC = 13 if (ind>799 & ind<811)
		replace SIC = 14 if (ind>811 & ind<900)
		replace SIC = 15 if (ind>899 & ind<940)
		replace SIC = 16 if (ind>939 & ind<961)

		label define SIC_lbl 1 `"Ag, Forest, Fish"'
		label define SIC_lbl 2 `"Mining"', add
		label define SIC_lbl 3 `"Construction"', add
		label define SIC_lbl 4 `"Manufacture; Non-Durable"', add
		label define SIC_lbl 5 `"Manufacture; Durable"', add
		label define SIC_lbl 6 `"Transport, Comm, Utility"', add
		label define SIC_lbl 7 `"Wholesale; Durable"', add
		label define SIC_lbl 8 `"Wholesale; Non-Durable"', add
		label define SIC_lbl 9 `"Retail"', add
		label define SIC_lbl 10 `"Finance, Insur, Real Estate"', add
		label define SIC_lbl 11 `"Service; Business"', add
		label define SIC_lbl 12 `"Service; Personal"', add
		label define SIC_lbl 13 `"Service; Entertainment & Rec"', add
		label define SIC_lbl 14 `"Service; Professional"', add
		label define SIC_lbl 15 `"Public Admin"', add
		label define SIC_lbl 16 `"Military"', add
		
		label values SIC SIC_lbl 
		drop ind weight
		rename SIC ind		
		
xtset x11101ll wave
tsfill

drop x11102 xsqnr		

	save $InputDTAs_dir\occhist, replace	
	

