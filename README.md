# EM_FamilyBCs_PSID

PSID Data Replication Files  
v.12-5-2018; @A. Michaud  w/ K.Ellieroth
OG:v.6-5-2017; @A. Michaud  w/ K.Ellieroth

These files perform the empirical analysis on PSID data.
Variables available for download at simba.isr.umich.edu

***All files heavily commented, documentation self contained****

MAIN FILE
*MainDO_StartHere.do- The main file that performs statistical and regression analyses calling all subfiles

SUBFILES

Set-Up files. Load Mdta and clean
---------------------------------
*DemographicVars.do- generates demographic variables including married pairings
	+Generates InputDTAs\Demographics.dta
*jobloss.do- identifies employer separations and job history stats
	+Generates InputDTAs\jobloss.dta
*OccHist.do- calculates the occupational and industry histories of workers including longest job
	+Generates InputDTAs\occhist.dta & InputDTAs\occHist2000.dta

Analysis
---------------------------------
*MarriedMen.do- calculates state transitions and wage processes for the spouses of married women.
	+Generates many tables and figures.

OTHER INPUTS
*InputDTAs:
	occ1970_occ1990dd.dta, occ2000_occ1990dd.dta, cw_ind2000_ind1990ddx.dta : crosswalks from D. Dorn
	alm_ind1970_ind1990.dta : SOC crosswalks from D. Autor
*Mdta: Contains all PSID flat year + individual files available for download at simba.isr.umich.edu

NOTES:
*We use the PSIDuse package (Ulrich Kohler, 2009. "PSIDUSE: Stata module providing easy PSID access," Statistical Software Components
S457040, Boston College Department of Economics, revised 15 Jan 2015. <https://ideas.repec.org/c/boc/bocode/s457040.html>)
