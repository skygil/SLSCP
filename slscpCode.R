# Set the directory for R
setwd("/home/user/R/SLSCP")

##############################################################################
# Turn off global warning messages 
turnOffWarningMessages <- getOption("warn")
options(warn = -1)

## If a package is installed, it will be loaded. If any 
## are not, the missing package(s) will be installed 
## from CRAN and then loaded.


## First specify the packages of interest
packages = c("sqldf","tidyverse") 

## Now load or install & load all
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      suppressPackageStartupMessages(library(x, character.only = TRUE))
    }
  }
)

##############################################################################
###### READ DATA
##############################################################################
# Read input files
plans <- read.csv("data/plans.csv")
slscp <- read.csv("data/slcsp.csv")
zips  <- read.csv("data/zips.csv")

##################################
# Functions
##################################

#Create a function to calculate 2nd lowest value
fnRate = function(x) {
  min(x[x != min(x)])  
}

# Function to convert numeric values to strings with a given number of 
#  decimal places, and convert NA to empty string
fnc = function(var, decimal.places) {
  var = sprintf(paste0("%1.",decimal.places,"f"), var)
  var[var=="NA"] = ""
  var
}
###########################
# Manipulate Data
###########################

# Create a rate/zip reference table. 
# Only include metal class silver and remove the plan_id and metal_level columns.
# Find unique values in the data set and remove duplicate data.

dfplans <- plans  %>%
  filter(metal_level == "Silver") %>%
  select(-plan_id,-metal_level) %>%
  arrange(state,rate_area) %>%
  distinct()

##############################################################################
# Data Aggregations / Manipulation
################################
# Create a table that grabs all the zip codes from slscp 
# and links them to zips. Exclude any zip codes not in the slscp file.

dfslscp <- inner_join(slscp, zips, by = 'zipcode')

######################## Aggregations #########################################
##########################################################################

# Counts each zip code and how many records there are per rate area
zipPerRA <-  dfslscp %>%
  group_by(zipcode,rate_area) %>%
  count(zipcode,name = 'zip_cnt') %>%
  as.data.frame()

#Identifies zip codes in multiple rate areas
zipMultiRA <-  zipPerRA %>%
  group_by(zipcode) %>%
  count(zipcode,name = 'zip_cnt') %>%
  filter(zip_cnt >1) %>%
  as.data.frame()

##############################
# Merges the dfslscp and dfplan dataframe to identify zipcodes, 
# rate areas and their rates.
zipsAndRate <- left_join(dfslscp %>% 
                            dplyr::select(zipcode,state,name,rate_area) 
                          ,dfplans 
                          ,by=c('state','rate_area')) %>%
                arrange(zipcode,name,rate_area,rate)

# Grabs the zip codes with 1 silver plan
zipsOneScp <-  zipsAndRate %>%
  group_by(state,name,zipcode) %>%
  count(zipcode,name = 'zip_cnt') %>%
  filter(zip_cnt < 2 & !zipcode %in% (zipMultiRA$zipcode)) %>%
  as.data.frame()

# Grabs all zip codes, and counts how many times they show up 
# by zip code, state, and county. 
# Excludes:
#   Zip codes with more than 1 rate area for a specific zip code
#   Zip codes with less than 2 silver plans

findZipsAndRates <-  zipsAndRate %>%
  group_by(state,name,zipcode) %>%
  count(zipcode,name = 'zip_cnt') %>%
  filter(!zipcode %in% (zipMultiRA$zipcode)
         & !zipcode %in% (zipsOneScp$zipcode)) %>%
  as.data.frame()


# findZipsAndRates join with Zips and Rates
#identifies zip codes that meet the criteria to identify the 
# lowest cost plan
zipRateScpCri <-  left_join(findZipsAndRates,
                         zipsAndRate %>% 
                           dplyr::select(zipcode,rate),
                         by = 'zipcode')



# Verify there's 31 unique zip codes
# sqldf("
#       select distinct zipcode
#       from zipRateScpCri 
#       order by zipcode
#       ")

#Calculate the 2nd lowest silver plan for zip codes that meet the criteria
CalScp <- zipRateScpCri %>%
  select(zipcode,state,name,rate) %>%
  group_by(state,name,zipcode) %>%
  mutate(rate = fnRate(rate))

# Create a df with just the zipcodes and 2nd lowest cost plan
stageSt <- sqldf("SELECT distinct zipcode, rate from CalScp C")


# Create Stdout and grab all zip codes from slscp, fill in the rates that meet 
# the criteria with the 2nd lowest silver cost plan. Then round the decimals 
# to two digits after the decimal point
Stdout <- left_join(slscp %>%
                      dplyr::select(zipcode) 
                      ,stageSt
                      ,by='zipcode') 

# Set the rate column to have 2 decimal points, even when there's a trailing 0.
# Remove all NA values.
Stdout$rate = mapply(fnc, Stdout$rate, 2)
  
##############################################################################
# Export data and put an output message
##############################################################################
# Export Stdout to a CSV file
write_csv(Stdout, file = "data/output/Stdout.csv")

#Print an output message for the user.
print("Script has successfully ran! Check the data/output folder for the output file 'Stdout'")

options(warn = turnOffWarningMessages)