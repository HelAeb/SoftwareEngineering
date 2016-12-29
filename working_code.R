# =============================================================================
# University of St.Gallen
# Course: HS16-7,610,1.00 Software Engineering for Economists
# Authors: Helena Aebersold, Divna Nikolic, Michèle Schoch
# Professor: Dr. Philipp Zahn
# Date: 28.12.2016
# =============================================================================

# =============================================================================
# SCRIPT FILE
# - This File contains the working code and is sourced by the red button file
# =============================================================================

# -----------------------------------------------------------------------------
# start PDF for plots
# -----------------------------------------------------------------------------
# save all plots in one pdf
if (separate_pdf == F){
  pdf("Plots.pdf")
}



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

# load data set
data <- read.csv(data_file)
names(data)[names(data) == date] <- "Date" # make sure the variable Date is called so



# -----------------------------------------------------------------------------
# 1. clean data I: remove all NA, Date format for dates
# -----------------------------------------------------------------------------

# check if there are NA and remove them entirely from data set
data <- na.omit(data)


# make X as date format, use it as rownames
data$Date <- as.Date(as.yearqtr(as.character(data$Date),
                              format = "%Y-Q%q"))
rownames(data) <- data$Date


# -----------------------------------------------------------------------------
# 2. first look at data 
# -----------------------------------------------------------------------------
# create long format for ggplot
data_long <- melt(data, id.vars = "Date")


# use the created function "white.theme.date.plot" to create ggplot with data on white background theme.
#   x-axis = Date, y-axis = value, line type = variables used

# plot for each variable in the data set
all_variables_raw <- as.character(unique(data_long$variable))
if (separate_pdf == T){ # if want to have separate PDF files, create "RawData.pdf" with these plots
  pdf("RawData.pdf")
  for (i in 1:length(all_variables_raw)){
    plot <- white.theme.date.plot(subset(data_long, variable == all_variables_raw[i]), title = "raw data")
    print(plot)
  }
  dev.off()
} else { # else print plots; they are added to the overall plot-PDF
  for (i in 1:length(all_variables_raw)){
    plot <- white.theme.date.plot(subset(data_long, variable == all_variables_raw[i]), title = "raw data")
    print(plot)
  }
}




# -----------------------------------------------------------------------------
# 3. clean data II: stationarity
# -----------------------------------------------------------------------------

# list with log of data
#   create a data frame combining the ones without log and those with
data_log <- cbind(data[ , which(names(data) %in% no_log)],
                  log(data[ , -which(names(data) %in% no_log)])) # get log of all variables except for those defined as no_log
data_log <- data_log[, -which(names(data_log) == "Date")] # remove Dates (don't want to HP filter them)


# use HP-filter to make data stationary, apply on each variable and save as list
hp_data <- lapply(data_log, hpfilter, freq = lambda)

# combine cycle data of HP filter into data frame
data_detrended <- as.data.frame(sapply(hp_data, `[`, "cycle"))

# add Date to data frame again for easier plots (also create it as long format for ggplot)
data_detrended <- cbind(Date = data$Date, data_detrended)
data_detrended_long <- melt(data_detrended, id.vars = "Date")


#------------------
# having a look at the detrended data
#------------------

# plot for each variable in the data set
all_variables_cycle <- as.character(unique(data_detrended_long$variable))
if (separate_pdf == T){ # if want to have separate PDF files, create "RawData.pdf" with these plots
  pdf("CycleData.pdf")
  for (i in 1:length(all_variables_cycle)){
    plot <- white.theme.date.plot(subset(data_detrended_long, variable == all_variables_cycle[i]), title = "cycle data")
    print(plot)
  }
  dev.off()
} else { # else print plots; they are added to the overall plot-PDF
  for (i in 1:length(all_variables_cycle)){
    plot <- white.theme.date.plot(subset(data_detrended_long, variable == all_variables_cycle[i]), title = "cycle data")
    print(plot)
  }
}







# -----------------------------------------------------------------------------
# 4. correlogramm
# -----------------------------------------------------------------------------











# -----------------------------------------------------------------------------
# 5. sVAR
# -----------------------------------------------------------------------------










# -----------------------------------------------------------------------------
# end PDF for plots
# -----------------------------------------------------------------------------
# stop putting plots into the pdf file
dev.off()
