#  freqSum

> This package allows you to easily perform frequency tabulations and summary statistics.


<img src="https://github.com/stainlessfish/rtfcreator/blob/main/rtfcreateor_megane.png" alt="pharmaforest" width="300" height="300"> 
---

---
## Overview

This package provides a streamlined and efficient toolkit for descriptive statistical analysis, offering two macros for distinct purposes:

- **Ease of Use**
  - Quickly perform standard statistical summaries with minimal code.
  - Enables both frequency tabulations and summary statistics in one package.

- **Two Targeted Macros**
  - **`freqStat`**
    - Generates frequency tabulations.  
    - Ideal for summarizing categorical variables and checking data distribution at a glance.
  - **`summaryStat`**
    - Computes summary statistics such as mean, standard deviation, minimum, and maximum.  
    - Designed for efficient exploration of continuous variables.

- **Flexible and Practical**
  - Designed for both academic and business contexts, including research reports and data analysis workflows.
  - Reduces repetitive coding—perfect for routine analysis tasks and rapid prototyping.

- **Why It Matters**
  - Saves time and reduces manual coding errors.
  - Combines common statistical needs into a single, cohesive package.
  - Ideal for both seasoned analysts and those new to statistical programming.


---


##  Version history

0.1.0(26August2025) : Initial version

---

## Parameters for `freqStat`

| Parameter   | Description                                                                 |
|-------------|-----------------------------------------------------------------------------|
| inDs        | Input dataset (e.g. ADSL).                                                  |
| outDs       | Output dataset (default: `FreqStat1`).                                      |
| sortNum     | Sort order in the output dataset (default: 1).                              |
| label       | Label for the analysis variable (e.g. Sex).                                 |
| grpNum      | Number of treatment groups (e.g. 3).                                        |
| trtGrp      | Treatment-group variable (e.g. TRT01PN).                                    |
| trgtVar     | Analysis variable (e.g. SEXN).                                              |
| trgtVarTyp  | Type of analysis variable (`N` = numeric, `C` = character).                 |
| trgtValue   | Values of the analysis variable (e.g. `%str(1,2,9)`).                       |
| trgtLabel   | Labels corresponding to `trgtValue` (e.g. `%str('Male','Female','Unknown')`). |
| debug       | Debug mode: `Y` = keep temporary datasets, `N` = delete them.               |


## Parameters for `summaryStat`

| Parameter   | Description                                                                 |
|-------------|-----------------------------------------------------------------------------|
| inDs        | Input dataset (e.g. ADSL).                                                  |
| sortNum     | Sort order in the output dataset (default: 1).                              |
| outDs       | Output dataset (default: `SummaryStat1`).                                   |
| grpNum      | Number of treatment groups (e.g. 3).                                        |
| trtGrp      | Treatment-group variable (e.g. TRT01PN).                                    |
| trgtVar     | Analysis variable (e.g. AGE).                                               |
| dcml        | Number of decimal places. If blank, detected automatically from `trgtVar`.  |
| label       | Label for the analysis variable (e.g. Age).                                 |
| debug       | Debug mode: `Y` = keep temporary datasets, `N` = delete them.               |


---

##  How to Use

### freqStat  -- ;
```sas
%FreqStat(inds=ADSL_dummy,sortNum=1, outds=sum01, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Sex),          trgtVar=SEX,    trgtVarTyp=C, trgtValue=%str('M','F','U'),              trgtLabel=%str('Male','Female','Unknown') );
%FreqStat(inds=ADSL_dummy,sortNum=3, outds=sum03, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Age Category), trgtVar=AGEGR1, trgtVarTyp=C, trgtValue=%str('<40','>=40'),             trgtLabel=%str('<40','>=40') );
%FreqStat(inds=ADSL_dummy,sortNum=4, outds=sum04, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Stage),        trgtVar=STAGEN, trgtVarTyp=N, trgtValue=%str(1,2,3,4,5),                trgtLabel=%str('Stage I','Stage IIa','Stage IIb','Stage III','Stage IV') );
%FreqStat(inds=ADSL_dummy,sortNum=5, outds=sum05, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Study Status), trgtVar=EOTSTT, trgtVarTyp=C, trgtValue=%str('ONGOING','DISCONTINUED'), trgtLabel=%str('Study Ongoing','Study Discontinued') );


```
<img width="1046" height="486" alt="image" src="https://github.com/user-attachments/assets/7ecf2dc5-968f-469c-8d2a-4d4097f296f7" />

---


### summaryStat  -- ;
```sas
%SummaryStat(inds=ADSL_dummy, sortNum=2, outds=sum02, grpNum=3, trtGrp=TRT01PN, label=%str(Age),         trgtVar=AGE);

```
<img width="1053" height="132" alt="image" src="https://github.com/user-attachments/assets/2316fc08-c454-4cdf-8cba-439a90b88aff" />

---



## What is SAS Packages?  
PharmaForest is a repository of SAS packages. These packages are built on top of **SAS Packages framework(SPF)**, which was developed by Bartosz Jablonski.  
For more information about SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).  
You can also find more SAS Packages(SASPACs) in [SASPAC](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)
### 1. Set-up SPF(SAS Packages Framework)
Firstly, create directory for your packages and assign a fileref to it.
~~~sas      
filename packages "\path\to\your\packages";
~~~
Secondly, enable the SAS Packages Framework.  
(If you don't have SAS Packages Framework installed, follow the instruction in [SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) to install SAS Packages Framework.)  
~~~sas      
%include packages(SPFinit.sas)
~~~  
### 2. Install SAS package  
Install SAS package you want to use using %installPackage() in SPFinit.sas.
~~~sas      
%installPackage(packagename, sourcePath=\github\path\for\packagename)
~~~
(e.g. %installPackage(ABC, sourcePath=https://github.com/XXXXX/ABC/raw/main/))  
### 3. Load SAS package  
Load SAS package you want to use using %loadPackage() in SPFinit.sas.
~~~sas      
%loadPackage(packagename)
~~~
### Enjoy😁
