/*** HELP START ***//*

/*************************************************************************
* Program:     FreqStat.sas
* Macro:       %FreqStat
*
* Purpose:     Computes counts and percentages of specified category values for a target variable across treatment groups.
*              Produces a table-ready dataset with one row per category, columns per group, and optional debug cleanup.
*
* Features:
*   - Frequency and percent by treatment group for selected values
*   - Supports numeric or character target variables (type-aware)
*   - Built-in parameter validation (type mismatch, label/value count checks)
*   - Table-ready transposed output with group denominators handled per group
*   - Debug option to keep or delete intermediate datasets
*
* Parameters:
*   inDs=  Input dataset (e.g., ADSL)
*   outDs= Output dataset name (default: FreqStat1)
*   
*   sortNum= Sort order number for output dataset (default: 1)
*   label=   Label for the analysis variable (e.g., Sex)
*   
*   grpNum= Number of treatment groups (e.g., 3)
*   trtGrp= Treatment-group variable (e.g., TRT01PN)
*   
*   trgtVar=    Target (categorical) variable to summarize (e.g., SEXN)
*   trgtVarTyp= Type of target variable: N (numeric) or C (character) (default: N)
*   trgtValue=  Comma-separated list of target values to tabulate (e.g., 1,2,9)
*   trgtLabel=  Comma-separated list of labels corresponding to trgtValue (e.g., 'Male','Female','Unknown')
*   
*   debug= Debug option to keep/delete temporary datasets (Y/N, default: N)
*   
* Example usage:
******************************
* Example :
* 
%FreqStat(inds=ADSL,sortNum=1, outds=sum01, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Sex),          trgtVar=SEX,    trgtVarTyp=C, trgtValue=%str('M','F','U'),              trgtLabel=%str('Male','Female','Unknown') );
%FreqStat(inds=ADSL,sortNum=3, outds=sum03, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Age Category), trgtVar=AGEGR1, trgtVarTyp=C, trgtValue=%str('<40','>=40'),             trgtLabel=%str('<40','>=40') );
%FreqStat(inds=ADSL,sortNum=4, outds=sum04, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Stage),        trgtVar=STAGEN, trgtVarTyp=N, trgtValue=%str(1,2,3,4,5),                trgtLabel=%str('Stage I','Stage IIa','Stage IIb','Stage III','Stage IV') );
%FreqStat(inds=ADSL,sortNum=5, outds=sum05, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Study Status), trgtVar=EOTSTT, trgtVarTyp=C, trgtValue=%str('ONGOING','DISCONTINUED'), trgtLabel=%str('Study Ongoing','Study Discontinued') );
* 
* Author:     Hiroki Yamanobe
* Date:       2025-08-26
* Version:    0.1*

*//*** HELP END ***/


%macro FreqStat(
    inDs=                                /* Input datasets (e.g.ADSL) */
   ,outDs=FreqStat1                          /* Output datasets */
   ,sortNum=1                                /* Sort order in the output datasets */
   ,label=                        /* Label for the analysis variable (e.g.Sex)*/
   ,grpNum=                                 /* Number of treatment groups (e.g.3) */
   ,trtGrp=                           /* Treatment-group variable (e.g.TRT01PN)*/
   ,trgtVar=                             /* Analysis variable (e.g.SEXN)*/
   ,trgtVarTyp=                             /* Type of analysis variable (e.g., N = numeric, C = character) */
   ,trgtValue=                    /* Values of the analysis variable (e.g.%str(1,2,9))*/
   ,trgtLabel=                     /* Labels corresponding to trgtValue (e.g.%str('Male','Female','Unknown'))*/
   ,debug=N                                  /* Debug mode: Y = keep temporary datasets, N = delete them. */  
);

%** Check parameter;
data _null_;
  if "&trgtVarTyp." eq "N" and compress("&trgtValue.",",") ne cats(input(compress("&trgtValue.",","), ?? best.)) then do;
    put "WAR" "NING: trgtValue is not numeric value when trgtVarTyp=N. &trgtValue.";
    call symputx("_abort",1,"L");
  end;
  else if "&trgtVarTyp." eq "C" and compress("&trgtValue.",",") eq cats(input(compress("&trgtValue.",","), ?? best.)) then do;
    put "WAR" "NING: trgtValue is not character value when trgtVarTyp=C. &trgtValue.";
    call symputx("_abort",1,"L");
  end;
  else if %sysfunc(count(&trgtValue.,%str(,))) ne %sysfunc(count(&trgtLabel.,%str(,))) then do;
    put "WAR" "NING: trgtValue and trgtLabel have a different number of commas.";
    call symputx("_abort",1,"L");
  end;
  else call symputx("_abort",0,"L");
  stop;
run;
%if &_abort. eq 1 %then %abort;

data _m1_import;
  set &inds.;
  %** get num;
  length trgtValue $500.;
  trgtValue=cats("&trgtValue.");
  VALNUM=count("&trgtValue.",",")+1;

  VALC =cats(&trgtVar.);
  do i=1 to VALNUM;
    if      "&trgtVarTyp." eq "C" then do;
      if cats("'",VALC,"'") eq scan("&trgtValue.",i,",") then VAL=i;
    end;
    else if "&trgtVarTyp." eq "N" then do;
      if cats("'",VALC,"'") eq cats("'",scan("&trgtValue.",i,","),"'") then VAL=i;
    end;
  end;


  TRTN=&trtGrp.;

  keep VALNUM VALC VAL TRTN trgtValue;
run;

%** bignm;
proc sql noprint;
  select distinct TRTN
                  ,count(*)
    into: dummy  separated by ","
       ,: l_BIGN separated by ","

  from   _m1_import
  group by 1
  ;
quit;
%put &dummy.;
%put &=l_BIGN.;


%** summary;
data mcr_dummy;
  set _m1_import;
  if _n_ eq 1;
  do VAL=1 to VALNUM;
    do TRTN=3;
      output;
    end;
  end;
run;

proc summary data=_m1_import 
              classdata=mcr_dummy nway ;
  class VAL TRTN;
  output out=_m2_sum;
run;

%** tabulation;
proc transpose data=_m2_sum out=_m3_transpose;
  by VAL;
  id TRTN;
  var _FREQ_;
run;

data _m4_out;
  length out1-out%eval(&grpNum.+2)$200.;
  set _m3_transpose;
  by VAL;
  out1 = "&label.";
  if VAL ne 0 then out2 = choosec(VAL,&trgtLabel.);
  else do;
    put "NOTE: Exist Missing value.";
    delete;
  end;

  array a_var _1  -_&grpNum.;
  array a_bgn bn1 -bn&grpNum.;
  array a_out out3-out%eval(&grpNum.+2);
  do over a_var;
    a_bgn=input(scan("&l_BIGN.",_i_,","),best.);
    if a_var notin(.,0) then do; 
      _out_1 = cats(a_var);
      _out_2 = cats("(",put(round(a_var/a_bgn*100,0.1),5.1 -l), ')');
      if _out_2 eq '(100.0)' then _out_2='(100)';
      a_out=catx(" ",of _out_1-_out_2);
    end;
    else do; 
      a_out = "0"; 
    end;
  end;
run;

%** output result;
data &outds.;
  format num1 num2 out1-out%eval(&grpNum.+2);
  set _m4_out;
  num1=&sortNum.;
  num2=VAL;
  keep num1 num2 out1-out%eval(&grpNum.+2);
run;

%** delete temporary datasets;
%if &debug. ne Y %then %do;
proc delete lib=work data=_m1_import
                          _m2_sum
                          _m3_transpose
                          _m4_out
;
run;
%end;

%mend FreqStat;

