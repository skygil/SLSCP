# SLCSP
*** 
I have included the following files/folder in a zip file.   

* COMMENTS.md  
* data ( this is a folder with input files)  
  * plans.csv  
  * slscp.csv  
  * zips.csv  
  * output (an empty folder that'll be populated once the script runs)  
* slscpCode.R (the script that you'll run)  
  
You will want to extract these and put them in the directory of **/home/user**. Keep the subfolders in this zip file as they are called in the script. 

The file directory is set to **/home/user/R/SLSCP** in the script. If this needs to be changed, you will need to update the first line of code in the slscpCode.R script.



# Installing R
*** 
* First you will need to have R installed. If you do not have this program, you can install it from 
<https://www.r-project.org>  or from the command line.
You will need R version **3.3** or newer. The recommended version of R to use is, **4.3.0 (2023-04-21) -- "Already Tomorrow"**.

## R Packages
There are two main packages used, 'sqldf' and 'tidyverse', in order to use these packages, you'll need to have R version **3.3** or newer.

### Installing from command line:


Open command line 
run the following commands:

* `sudo apt update`    
* `sudo apt install r-base r-base-dev`  

The command line should now install R
Once done, run the  following command to grab the latest updates/versions.  

* `sudo apt upgrade r-base r-base-dev`  

# Running the file
*** 
1. Open up command line  
2. Change the directory to **/home/user/R/SLSCP**  
3. type `RScript slscpCode.R`
  
4. The file should run  
5. Once the file runs, the following output message will appear: *Script has successfully ran! Check the data/output folder for the output file 'Stdout'*  
6. Check the output file located in **R/SLSCP/data/output** for Stdout.csv  

