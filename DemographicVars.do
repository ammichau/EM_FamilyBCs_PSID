*DemographicVars.do
*-------------------v.6-5-2017; @A. Michaud for AddedWorker w/ K.Ellieroth---------------------------------*
cd $PSID_dir
***************************************************************************************************************
* This code reads in and cleans demographic and control variables from PSID
* Variables in use:
**Family Level
*	-Work Experience- Number of years worked Full Time
*	-Education Variables
*	-Race
*	-City Size
**Person Level
*	-Age
*	-Married Pairs
*-------------------------------------------------------------------------------------------------
* Requirements:
*	-You have to have files set up for psiduse in folder "Mdta", a subdirectory of PSID_dir set in main file
***************************************************************************************************************

clear all
set more off
ssc install psidtools


psid use || wEduc    [68]V246 [72]V2687 [73]V3216 [74]V3638 [75]V4199 [76]V5075 [77]V5648 [78]V6195 [79]V6788 [80]V7434 [81]V8086 [82]V8710 ///
				     [83]V9396 [84]V11043 [85]V12401 [86]V13641 [87]V14688 [88]V16162 [89]V17546 [90]V18899 ///
		 || hEduc    [68]V313 [69]V794 [70]V1485 [71]V2197 [72]V2823 [73]V3241 [74]V3663 [75]V4198 [76]V5074 [77]V5647 [78]V6194 [79]V6787 ///
					 [80]V7433 [81]V8085 [82]V8709 [83]V9395 [84]V11042 [85]V12400 [86]V13640 [87]V14687 [88]V16161 [89]V17545 [90]V18898 ///
		 || hHS		 [85]V11945 [86]V13568 [87]V14615 [88]V16089 [89]V17486 [90]V18817 [91]V20117 [92]V21423 [93]V23279 [94]ER3948 [95]ER6818 ///
					 [96]ER9064 [97]ER11854 [99]ER15937 [01]ER19998 [03]ER23435 [05]ER27402 [07]ER40574 [09]ER46552 [11]ER51913 [13]ER57669 [15]ER64821 ///
		 || wHS		 [85]V12300 [86]V13503 [87]V14550 [88]V16024 [89]V17421 [90]V18752 [91]V20052 [92]V21358 [93]V23215 [94]ER3887 [95]ER6757 ///
					 [96]ER9003 [97]ER11766 [99]ER15845 [01]ER19906 [03]ER23343 [05]ER27306 [07]ER40481 [09]ER46458 [11]ER51819 [13]ER57559 [15]ER64682 ///
		 || hCol     [75]V4099 [76]V4690 [77]V5614 [78]V6163 [79]V6760 [80]V7393 [81]V8045 [82]V8669 [83]V9355 [84]V11002 [85]V11960 ///
					 [86]V13583 [87]V14630 [88]V16104 [89]V17501 [90]V18832 [91]V20132 [92]V21438 [93]V23294 [94]ER3963 [95]ER6833 ///
				 	 [96]ER9079 [97]ER11869 [99]ER15952 [01]ER20013 [03]ER23450 [05]ER27417 [07]ER40589 [09]ER46567 [11]ER51928 [13]ER57684 [15]ER64836 ///
		 || wCol	 [75]V4105 [76]V4698 [77]V5570 [78]V6119 [79]V6716 [80]V7349 [81]V8001 [82]V8625 [83]V9311 [84]V10958 [85]V12315 ///
					 [86]V13513 [87]V14560 [88]V16034 [89]V17431 [90]V18762 [91]V20062 [92]V21368 [93]V23225 [94]ER3897 [95]ER6767 ///
					 [96]ER9013 [97]ER11781 [99]ER15860 [01]ER19921 [03]ER23358 [05]ER27321 [07]ER40496 [09]ER46473 [11]ER51834 [13]ER57574 [15]ER64697 ///
		 || hEducC	 [75]V4093 [76]V4684 [77]V5608 [78]V6157 [79]V6754 [80]V7387 [81]V8039 [82]V8663 [83]V9349 [84]V10996 [91]V20198 [92]V21504 ///
					 [93]V23333 [94]ER4158 [95]ER6998 [96]ER9249 [97]ER12222 [99]ER16516 [01]ER20457 [03]ER24148 [05]ER28047 [07]ER41037 [09]ER46981 [11]ER52405 [13]ER58223 [15]ER65459 ///
		 || wEducC	 [75]V4102 [76]V4695 [77]V5567 [78]V6116 [79]V6713 [80]V7346 [81]V7998 [82]V8622 [83]V9308 [84]V10955 [91]V20199 [92]V21505 [93]V23334 [94]ER4159 [95]ER6999 ///
				     [96]ER9250 [97]ER12223 [99]ER16517 [01]ER20458 [03]ER24149 [05]ER28048 [07]ER41038 [09]ER46982 [11]ER52406 [13]ER58224 [15]ER65460 ///						 
		 || hrace    [68]V181 [69]V801 [70]V1490 [71]V2202 [72]V2828 [73]V3300 [74]V3720 [75]V4204 [76]V5096 [77]V5662 [78]V6209 [79]V6802 /// 
					 [80]V7447 [81]V8099 [82]V8723 [83]V9408 [84]V11055 [85]V11938 [86]V13565 [87]V14612 [88]V16086 [89]V17483 [90]V18814 ///
					 [91]V20114 [92]V21420 [93]V23276 [94]ER3944 [95]ER6814 [96]ER9060 [97]ER11848 [99]ER15928 [01]ER19989 [03]ER23426 ///
					 [05]ER27393 [07]ER40565 [09]ER46543 [11]ER51904 [13]ER57659 [15]ER64810 ///
		 || wrace    [85]V12293 [86]V13500 [87]V14547 [88]V16021 [89]V17418 [90]V18749 [91]V20049 [92]V21355 [93]V23212 [94]ER3883 [95]ER6753 ///
					 [96]ER8999 [97]ER11760 [99]ER15836 [01]ER19897 [03]ER23334 [05]ER27297 [07]ER40472 [09]ER46449 [11]ER51810 [13]ER57549 [15]ER64671 ///
		 || hMarried [68]V239 [69]V607 [70]V1365 [71]V2072 [72]V2670 [73]V3181 [74]V3598 [75]V4053 [76]V4603 [77]V5650 [78]V6197 [79]V6790 [80]V7435 [81]V8087 ///
					 [82]V8711 [83]V9419 [84]V11065 [85]V12426 [86]V13665 [87]V14712 [88]V16187 [89]V17565 [90]V18916 [91]V20216 [92]V21522 [93]V23336 [94]ER4159A ///
					 [95]ER6999A [96]ER9250A [97]ER12223A [99]ER16423 [01]ER20369 [03]ER24150 [05]ER28049 [07]ER41039 [09]ER46983 [11]ER52407 [13]ER58225 [15]ER65461 ///	
		 || City     [68]V95 [69]V539 [70]V1506 [71]V1816 [72]V2406 [73]V3006 [74]V3406 [75]V3806 [76]V4306 [77]V5206 [78]V5706 [79]V6306 [80]V6906 [81]V7506 [82]V8206 ///
					 [83]V8806 [84]V10006 [85]V11106 [86]V12506 [87]V13706 [88]V14806 [89]V16306 [90]V17706 [91]V19006 [92]V20306 [93]V21605 [94]ER4157B [95]ER6997B ///
					 [96]ER9248B [97]ER12221B [99]ER16432 [01]ER20378 [03]ER24145 [05]ER28044 [07]ER41034 [09]ER46976 [11]ER52400 [13]ER58218 [15]ER65454 ///
		 || wpts     [68]ER30019 [69]ER30042 [70]ER30066 [71]ER30090 [72]ER30116 [73]ER30137 [74]ER30159 [75]ER30187 [76]ER30216 [77]ER30245 [78]ER30282 ///
					 [79]ER30312 [80]ER30342 [81]ER30372 [82]ER30398 [83]ER30428 [84]ER30462 [85]ER30497 [86]ER30534 [87]ER30569 [88]ER30605 [89]ER30641 ///
					 [90]ER30686 [91]ER30730 [92]ER30803 [93]ER30864 [94]ER33119 [95]ER33275 [96]ER33318 [97]ER33438 [99]ER33547 [01]ER33639 [03]ER33742 [05]ER33849 [07]ER33951 [09]ER34046 [11]ER34155 [15]ER34414 ///
		 || Age 	 [68]ER30004 [69]ER30023 [70]ER30046 [71]ER30070 [72]ER30094 [73]ER30120 [74]ER30141 [75]ER30163 [76]ER30191 [77]ER30220 [78]ER30249 [79]ER30286 [80]ER30316 [81]ER30346 ///
					 [82]ER30376 [83]ER30402 [84]ER30432 [85]ER30466 [86]ER30501 [87]ER30538 [88]ER30573 [89]ER30609 [90]ER30645 [91]ER30692 [92]ER30736 [93]ER30809 [94]ER33104 [95]ER33204 ///
					 [96]ER33304 [97]ER33404 [99]ER33504 [01]ER33604 [03]ER33704 [05]ER33804 [07]ER33904 [09]ER34004 [11]ER34104 [13]ER34204  [15]ER34305 ///
		 || Sex      [68]ER32000 ///
		 || MPair	 [68]ER30005 [69]ER30024 [70]ER30047 [71]ER30071 [72]ER30095 [73]ER30121 [74]ER30142 [75]ER30164 [76]ER30192 [77]ER30221 [78]ER30250 ///
					 [79]ER30287 [80]ER30317 [81]ER30347 [82]ER30377 [83]ER30405 [84]ER30435 [85]ER30469 [86]ER30504 [87]ER30541 [88]ER30576 [89]ER30612 [90]ER30648 ///
					 [91]ER30695 [92]ER30739 [93]ER30812 [94]ER33107 [95]ER33207 [96]ER33307 [97]ER33407 [99]ER33507 [01]ER33607 [03]ER33707 [05]ER33807 [07]ER33907 [09]ER34007 [11]ER34107 [13]ER34207 [15]ER34308 ///
		 || AgeYoungest	 [68]V120 [69]V1013 [70]V1243 [71]V1946 [72]V2546 [73]V3099 [74]V3512 [75]V3925 [76]V4440 [77]V5354 [78]V5854 [79]V6466 [80]V7071 [81]V7662 [82]V8356 [83]V8965 [84]V10423 [85]V11610 ///
					     [86]V13015 [87]V14118 [88]V15134 [89]V16635 [90]V18053 [91]V19353 [92]V20655 [93]V22410 [94]ER2011 [95]ER5010 [96]ER7010 [97]ER10013 [99]ER13014 [01]ER17017 [03]ER21021 [05]ER25021 ///
						 [07]ER36021 [09]ER42021 [11]ER47321 [13]ER53021 [15]ER60022 ///
		 || nChild   [68]V398 [69]V550 [70]V1242 [71]V1945 [72]V2545 [73]V3098 [74]V3511 [75]V3924 [76]V4439 [77]V5353 [78]V5853 [79]V6465 [80]V7070 [81]V7661 [82]V8355 [83]V8964 [84]V10422 [85]V11609 ///
					 [86]V13014 [87]V14117 [88]V15133 [89]V16634 [90]V18052 [91]V19352 [92]V20654 [93]V22409 [94]ER2010 [95]ER5009 [96]ER7009 [97]ER10012 [99]ER13013 [01]ER17016 [03]ER21020 [05]ER25020 ///
					 [07]ER36020 [09]ER42020 [11]ER47320 [13]ER53020 [15]ER60021 ///
		 || relhd    [68]ER30003 [69]ER30022 [70]ER30045 [71]ER30069 [72]ER30093 [73]ER30119 [74]ER30140 [75]ER30162 [76]ER30190 [77]ER30219 [78]ER30248 [79]ER30285 [80]ER30315 [81]ER30345 [82]ER30375 ///
					 [83]ER30401 [84]ER30431 [85]ER30465 [86]ER30500 [87]ER30537 [88]ER30572 [89]ER30608 [90]ER30644 [91]ER30691 [92]ER30735 [93]ER30808 [94]ER33103 [95]ER33203 [96]ER33303 [97]ER33403 ///
					 [99]ER33503 [01]ER33603 [03]ER33703 [05]ER33803 [07]ER33903 [09]ER34003 [11]ER34103 [13]ER34203 [15]ER34303 ///
		 || DeathYr  [68]ER32050 ///
		 using Mdta , clear design(3)
		 

	save $InputDTAs_dir/Demographics, replace   

 
***************************************************************************************************************************		
*Notes:
*   -hHS and wHS = year of graduation, supposed to not include GED
*   -weduc & heduc = 4 if completed HS, 7 =BA, 8 =PhD
* 	-wCol and hCol = 1 if completed college degree
*	-race=1 if white, =2 if black
	forvalues y = 1969/2015{
		gen Sex`y'=Sex1968
		gen DeathYr`y' = DeathYr1968
		}


* Go long
	psid long
	xtset x11101ll wave
	
* Assign vars to appropriate person	

gen HH=(xsqnr==1)
gen HW=(xsqnr==2)


*************************************************************************************************
*Coding Chunk 1: Education
* Codes pre-1975 differ
*------------------------------------------------------------------------------------------------
gen educ = hEducC if HH==1
replace educ =wEducC if (HW==1 & educ==.)
replace educ = . if educ==99

replace educ = wEduc if (HW==1 & wave<1975)
replace educ = hEduc if (HH==1 & wave<1975)

	gen     EdBin=1 if educ<=3 & wave<1975                  		/*0-11  grades*/
	replace EdBin=2 if (educ==4|educ==5) & wave<1975		      	/*High school or 12 grades+nonacademic training*/
	replace EdBin=3 if educ>=6 & educ<=8 & wave<1975            	/*College dropout, BA degree, or college & adv./prof. degree*/
	replace EdBin=. if educ>8 & wave<1975                   		/*Missing, NA, DK*/
	replace EdBin=1 if educ>=0  & educ<=11 & wave>1974            	/*0-11  grades*/
	replace EdBin=2 if educ==12 & wave>1974                         			/*High school or 12 grades+nonacademic training*/
	replace EdBin=3 if educ>=13 & educ<=17 & wave>1974            	/*College dropout, BA degree, or college & adv./prof. degree*/
	replace EdBin=. if educ>17 & wave>1974 	                   		/*Missing, NA, DK*/

	gen lsHS=(EdBin==1)
	gen HS=(EdBin==2)
	gen Col=(EdBin==3)
	
	replace lsHS=. if EdBin==.
	replace HS=. if EdBin==.
	replace Col=. if EdBin==.

by  x11101ll, sort: egen EdBin2 =  mode(EdBin), maxmode	

replace lsHS=L.lsHS if wave>1997 & lsHS==.
replace HS=L.HS if wave>1997 & HS==.
replace Col=L.Col if wave>1997 & Col==.

*************************************************************************************************
*Coding Chunk 2: Race, Age, Gender
*------------------------------------------------------------------------------------------------
*
	gen Racet = hrace if HH==1
	replace Racet = wrace if HW==1
	
	by  x11101ll, sort: egen Race =  mode(Racet), minmode
	
	drop Racet hrace wrace

	gen Female=(Sex==2)
	replace Age=. if Age>108 | Age==0
	replace Age = F.Age - 1 if Age==. & wave>1997
	
*************************************************************************************************
*Coding Chunk 3: Maritial Status
*------------------------------------------------------------------------------------------------
* Maritial Status
gen married=((hMarried==1  | hMarried==8) & HH==1)
gen divorced=((hMarried==4  | hMarried==5) & HH==1)
gen nevermarried=(hMarried==2 & HH==1)
gen widow=(hMarried==3 & HH==1)

*Married pair- interview number maxes at 1,500,000
	*So, I will multiply Mpair number by 10,000,000 and add it
gen MPairNum = MPair*10000000 + x11102
	replace MPairNum=. if MPair==0
	
	foreach var of varlist married divorced nevermarried widow MPairNum {
		replace `var' = L.`var' if `var'==. & wave>1997
	}
	

	
*************************************************************************************************
*Coding Chunk 4: Urban 
*------------------------------------------------------------------------------------------------	
*Urban measured as >100,000
	gen Urban=(City==1 | City==2)	
*Rural measured as less than 25,000
	gen Rural=(City==5 | City==6)

	foreach var of varlist Urban Rural {
		replace `var' = L.`var' if `var'==. & wave>1997
	}
	
drop wEducC hEducC hHS wHS hCol wCol hMarried  hEduc

*************************************************************************************************
*Coding Chunk 5: Children 
*------------------------------------------------------------------------------------------------

replace AgeYoungest=. if (AgeYoungest==9 | AgeYoungest==0)

*************************************************************************************************
*Coding Chunk 6: Dead
*------------------------------------------------------------------------------------------------
* Dead=1 if, well... dead. 
*------------------------------------------------------------------------------------------------	
replace DeathYr=1971 if DeathYr==7071
replace DeathYr=1972 if DeathYr==7172
replace DeathYr=1973 if DeathYr==7273
replace DeathYr=1974 if DeathYr==7374
replace DeathYr=1975 if DeathYr==7475
replace DeathYr=1976 if DeathYr==7576
replace DeathYr=1977 if DeathYr==7677
replace DeathYr=1978 if DeathYr==7778
replace DeathYr=1979 if DeathYr==7879
replace DeathYr=1980 if DeathYr==7980
replace DeathYr=1981 if DeathYr==8081
replace DeathYr=1982 if DeathYr==8182
replace DeathYr=1983 if DeathYr==8283
replace DeathYr=1984 if DeathYr==8384
replace DeathYr=1985 if DeathYr==8485
replace DeathYr=1986 if DeathYr==8586
replace DeathYr=1987 if DeathYr==8687
replace DeathYr=1988 if DeathYr==8788
replace DeathYr=1989 if DeathYr==8889
replace DeathYr=1990 if DeathYr==8990
replace DeathYr=1991 if DeathYr==9091
replace DeathYr=1992 if DeathYr==9192
replace DeathYr=1993 if DeathYr==9293
replace DeathYr=1994 if DeathYr==9394
replace DeathYr=1995 if DeathYr==9495
replace DeathYr=1996 if DeathYr==9596
replace DeathYr=1997 if DeathYr==9697
replace DeathYr=1998 if DeathYr==9798
replace DeathYr=1999 if DeathYr==9899
replace DeathYr=2000 if DeathYr==9901
replace DeathYr=2002 if DeathYr==103
replace DeathYr=2004 if DeathYr==305
replace DeathYr=2006 if DeathYr==709
replace DeathYr=2012 if DeathYr==1113

gen dead = 0
forvalues x = 2012(-1)1967 {
	replace dead= 1 if (DeathYr==`x' & wave==`x' )	
	forvalues z = `x'(1)2015 {
		replace dead = 1 if (DeathYr==`x' & wave==`z')
	}		
}



save $InputDTAs_dir\Demographics, replace
