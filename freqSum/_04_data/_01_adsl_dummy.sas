/*** HELP START ***//*

## Create dummy datasets

*//*** HELP END ***/

/* Generate ADSL */

/*
Copyright (c) [2025]  [Ryo Nakaya]
Copyright (c) [2025] [Hiroki Yamanobe]
This software includes modifications made by [Hroki yamanobe] to the original software licensed under the MIT License. 
Modified portions of this software are [addition of the TRT01PN variable and its processing logic]. 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

data ADSL_DUMMY;
length STUDYID  $10. SITEID $3. SUBJID $7. USUBJID $25. SEX $1. ARMCD $4. ARM $20.
	TRT01P $20. FASFL $1. STAGE $9. STAGEN 8. AGEGR1 $10. EOTSTT $15. AGE 8. ;
format TRTSDT TRTEDT DTHDT date9.;
call streaminit(123);
array SUBJNUM[5] _temporary_ (0 0 0 0 0); /* subject number per site */
/* 50 subjects */
do i = 1 to 50;
STUDYID = "STUDY001";
/* SITEID (001 - 005) */
SITE_INDEX = ceil(rand("uniform")*5);
SITEID = put(SITE_INDEX, z3.);
/* Count up subject number */
SUBJNUM[SITE_INDEX] + 1;
/* SUBJID, USUBJID */
SUBJID = cats(SITEID, "-", put(SUBJNUM[SITE_INDEX], z3.));
USUBJID = cats(STUDYID, "-", SUBJID);
SEX = ifc(mod(i,2)=0, "M", "F");
AGE = 20 + mod(i*7, 45);
AGEGR1 = ifc(.<AGE < 40, "<40", ">=40");
select (mod(i,3));
when (0) do; ARMCD = "A"; ARM = "Placebo"; end;
when (1) do; ARMCD = "B"; ARM = "Drug 10mg"; end;
when (2) do; ARMCD = "C"; ARM = "Drug 20mg"; end;
end;
TRT01P = ARM;
select(TRT01P);
when("Drug 10mg") TRT01PN=1;
when("Drug 20mg") TRT01PN=2;
when("Placebo")   TRT01PN=3;
end;
TRTSDT = '01JAN2024'd + i ;
TRTEDT = TRTSDT + 100 + 2*mod(i,20);
FASFL = ifc(rand("uniform") <= 0.1, "N", "Y");
select (mod(i,5));
when (0) do; STAGE = "Stage I"; STAGEN=1 ; end ;
when (1) do; STAGE = "Stage IIa"; STAGEN=2 ; end ;
	  when (2) do; STAGE = "Stage IIb" ; STAGEN=3 ; end ;
when (3) do; STAGE = "Stage III"; STAGEN=4 ; end ;
when (4) do; STAGE = "Stage IV"; STAGEN=5 ; end ;
end;
if mod(i,10)=0 then
DTHDT = TRTEDT + ceil(rand("uniform") * 30);
else DTHDT = .;
pct = rand("uniform");
if .<pct < 0.7 then EOTSTT = "ONGOING";
else if pct <= 1 then EOTSTT = "DISCONTINUED";
output;
end;
drop i pct site_index;
run;
