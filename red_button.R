# =============================================================================
# University of St.Gallen
# Course: HS16-7,610,1.00 Software Engineering for Economists
# Authors: Helena Aebersold, Divna Nikolic, Michèle Schoch
# Professor: Dr. Philipp Zahn
# Date: 28.12.2016
# =============================================================================

# =============================================================================
# - This File contains the "red button" and possible changes with new data
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
## in das unten vorbereitete Feld (zb: 'Feld_Divna') eingeben. (Vergesst die ' ' nicht, vgl. 'Helena Aebersold')
## Danach gebt ihr eure Ordnerstruktur / working directory in das vorbereitete Feld ein.
## Wenn das gemacht ist, können wir allen in diesem File arbeiten, ohne dass wir jedes mal 
## die Ordnerstruktur anpassen müssen.
if (Sys.info()[['login']] == 'Helena Aebersold') {
  dir <- 'C:/Users/Helena Aebersold/Dropbox/HSG/Master/HS16/software_engineering_for_economists/SoftwareEngineering/'
} else if (Sys.info()[['login']] == 'Feld_Divna') {
  dir <- ""
} else if (Sys.info()[['login']] == 'Feld_Michele') {
  dir <- ""
} else if (Sys.info()[['login']] == 'Feld_PhilippZahn') {
  dir <- ""
} else {
  dir <- getwd()
}
setwd(dir)


# -----------------------------------------------------------------------------
# 1. possible changes with new data set
#   prerequisites for working code
# -----------------------------------------------------------------------------

# name of data set
#   Variable "X" is the Date
data <- "./DataSwiss.csv"

# variables in data which do NOT need to be logarithmized
no_log <- c("Date", "i10Y", "i3M", "RER")

# define lambda for HP-filter
lambda <- 1600 # usually lambda = 1600 for quarterly data



# -----------------------------------------------------------------------------
# run working code
# -----------------------------------------------------------------------------

# source the working code
source("./working_code.R")
