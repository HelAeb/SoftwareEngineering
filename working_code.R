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



# Source function file (from wd)
source("./functions.R")

# Used packages in this analaysis
packageList <- c("ggplot2", "plyr", "zoo", "mFilter", "stats", "tseries",
                 "xtable", "reshape2", "vars", "gridExtra")

# Install and/or load all needed packages
invisible(GetPackages(packageList))



# -----------------------------------------------------------------------------
# 0. load data
# -----------------------------------------------------------------------------

# load data set containing siwss data
swiss <- read.csv("DataSwiss.csv")
# data variables:
#   X = Dates, quarters
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



# -----------------------------------------------------------------------------
# 1. clean data 
# -----------------------------------------------------------------------------

# check if there are NA and remove them entirely from data set
swiss <- na.omit(swiss)


# make X as date format, use it as rownames and change the column-name "X" to "Date"
swiss$X <- as.Date(as.yearqtr(as.character(swiss$X),
                              format = "%Y-Q%q"))
rownames(swiss) <- swiss$X
names(swiss)[names(swiss) == 'X'] <- 'Date'


# -----------------------------------------------------------------------------
# 2. first look at data 
# -----------------------------------------------------------------------------
# create long format for ggplot
swiss_long <- melt(swiss, id.vars = "Date")

# use the created function "white.theme.date.plot" to create ggplot with data on white background theme.
#   x-axis = Date, y-axis = value, line type = variables used

#   GDP
white.theme.date.plot(subset(swiss_long, (variable == "GDP")))

#   GDP_DEF
white.theme.date.plot(subset(swiss_long, (variable == "GDP_DEF")))

# money aggregates
white.theme.date.plot(subset(swiss_long, 
                             (variable == "MB") | 
                               (variable == "M1") | 
                               (variable == "M2") | 
                               (variable == "M3")))
#   CPI
white.theme.date.plot(subset(swiss_long, (variable == "CPI")))

#   interest rates (short and long run)
white.theme.date.plot(subset(swiss_long, (variable == "i10Y") | (variable == "i3M")))


# -----------------------------------------------------------------------------
# 3. stationarity
# -----------------------------------------------------------------------------











