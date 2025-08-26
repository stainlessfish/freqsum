/*** HELP START ***//*

/*************************************************************************
* Program:     SummaryStat.sas
* Macro:       %SummaryStat
*
* Purpose:     This SAS macro generates summary statistics (N, mean, SD, median, min, max) for 
*              a specified analysis variable across treatment groups. 
*              It formats results into a table-ready dataset with customizable decimal precision, 
*              labels, and optional debug output.
*
* Features:
*   - Produces summary statistics (N, Mean, SD, Median, Min, Max) by treatment group
*   - Automatically detects or customizes decimal precision
*   - Outputs table-ready dataset in transposed format
*   - Allows custom analysis variable, label, groups, and output dataset name
*   - Debug option to keep or delete intermediate datasets
*
* Parameters:
*   inDs= Input dataset (e.g., ADSL)
*   sortNum= Sort order number for output dataset (default: 1)
*   outDs= Output dataset name (default: SummaryStat1)
*   grpNum= Number of treatment groups (e.g., 3)
*   trtGrp= Treatment group variable (e.g., TRT01PN)
*   trgtVar= Analysis variable for summary statistics (e.g., AGE)
*   dcml= Number of decimal places; if blank, automatically detected
*   label= Label for the analysis variable (e.g., "Age")
*   debug= Debug option to keep/delete temporary datasets (Y/N, default: N)
*
* Example usage:
******************************
* Example :
* 
%SummaryStat(inds=ADSL_dummy, sortNum=1, outds=sum01, grpNum=3, trtGrp=TRT01PN, label=%str(Age),         trgtVar=AGE);
* 
* Author:     Hiroki Yamanobe
* Date:       2025-08-26
* Version:    0.1*

*//*** HELP END ***/



%macro SummaryStat(
    inDs=             /* Input dataset (e.g.ADSL)*/
   ,sortNum=1             /* Sort order in the output dataset */
   ,outDs=SummaryStat1   /* Output dataset */
   ,grpNum=              /* Number of treatment groups (e.g. 3)*/
   ,trtGrp=        /* Treatment-group variable (e.g.TRT01PN)*/
   ,trgtVar=           /* Analysis variable (e.g.AGE)*/
   ,dcml=                 /* Number of decimal places (default: detected from trgtVar. If blank, use the maximum number of decimal places observed in trgtVar.) */
   ,label=             /* Label for the analysis variable (e.g. Age) */
   ,debug=N               /* Debug mode: Y = keep temporary datasets, N = delete them. */  
);



%** import;
data _m1_import;
  set &inds.;
  VAR=&trgtVar.;
  TRTN=&trtGrp.;
  digit=lengthn(scan(cats(VAR),2,"."));

  keep VAR TRTN DIGIT;
run;

%** decimal;
proc sql noprint;
    select coalesce(&dcml., max(digit)) as digit
    into: l_digit trimmed
    from   _m1_import
  ;
quit;
%put&=l_digit.;

%** summary;
proc sql noprint;
  create table dummy as
    select distinct TRTN
    from   _m1_import
  ;
quit;

proc summary data    =_m1_import
              classdata=dummy
              noprint nway exclusive;
  class TRTN;
  var VAR;
  output  out=_m2_sum
          n=
          mean=
          std=
          median=

          q1=
          q3=
          min=
          max= 
          /autoname;
run;

%** tabulations;
proc transpose data=_m2_sum out=_m3_transpose prefix=var;
  id TRTN;
  var VAR:;
run;

data _m4_out;
  length out1-out%eval(&grpNum.+2)$200.;
  set _m3_transpose;
  digit=&l_digit.;


  ITEM=upcase(scan(_NAME_,2,"_"));

  rnd0=input(cats("1e-",digit),   best.);
  rnd1=input(cats("1e-",digit+1), best.);
  fmt0=cats("16.",digit,  " -L");
  fmt1=cats("16.",digit+1," -L");

  out1=cats("&label.");

  select(ITEM);
    when("N")       do; num2=1; out2="n";        end;
    when("MEAN")    do; num2=2; out2="Mean";     end;
    when("STDDEV")  do; num2=3; out2="Mean (SD)";       end;
    when("MEDIAN")  do; num2=4; out2="Median";   end;
/*    when("Q1")      do; num2=7; out2='25%';      end;*/
/*    when("Q3")      do; num2=8; out2='[25%, 75%]';      end;*/
    when("MIN")     do; num2=5; out2="Min";      end;
    when("MAX")     do; num2=6; out2="[Min, Max]";      end;
    otherwise delete;
  end;

  retain       _smn1-_smn&grpNum. .;
  retain       out3-out%eval(&grpNum.+2) "";
  array a_smn  _smn1-_smn&grpNum.;
  array a_out out3-out%eval(&grpNum.+2);
  array a_var var1-var9;
  do over a_out;
    if  missing(a_var) then call missing(of a_var);
    if ^missing(a_var) then do;
      if      ITEM in ("N")                                then a_out=put(a_var, best. -L);
      else if ITEM in ("MEAN")                             then a_out=putn(round(a_var,rnd1), fmt1);
      else if ITEM in ("STDDEV")                           then a_out=catx(" ",a_out, cats("(",putn(round(a_var,rnd1), fmt1),")"));
      else if ITEM in ("MEDIAN")                           then a_out=putn(round(a_var,rnd1), fmt1);
      else if ITEM in ("Q1")                               then a_out=putn(round(a_var,rnd1), fmt1);
      else if ITEM in ("Q3")                               then a_out=cats("[",catx(", ",a_out, putn(round(a_var,rnd1), fmt1)),"]");
      else if ITEM in ("MIN")                              then a_out=putn(round(a_var,rnd0), fmt0);
      else if ITEM in ("MAX")                              then a_out=cats("[",catx(", ",a_out, putn(round(a_var,rnd0), fmt0)),"]");

      %** Show '-' if small n = 0, 1, or 2. ;
      if      ITEM in ("N") then a_smn=a_var;
      if      ITEM in ("STDDEV") and a_smn in(0,1,2) then a_out=catx(" ", scan(a_out,1,"("), "(-)");
      if      ITEM in ("MEDIAN") and a_smn in(0,1,2) then a_out="-";
    end;
    else a_out="-";
  end;
  if ITEM in("N","STDDEV","MEDIAN","Q3","MAX");
run;

%** output result;
data &outds.;
format NUM1 NUM2 out1-out%eval(&grpNum.+2);
  set _m4_out;
  num1=&sortNum.;
keep NUM1 NUM2 out1-out%eval(&grpNum.+2);
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

%mend SummaryStat;

