*jobloss.do
*-------------------v.6-5-2017; @A. Michaud for AddedWorker w/ K.Ellieroth---------------------------------*
cd $PSID_dir
***************************************************************************************************************
* This code reads in and cleans job loss related variables from PSID
* Variables in use:
**Family Level
*	-Number of years worked Full Time- Head (HnyrsFT); Wife (WnyrsFT)
*	-Hours per Year- Head (hHrsYr); Wife (wHrsYr)
*	-Hourly Wage- Head (hHrWage); Wife (wHrWage)
*	-Labor Income- Head (hLabInc); Wife (wLabInc)
*	-Unemployed Last year- Head (hMissELstYrE, hMissELstYrU); Wife (wMissELstYrE, wMissELstYrU)
*	-Weeks Unemployed Last year- Head (hUHrs1 hUHrs2 hUWksE hUWksU); Wife (wUHrs wUWksE wUWksU)
**Person Level
*	-Employed (Empl1)
*-------------------------------------------------------------------------------------------------
* Requirements:
*	-You have to have files set up for psiduse in folder "Mdta", a subdirectory of PSID_dir set in main file
***************************************************************************************************************

clear all
set more off

*ssc install psidtools
*psid install using Mdta

psid use || HnyrsFT  [74]V3621 [75]V4142 [76]V4631 [77]V5605 [78]V6154 [79]V6751 [80]V7384 [81]V8036 [82]V8660 [83]V9346 ///
					 [84]V10993 [85]V11740 [86]V13606 [87]V14653 [88]V16127 [89]V17524 [90]V18855 [91]V20155 [92]V21461  ///
					 [93]V23317 [94]ER3986 [95]ER6856 [96]ER9102 [97]ER11898 [99]ER15980 [01]ER20041 [03]ER23477 [05]ER27445 ///
					 [07]ER40617 [09]ER46595 [11]ER51956 [13]ER57712 [15]ER64872 ///
		 || WnyrsFT  [74]V3611 [75]V4111 [76]V4990 [77]V5575 [78]V6124 [79]V6721 [80]V7354 [81]V8006 [82]V8630 [83]V9316 ///
					 [84]V10963 [85]V12103 [86]V13532 [87]V14579 [88]V16053 [89]V17450 [90]V18781 [91]V20081 [92]V21387 ///
					 [93]V23244 [94]ER3916 [95]ER6786 [96]ER9032 [97]ER11810 [99]ER15887 [01]ER19948 [03]ER23385 [05]ER27349 ///
					 [07]ER40524 [09]ER46501 [11]ER51862 [13]ER57602 [15]ER64733 /// 
		 || HnyrsEmp [74]V3620 [75]V4141 [76]V4630 [77]V5604 [78]V6153 [79]V6750 [80]V7383 [81]V8035 [82]V8659 [83]V9345 [84]V10992 ///
					 [85]V11739 [86]V13605 [87]V14652 [88]V16126 [89]V17523 [90]V18854 [91]V20154 [92]V21460 [93]V23316 [94]ER3985 ///
					 [95]ER6855 [96]ER9101 [97]ER11897 [99]ER15979 [01]ER20040 [03]ER23476 [05]ER27444 [07]ER40616 [09]ER46594 [11]ER51955 [13]ER57711 [15]ER64871 ///
		 || WnyrsEmp [74]V3610 [75]V4110 [76]V4989 [77]V5574 [78]V6123 [79]V6720 [80]V7353 [81]V8005 [82]V8629 [83]V9315 [84]V10962 [85]V12102 [86]V13531 ///
					 [87]V14578 [88]V16052 [89]V17449 [90]V18780 [91]V20080 [92]V21386 [93]V23243 [94]ER3915 [95]ER6785 [96]ER9031 [97]ER11809 [99]ER15886 ///
					 [01]ER19947 [03]ER23384 [05]ER27348 [07]ER40523 [09]ER46500 [11]ER51861 [13]ER57601 [15]ER64732  /// 						 
		 || hHrsYr   [68]V47 [69]V465 [70]V1138 [71]V1839 [72]V2439 [73]V3027 [74]V3423 [75]V3823 [76]V4332 [77]V5232 ///
				     [78]V5731 [79]V6336 [80]V6934 [81]V7530 [82]V8228 [83]V8830 [84]V10037 [85]V11146 [86]V12545 [87]V13745 ///
					 [88]V14835 [89]V16335 [90]V17744 [91]V19044 [92]V20344 [93]V21634 [94]ER4096 [95]ER6936 [96]ER9187 ///
					 [97]ER12174 [99]ER16471 [01]ER20399 [03]ER24080 [05]ER27886 [07]ER40876 [09]ER46767 [11]ER52175 [13]ER57976 [15]ER65156 ///
		 || wHrsYr   [68]V53 [69]V475 [70]V1148 [71]V1849 [72]V2449 [73]V3035 [74]V3431 [75]V3831 [76]V4344 [77]V5244 ///
					 [78]V5743 [79]V6348 [80]V6946 [81]V7540 [82]V8238 [83]V8840 [84]V10131 [85]V11258 [86]V12657 [87]V13809 ///
					 [88]V14865 [89]V16365 [90]V17774 [91]V19074 [92]V20374 [93]V21670 [94]ER4107 [95]ER6947 [96]ER9198 ///
					 [97]ER12185 [99]ER16482 [01]ER20410 [03]ER24091 [05]ER27897 [07]ER40887 [09]ER46788 [11]ER52196 [13]ER57997 [15]ER65177 ///
		 || hHrWage  [68]V337 [69]V871 [70]V1567 [71]V2279 [72]V2906 [73]V3275 [74]V3695 [75]V4174 [76]V5050 [77]V5631 [78]V6178 ///
					 [79]V6771 [80]V7417 [81]V8069 [82]V8693 [83]V9379 [84]V11026 [85]V12377 [86]V13629 [87]V14676 [88]V16150 ///
					 [89]V17536 [90]V18887 [91]V20187 [92]V21493 [94]ER4148 [95]ER6988 [96]ER9239 [97]ER12217 [99]ER16514 [01]ER20451 ///
					 [03]ER24137 [05]ER28003 [07]ER40993 [09]ER46901 [11]ER52309 [13]ER58118 [15]ER65315 ///
		 || wHrWage  [68]V338 [69]V873 [70]V1569 [71]V2281 [72]V2908 [73]V3277 [74]V3697 [75]V4176 [76]V5052 [77]V5632 [78]V6179 [79]V6772 ///
					 [80]V7418 [81]V8070 [82]V8694 [83]V9380 [84]V11027 [85]V12378 [86]V13630 [87]V14677 [88]V16151 [89]V17537 [90]V18888 ///
					 [91]V20188 [92]V21494 [94]ER4149 [95]ER6989 [96]ER9240 [97]ER12218 [99]ER16515 [01]ER20452 [03]ER24138 [05]ER28004 [07]ER40994 [09]ER46902 [11]ER52310 [13]ER58119 [15]ER65316 ///
		 || hLabInc	 [68]V74 [69]V514 [70]V1196 [71]V1897 [72]V2498 [73]V3051 [74]V3463 [75]V3863 [76]V5031 [77]V5627 [78]V6174 [79]V6767 [80]V7413 ///
					 [81]V8066 [82]V8690 [83]V9376 [84]V11023 [85]V12372 [86]V13624 [87]V14671 [88]V16145 [89]V17534 [90]V18878 [91]V20178 [92]V21484 ///
					 [93]V23323 [94]ER4140 [95]ER6980 [96]ER9231 [97]ER12080 [99]ER16463 [01]ER20443 [03]ER24116 [05]ER27931 [07]ER40921 [09]ER46829 [11]ER52237 [13]ER58038 [15]ER65216 ///
		 || hXtraJobInc [93]V21801 [94]ER4138 [95]ER6978 [96]ER9229 [97]ER12212 [99]ER16509 [01]ER20441 [03]ER24131 [05]ER27927 [07]ER40917 [09]ER46825 [11]ER52233 [13]ER58034 [15]ER65212 ///
		 || wLabInc  [68]V75 [69]V516 [70]V1198 [71]V1899 [72]V2500 [73]V3053 [74]V3465 [75]V3865 [76]V4379 [77]V5289 [78]V5788 [79]V6398 [80]V6988 [81]V7580 ///
					 [82]V8273 [83]V8881 [84]V10263 [85]V11404 [86]V12803 [87]V13905 [88]V14920 [89]V16420 [90]V17836 [91]V19136 [92]V20436 [93]V23324 ///
					 [94]ER4144 [95]ER6984 [96]ER9235 [97]ER12082 [99]ER16465 [01]ER20447 [03]ER24135 [05]ER27943 [07]ER40933 [09]ER46841 [11]ER52249 [13]ER58050 [15]ER65244 ///
		 || Empl     [79]ER30293 [80]ER30323 [81]ER30353 [82]ER30382 [83]ER30411 [84]ER30441 [85]ER30474 [86]ER30509 [87]ER30545 [88]ER30580 [89]ER30616 [90]ER30653 [91]ER30699 ///
					 [92]ER30744 [93]ER30816 [94]ER33111 [95]ER33211 [96]ER33311 [97]ER33411 [99]ER33512 [01]ER33612 [03]ER33712 [05]ER33813 [07]ER33913 [09]ER34016 [11]ER34116 [13]ER34216  [15]ER34317 ///
		 || hMissELstYrE [76]V4504 [77]V5413 [78]V5902 [79]V6513 [80]V7116 [81]V7739 [82]V8401 [83]V9032 [84]V10557 [85]V11701 [86]V13101 [87]V14199 [88]V15253 ///
					     [89]V16754 [90]V18192 [91]V19492 [92]V20792 [93]V22569 [94]ER2188 [95]ER5187 [96]ER7283 [97]ER10199 [99]ER13330 [01]ER17353 ///				 
		 || hMissELstYrU [76]V4567 [77]V5469 [78]V5996 [79]V6569 [80]V7171 [81]V7819 [82]V8480 [83]V9117 [84]V10625 [85]V11798 [86]V13194 [87]V14290 ///
						[88]V15400 [89]V16915 [90]V18339 [91]V19639 [92]V20939 [93]V22735 [94]ER2433 [95]ER5432 [96]ER7528 [97]ER10438 [99]ER13583 [01]ER17635 ///
		 || wMissELstYrE [76]V4887 [77]V5518 [78]V6049 [79]V6609 [80]V7211 [81]V7902 [82]V8560 [83]V9210 [84]V10771 [85]V12064 [86]V13278 [87]V14372 [88]V15555 [89]V17073 ///
						 [90]V18494 [91]V19794 [92]V21094 [93]V22922 [94]ER2682 [95]ER5681 [96]ER7777 [97]ER10681 [99]ER13842 [01]ER17923 ///
		 || wMissELstYrU [76]V4951 [79]V6641 [80]V7243 [81]V7932 [82]V8587 [83]V9246 [84]V10825 [85]V12161 [86]V13362 [87]V14454 [88]V15702 [89]V17234 [90]V18641 ///
						[91]V19941 [92]V21241 [93]V23088 [94]ER2927 [95]ER5926 [96]ER8022 [97]ER10920 [99]ER14095 [01]ER18206 ///					
		 || hWhyJobLossU [69]V651 [70]V1332 [71]V2038 [72]V2638 [73]V3155 [74]V3571 [75]V4026 [76]V4556 [77]V5458 [78]V5986 [79]V6559 [80]V7161 [81]V7809 [82]V8470 ///
						 [83]V9107 [84]V10609 [85]V11764 [86]V13160 [87]V14256 [88]V15328 [89]V16843 [90]V18267 [91]V19567 [92]V20867 [93]V22655 [94]ER4034 [95]ER6874 ///
						 [96]ER9125 [97]ER12102 [99]ER13498 [01]ER17538 [03]ER21184 [05]ER25173 [07]ER36178 [09]ER42211 [11]ER47524 [13]ER53224  [15]ER60239 ///
		 || hWhyJobLossE1_ [68]V201 [69]V643 [70]V1282 [71]V1988 [72]V2586 [73]V3119 [74]V3534 [75]V3986 [76]V4490 [77]V5399 [78]V5890 [79]V6501 [80]V7104 [81]V7727 [82]V8391 [83]V9022 [84]V10539 [85]V11679 [86]V13079 [87]V14177 ///
		 || hWhyJobLossE2_ [88]V15240 [89]V16741 [90]V18179 [91]V19479 [92]V20779 [93]V22551 [94]ER4023 [95]ER6863 [96]ER9114 [97]ER12091 [99]ER13310 [01]ER17321 ///
		 || wWhyJobLossE [76]V4873 [79]V6600 [80]V7202 [81]V7893 [82]V8551 [83]V9201 [84]V10753 [85]V12042 [86]V13256 [87]V14350 [88]V15542 [89]V17060 [90]V18481 [91]V19781 [92]V21081 [93]V22904 [94]ER4054 [95]ER6894 [96]ER9145 ///
					     [97]ER12122 [99]ER13822 [01]ER17891 ///
		 || wWhyJobLossU [76]V4940 [79]V6631 [80]V7233 [81]V7922 [82]V8577 [83]V9236 [84]V10809 [85]V12127 [86]V13328 [87]V14420 [88]V15630 [89]V17162 [90]V18569 [91]V19869 ///
						 [92]V21169 [93]V23008 [94]ER4065 [95]ER6905 [96]ER9156 [97]ER12133 [99]ER14010 [01]ER18109 [03]ER21434 [05]ER25431 [07]ER36436 [09]ER42463 [11]ER47781 [13]ER53487 [15]ER60502 ///
		 || hUHrs1   [68]V49 [69]V469 [70]V1142 [71]V1843 [72]V2443 [73]V3031 [74]V3427 [75]V3827 ///
		 || hUHrs2	 [76]V4338 [77]V5240 [78]V5739 [79]V6344 [80]V6942 [81]V7538 [82]V8236 [83]V8838 [84]V10045 [85]V11153 [86]V12552 [87]V13752 [88]V14842 [89]V16342 [90]V17751 [91]V19051 [92]V20351 [93]V21638 ///
		 || hUWksE	 [94]ER2191 [95]ER5190 [96]ER7286 [97]ER10201 [99]ER13332 [01]ER17356 ///
		 || hUWksU   [94]ER2436 [95]ER5435 [96]ER7531 [97]ER10440 [99]ER13585 [01]ER17638 ///
		 || hWksU    [03]ER21320 [05]ER25309 [07]ER36314 [09]ER42341 [11]ER47654 [13]ER53354 [15]ER60369 ///
		 || wUHrs    [76]V4727 [77]V5252 [78]V5751 [79]V6356 [80]V6954 [81]V7548 [82]V8246 [83]V8848 [84]V10139 [85]V11265 [86]V12664 [87]V13816 [88]V14872 [89]V16372 [90]V17781 [91]V19081 [92]V20381 [93]V21674 ///
		 || wUWksE   [94]ER2685 [95]ER5684 [96]ER7780 [97]ER10683 [99]ER13844 [01]ER17926 ///
		 || wUWksU	 [94]ER2930 [95]ER5929 [96]ER8025 [97]ER10922 [99]ER14097 [01]ER18209 ///
		 || wWksU    [03]ER21570 [05]ER25567 [07]ER36572 [09]ER42593 [11]ER47911 [13]ER53617 [15]ER60632 ///
		 || hUnionE  [76]V4478 [77]V5382 [78]V5877 [79]V6495 [80]V7098 [81]V7709 [82]V8377 [83]V9008 [84]V10458 [85]V11649 [86]V13052 [87]V14152 [88]V15160 [89]V16661 [90]V18099 [91]V19399 [92]V20699 ///
					 [93]V22454 [94]ER2079 [95]ER5078 [96]ER7174 [97]ER10089 [99]ER13213 [01]ER17224 [03]ER21150 [05]ER25138 [07]ER36143 [09]ER42178 [11]ER47491 [13]ER53191 [15]ER60206 ///
		 || wUnionE  [76]V4861 [79]V6594 [80]V7196 [81]V7882 [82]V8541 [83]V9191 [84]V10676 [85]V12012 [86]V13231 [87]V14327 [88]V15462 [89]V16980 [90]V18401 [91]V19701 [92]V21001 [93]V22807 ///
					 [94]ER2573 [95]ER5572 [96]ER7668 [97]ER10571 [99]ER13725 [01]ER17794 [03]ER21400 [05]ER25396 [07]ER36401 [09]ER42430 [11]ER47748 [13]ER53454 [15]ER60469 ///
		 || tFamInc  	[68]V81 [69]V529 [70]V1514 [71]V2226 [72]V2852 [73]V3256 [74]V3676 [75]V4154 [76]V5029 [77]V5626 [78]V6173 [79]V6766 ///
						[80]V7412 [81]V8065 [82]V8689 [83]V9375 [84]V11022 [85]V12371 [86]V13623 [87]V14670 [88]V16144 [89]V17533 [90]V18875 ///
						[91]V20175 [92]V21481 [93]V23322 [94]ER4153 [95]ER6993 [96]ER9244 [97]ER12079 [99]ER16462 [01]ER20456 [03]ER24099 ///
						[05]ER28037 [07]ER41027 [09]ER46935 [11]ER52343 [13]ER58152 [15]ER65349 ///						 
		 using Mdta , clear design(3)		 

save $InputDTAs_dir\jobloss, replace		 
***************************************************************************************************************************		
*Notes:
*   -wnyrsFT only asked of new heads and wives. Can be useful for wife who becomes head.

* Go long
	psid long
	xtset x11101ll wave
	tsfill
	
* Assign vars to appropriate person	

gen HH=(xsqnr==1)
gen HW=(xsqnr==2)		 
		 
*************************************************************************************************
*Coding Chunk 1: Job "intensity"; ie yearly hours
*------------------------------------------------------------------------------------------------
gen HrsYr1=hHrsYr if HH==1
replace HrsYr1=wHrsYr if HW==1
replace HrsYr1=. if HrsYr1>5840	
gen HrsYr=L.HrsYr1
drop HrsYr1

gen FTemp=(HrsYr>1599 & HrsYr<6000)
replace FTemp = . if HrsYr==0	 
gen Anyemp=(HrsYr>0 & HrsYr<6000)
*Chose part time as 500 hours per year roughly based on work allowance for those on SSDI
gen PTemp=(HrsYr>500 & HrsYr<1600)
replace PTemp = . if HrsYr==0	 

*************************************************************************************************
*Coding Chunk 2: Labor Income and Wage
*------------------------------------------------------------------------------------------------
*
	gen HrlyW =  hHrWage if HH==1
	replace HrlyW = wHrWage if HW==1
	
	gen LabInc =  hLabInc if HH==1
	replace LabInc = wLabInc if HW==1	
	
	replace tFamInc = 0 if tFamInc<100
	
	*(https://cps.ipums.org/cps/cpi99.shtml)
	
	gen CPI=.
	replace CPI=1.445 if wave==1993
	replace CPI=1.482 if wave==1994
	replace CPI=1.524 if wave==1995
	replace CPI=1.569 if wave==1996
	replace CPI=1.605 if wave==1997
	replace CPI=1.630 if wave==1998
	replace CPI=1.666 if wave==1999
	replace CPI=1.722 if wave==2000
	replace CPI=1.771 if wave==2001
	replace CPI=1.799 if wave==2002
	replace CPI=1.840 if wave==2003
	replace CPI=1.889 if wave==2004
	replace CPI=1.953 if wave==2005
	replace CPI=2.016 if wave==2006
	replace CPI=2.153 if wave==2008
	replace CPI=1.403 if wave==1992
	replace CPI=1.362 if wave==1991
	replace CPI=1.307 if wave==1990
	replace CPI=1.240 if wave==1989
	replace CPI=1.183 if wave==1988
	replace CPI=1.136 if wave==1987
	replace CPI=1.096 if wave==1986
	replace CPI=1.076 if wave==1985
	replace CPI=1.039 if wave==1984
	replace CPI=0.996 if wave==1983
	replace CPI=0.965 if wave==1982
	replace CPI=0.909 if wave==1981
	replace CPI=0.824 if wave==1980
	replace CPI=0.726 if wave==1979
	replace CPI=0.652 if wave==1978
	replace CPI=0.606 if wave==1977
	replace CPI=0.569 if wave==1976
	replace CPI=0.538 if wave==1975
	replace CPI=0.493 if wave==1974
	replace CPI=0.444 if wave==1973
	replace CPI=0.418 if wave==1972
	replace CPI=0.405 if wave==1971
	replace CPI=0.388 if wave==1970
	replace CPI=0.367 if wave==1969
	replace CPI=0.348 if wave==1968
	replace CPI=0.334 if wave==1967
	replace CPI=CPI/1.666
	replace CPI=1.245 if wave==2007
	replace CPI=1.287 if wave==2009
	replace CPI=1.309 if wave==2010
	replace CPI=1.350 if wave==2011
	replace CPI=1.377 if wave==2012
	replace CPI=1.399 if wave==2013
	replace CPI=1.420 if wave==2014
	replace CPI=1.420 if wave==2015
	

	
	*Wages are retrospective one year
	replace HrlyW=. if HrlyW>9990
	xtset x11101ll wave
	qby x11101ll:gen wage= F.HrlyW
	replace wage=. if wage>9990
	
	gen LabInc2 = LabInc
		drop LabInc
	qby x11101ll:gen LabInc= F.LabInc2
		drop LabInc2
		
	gen xtraJobInc2 = hXtraJobInc if HH==1
		drop hXtraJobInc
	qby x11101ll:gen xtraJobInc= F.xtraJobInc2
		drop xtraJobInc2		
	
	gen rwage= wage/CPI
	gen r2wage= HrlyW/CPI
	gen rFamInc = tFamInc/CPI

	*Deal with 1967/1968
		replace LabInc = 500 if (LabInc==1 & wave<1969)
		replace LabInc = 750 if (LabInc==2 & wave<1969) 
		replace LabInc = 1500 if (LabInc==3 & wave<1969)
		replace LabInc = 2500 if (LabInc==4 & wave<1969)
		replace LabInc = 4000 if (LabInc==5 & wave<1969)
		replace LabInc = 6000 if (LabInc==6 & wave<1969)
		replace LabInc = 8000 if (LabInc==7 & wave<1969)
		replace LabInc = . if ((LabInc>7 | LabInc==0) & wave<1969)	
	*Deflate
		replace LabInc = (LabInc/CPI)
		replace xtraJobInc = (xtraJobInc/CPI) 
	
	*Top Code
		gen top = (99999/90.93)*100 - 1	
		replace LabInc = . if (LabInc==0 | LabInc>top)
		replace xtraJobInc =. if xtraJobInc>9000000
		
	drop CPI  HrlyW r2* top tFamInc
*************************************************************************************************
*Coding Chunk 3: Current Employment Status
*		Note: prior to 1979, only have employment status for head. 
*			Can go back and get it if we need it, but we have years FT which should cover history.
*------------------------------------------------------------------------------------------------
*
gen EmpCat = Empl

	gen CurEmp=(EmpCat==1)
	gen Emp=(EmpCat==1)
	replace Emp = . if (EmpCat>3 | EmpCat==0)
	gen CurTempLayoff=(EmpCat==2)
	gen CurUnemp=(EmpCat==3)
	gen CurRet=(EmpCat==4)
	gen CurDisable=(EmpCat==5)
	gen CurHousewife=(EmpCat==6)
	
	*Replace missing with .
	foreach var of varlist CurEmp-CurHousewife {
		replace `var'=. if (EmpCat==0 | EmpCat>6)
	}
	
	drop EmpCat Empl
	
*************************************************************************************************
*Coding Chunk 4: Unemployment
*	*Need to adjust to current year
*------------------------------------------------------------------------------------------------
*Whether unemployed LAST year
	*Covers through 2001
gen ULstYrCat=hMissELstYrE if HH==1
	replace ULstYrCat=hMissELstYrU if HH==1 & ULstYrCat==.
	replace ULstYrCat=wMissELstYrU if HW==1 & ULstYrCat==.
	replace ULstYrCat=wMissELstYrE if HW==1 & ULstYrCat==.

gen ULstYr= 1 if (ULstYrCat==1)
	replace ULstYr=0 if (ULstYrCat==5 )

xtset x11101ll wave	
	gen AnyU=F.ULstYr
	
drop ULstYrCat hMiss* wMiss* 	

*-----------------	
*# wks unemployed: have hrs datqa for early period, weeks for later. Need to combine them
	*Hours unemployed constructed as weeks unemployed * 8. So divide by 8 to get days.
gen UHrsC = hUHrs1 if HH==1
	replace UHrsC = hUHrs2 if HH==1 & UHrsC==.
	replace UHrsC = wUHrs if HW==1 & UHrsC==.

	gen WksU_fromhrs = (UHrsC/8)/5

gen UWksC = hUWksE if HH==1
	replace UWksC = hUWksU if HH==1 & UWksC==.
	replace UWksC = wUWksE if HW==1 & UWksC==.
	replace UWksC = wUWksU if HW==1 & UWksC==.
	replace UWksC = hWksU if HH==1 & wave>2001
	replace UWksC = wWksU if HW==1 & wave>2001
	replace UWksC = . if UWksC>52
	
gen UWks = UWksC
	replace UWks = WksU_fromhrs if UWks==.
	
rename UWks  UWks1	
gen UWks = F.UWks1

*Now fill in indicator
	replace ULstYr =1 if (UWks1>0 & UWks1<53 & ULstYr==.)
	replace ULstYr =0 if (UWks1==0 & ULstYr==. )
	replace AnyU=F.ULstYr if AnyU==.
	 

	drop hUHrs* hUWks* wUWks* wUHrs* UWks1 UWksC UHrs* WksU_* wWksU hWksU

*************************************************************************************************
*Coding Chunk 5: Why Job Loss?
*	*Again this is LAST year
*	*Removed extra checks, but could add them back.
*------------------------------------------------------------------------------------------------
gen WhyJobLossC = hWhyJobLossU if HH==1
	replace WhyJobLossC = hWhyJobLossE1_ if HH==1 & WhyJobLossC==.
	replace WhyJobLossC = hWhyJobLossE2_ if HH==1 & WhyJobLossC==.
	replace WhyJobLossC = wWhyJobLossE if HW==1 & WhyJobLossC==.
	replace WhyJobLossC = wWhyJobLossU if HW==1 & WhyJobLossC==.

gen Fired=1 if F.WhyJobLossC==3
gen Fold=1 if F.WhyJobLossC==1
gen Quit=1 if F.WhyJobLossC==4
gen TempLoss=1 if F.WhyJobLossC==8

foreach var of varlist Fired Fold Quit TempLoss {
	replace `var' = 0 if ((Fired==1 | Fold==1 | Quit==1 | TempLoss==1) & `var'~=1)
}

drop hWhy* wWhy* WhyJobLossC
*************************************************************************************************
*Coding Chunk 6: Union job
*------------------------------------------------------------------------------------------------
gen Unionjob = 1 if (hUnionE==1 & HH==1)
	replace Unionjob = 1 if (wUnionE==1 & HW==1)
	replace Unionjob = 0 if ((wUnionE==5 & HW==1) | (hUnionE==5 & HH==1))

drop hUnion* wUnion*

*************************************************************************************************
*Coding Chunk 7: Experience: number of years FT
*------------------------------------------------------------------------------------------------
gen YrsFT = HnyrsFT if HH==1
	replace YrsFT = WnyrsFT if  HW==1 & YrsFT==.
	replace YrsFT = . if YrsFT>97 
	
gen YrsEmp = HnyrsEmp if HH==1
	replace YrsEmp = WnyrsEmp if  HW==1 & YrsEmp==.
	replace YrsEmp = . if YrsEmp>97 	
	

*Experienced worker clasiffied as more than 9 years
gen ExpWkr=(YrsFT>9 & YrsFT<70)


*in use
drop hHrWage-HW

save $InputDTAs_dir\jobloss, replace


