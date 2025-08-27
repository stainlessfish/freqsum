#  freqSum

> This package allows you to easily perform frequency tabulations and summary statistics.

<img width="300" height="300" alt="ChatGPT Image 2025年8月26日 20_01_48" src="https://github.com/user-attachments/assets/3bb0424d-e0ca-4c81-b486-29251681acce" />


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

0.1.0(27August2025) : Initial version

---

## `freqStat`

#### Purpose
Calculates counts and percentages of a specified categorical variable (e.g., sex or treatment group) across groups and outputs the results as a table-ready dataset.

#### Usage Flow
Specify the input dataset.
Provide the analysis variable (var) and the grouping variable (group).
Percent denominators are automatically derived from the treatment group (trtGrp).
Run the macro to obtain a clean output dataset with counts and percentages by category.


### Parameters 

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


###  How to Use

```sas
%FreqStat(inds=ADSL_dummy,sortNum=1, outds=sum01, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Sex),          trgtVar=SEX,    trgtVarTyp=C, trgtValue=%str('M','F','U'),              trgtLabel=%str('Male','Female','Unknown') );
%FreqStat(inds=ADSL_dummy,sortNum=3, outds=sum03, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Age Category), trgtVar=AGEGR1, trgtVarTyp=C, trgtValue=%str('<40','>=40'),             trgtLabel=%str('<40','>=40') );
%FreqStat(inds=ADSL_dummy,sortNum=4, outds=sum04, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Stage),        trgtVar=STAGEN, trgtVarTyp=N, trgtValue=%str(1,2,3,4,5),                trgtLabel=%str('Stage I','Stage IIa','Stage IIb','Stage III','Stage IV') );
%FreqStat(inds=ADSL_dummy,sortNum=5, outds=sum05, grpNum=3, trtGrp=TRT01PN, label=%nrstr(Study Status), trgtVar=EOTSTT, trgtVarTyp=C, trgtValue=%str('ONGOING','DISCONTINUED'), trgtLabel=%str('Study Ongoing','Study Discontinued') );


```
<img width="1046" height="486" alt="image" src="https://github.com/user-attachments/assets/7ecf2dc5-968f-469c-8d2a-4d4097f296f7" />

---




## `summaryStat`

#### Purpose
Generates summary statistics (N, mean, SD, median, min, max) for a specified analysis variable across treatment groups. The macro outputs a table-ready dataset with customizable decimal precision, labels, and optional debug output.

#### Usage Flow
Specify the input dataset.
Provide the analysis variable and the grouping variable (e.g., treatment group).
Optionally set decimal precision, labels, and output dataset name.
Run the macro to obtain a transposed dataset with summary statistics by group.

### Parameters for `summaryStat`

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



### How to Use
#### Example1.
```sas
%SummaryStat(inds=ADSL_dummy, sortNum=2, outds=sum02, grpNum=3, trtGrp=TRT01PN, label=%str(Age), trgtVar=AGE);

```
<img width="1053" height="132" alt="image" src="https://github.com/user-attachments/assets/2316fc08-c454-4cdf-8cba-439a90b88aff" />

---


#### Example2. decimal place

**`dcml=`**  
Controls the number of decimal places for summary statistics.

- **Mean, SD, and Median** → displayed with **one additional decimal place** beyond the specified value  
  (e.g., `dcml=2` → output with 3 decimals).  
- **Min and Max** → displayed with exactly the specified number of decimal places.  
- If not specified, the macro attempts to automatically determine a suitable precision based on the input variable.  

This design ensures that descriptive measures like mean and SD provide slightly more precision than extreme values,  
which improves clarity in clinical summary tables.


```sas
%SummaryStat(inds=ADSL_dummy, sortNum=2, outds=sum02, grpNum=3, trtGrp=TRT01PN, label=%str(Age), trgtVar=AGE, dcml=1);

```

<img width="1070" height="113" alt="image" src="https://github.com/user-attachments/assets/c8b5a3f7-6de1-444b-9736-119673dc67ee" />


---


---

## What is SAS Packages?

The package is built on top of **SAS Packages Framework(SPF)** developed by Bartosz Jablonski.

For more information about the framework, see [SAS Packages Framework](https://github.com/yabwon/SAS_PACKAGES).

You can also find more SAS Packages (SASPacs) in the [SAS Packages Archive(SASPAC)](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)

### 1. Set-up SAS Packages Framework

First, create a directory for your packages and assign a `packages` fileref to it.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
filename packages "\path\to\your\packages";
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secondly, enable the SAS Packages Framework.
(If you don't have SAS Packages Framework installed, follow the instruction in 
[SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) 
to install SAS Packages Framework.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%include packages(SPFinit.sas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### 2. Install SAS package

Install SAS package you want to use with the SPF's `%installPackage()` macro.

- For packages located in **SAS Packages Archive(SASPAC)** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located in **PharmaForest** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, mirror=PharmaForest)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located at some network location run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, sourcePath=https://some/internet/location/for/packages)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (e.g. `%installPackage(ABC, sourcePath=https://github.com/SomeRepo/ABC/raw/main/)`)


### 3. Load SAS package

Load SAS package you want to use with the SPF's `%loadPackage()` macro.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%loadPackage(packageName)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### Enjoy!

---
