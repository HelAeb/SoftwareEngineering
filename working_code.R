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
swiss <- read.csv(data)
names(swiss)[names(swiss) == 'X'] <- 'Date'
# data variables:
#   Date = Dates, quarters
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
# 1. clean data I: remove all NA, make Date
# -----------------------------------------------------------------------------

# check if there are NA and remove them entirely from data set
swiss <- na.omit(swiss)


# make X as date format, use it as rownames and change the column-name "X" to "Date"
swiss$Date <- as.Date(as.yearqtr(as.character(swiss$Date),
                              format = "%Y-Q%q"))
rownames(swiss) <- swiss$Date


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
# 3. clean data II: stationarity
# -----------------------------------------------------------------------------

# list with log of data
#   create a data frame combining the ones without log and those with
swiss_log <- cbind(swiss[ , which(names(swiss) %in% no_log)],
                  log(swiss[ , -which(names(swiss) %in% no_log)])) # get log of all variables except for those defined as no_log
swiss_log <- swiss_log[, -which(names(swiss_log) == "Date")] # remove Dates (don't want to HP filter them)
#   make list of it to be able to apply HP filter on each variable itself
swiss_log2 <- as.list(swiss_log)


# use HP-filter to make data stationary, apply on each variable and save as list
hp_data <- lapply(swiss_log, hpfilter, freq = lambda)

# combine cycle data of HP filter into data frame
swiss_detrended <- as.data.frame(sapply(hp_data, `[`, "cycle"))
# add Date to data frame again for easier plots
swiss_detrended <- cbind(Date = swiss$Date, swiss_detrended)










