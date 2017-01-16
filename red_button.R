# =============================================================================
# University of St.Gallen
# Course: HS16-7,610,1.00 Software Engineering for Economists
# Authors: Helena Aebersold, Divna Nikolic, Michèle Schoch
# Professor: Dr. Philipp Zahn
# Date: 16.01.2017
# =============================================================================

# =============================================================================
# - This file contains the "red button" and possible changes with new data,
#     it sources the working code
# =============================================================================



# -----------------------------------------------------------------------------
# 0. Preliminaries
# -----------------------------------------------------------------------------

# Clear environment
rm(list=ls())

# Set working directory
## Erklärung:
## Sys.info()[['login']] unten in die Konsole eingeben und den Output dieses Befehls
## in das unten vorbereitete Feld (zb: 'Feld_PhilippZahn') eingeben (vergesst die ' ' nicht, vgl. 'Helena Aebersold')
## danach gebt ihr eure Ordnerstruktur / working directory in das vorbereitete Feld ein
## wenn das gemacht ist, können wir alle in diesem file arbeiten, ohne dass wir jedes mal die Ordnerstruktur anpassen müssen
if (Sys.info()[['login']] == 'Helena Aebersold') {
  dir <- 'C:/Users/Helena Aebersold/Dropbox/HSG/Master/HS16/software_engineering_for_economists/SoftwareEngineering/'
} else if (Sys.info()[['login']] == 'Divna') {
  dir <- "C:/Users/Divna/Documents/Uni/Master/3. Semester/Kontextstudium/Software Engineering for Economists/Group Project/SoftwareEngineering/"
} else if (Sys.info()[['login']] == 'Michèle') {
  dir <- "C:/Users/MichÃ¨le/Documents/MAHS15/Software_Engineering_for_Economists/SoftwareEngineering"
} else if (Sys.info()[['login']] == 'Feld_PhilippZahn') {
  dir <- ""
} else {
  dir <- getwd()
}
setwd(dir)



# -----------------------------------------------------------------------------
# 1. Prerequisites for working code
#    - possible changes with new data set
# -----------------------------------------------------------------------------

#--------------------
# Saving plots in PDF
#--------------------

# Separate PDF files for graphs of raw data, detrended data, correlogram, IRF
#   T: separate PDF files
#   F: all plots saved in one PDF file
separate_pdf <- F



#--------------------
# Data set
#--------------------

# Name of data set
data_file <- "./DataSwiss.csv"
date <- "X" # variable indicating the dates -> to make sure it is called "Date" in analysis



#--------------------
# Data variables:
#--------------------

#   X = Dates (in quarters)
#   CPI = consumer price index
#   i10Y = long-run interest rates (10 years)
#   GDP = gross domestic product
#   GDP_DEF = GDP deflator
#   COM = commodity prices
#   i3M = short-run interest rates (3 Month Libor)
#   M1 = money aggregate 1
#   M2 = money aggregate 2
#   M3 = money aggregate 3
#   MB = money base
#   RER = real exchange rate



#--------------------
# Log of data and growth
#--------------------

# Variables in data which do NOT need to be logarithmized
no_log <- c("Date", "i10Y", "i3M", "RER")

# Variables which have to be taken as growth (e.g. CPI growth == inflation)
growth_variables <- c("CPI")

# How to name the variables after taken growth (e.g. CPI growth == inflation)
#   make sure to have the same length and order of the variables as in growth_variables!
growth_names <- c("INF")



#--------------------
# HP filter
#--------------------

# Define lambda for HP-filter
lambda <- 1600 # usually lambda = 1600 for quarterly data



#--------------------
# Correlations variables
#--------------------

# Number of lags/leads for correlogram
lag_corr <- 8

# Variable against which correlations will be computed (one variable only)
corr_core <- c("GDP")

# Variables correlated against corr_core
corr_variables <- c("MB", "M1", "M2", "M3")



#--------------------
# sVAR variables
#--------------------

# Variables entering the sVAR model
#   IMPORTANT: make sure to have the ordering of the variables correct!!!
svar_variables <- c("COM", "GDP", "INF", "M1", "i3M")

# Choose maximal lag for optimal lag in sVAR
max_lag_svar <- 8
## remark: optimal lags result will be printed in console,
##    which to chose can still be defined by chosing other information criteria

# Which information criteria to choose for estimations in sVAR
#   AIC, HQ, SC (= BIC) or FPE
# or put a number for lag
criteria <- "SC"

# Summary statistics of VAR estimates
#   T: print summary statistics of VAR estimates in console
#   F: don't print summary statistics of VAR estimates in console
summary_stat_var <- F


# Response and impulse for IRF, time ahead
#   variables have to be in the model!
response <- c("GDP", "INF")
impulse <- c("M1", "i3M")
n_ahead <- 20



# -----------------------------------------------------------------------------
# 2. Run working code
# -----------------------------------------------------------------------------

# Source the working code
source("./working_code.R")
