# Set the directory for R
#setwd("/home/user/R/SLSCP")

##############################################################################
# Turn off global warning messages 
turnOffWarningMessages <- getOption("warn")
options(warn = -1)

install.packages("dplyr")
#install.packages("sqldf")

options(warn = turnOffWarningMessages)
