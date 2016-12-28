# =============================================================================
# University of St.Gallen
# Course: HS16-7,610,1.00 Software Engineering for Economists
# Authors: Helena Aebersold, Divna Nikolic, Michèle Schoch
# Professor: Dr. Philipp Zahn
# Date: 28.12.2016
# =============================================================================

# =============================================================================
# SCRIPT FILE
# - This File contains the working code
# =============================================================================

# -----------------------------------------------------------------------------
# -1. Preliminaries
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



# Source function file (from wd)
source("./functions.R")

# Used packages in this analaysis
packageList <- c("ggplot2", "zoo", "mFilter", "stats", "tseries",
                 "xtable", "reshape2", "vars", "gridExtra")

# Install and/or load all needed packages
invisible(GetPackages(packageList))



 
