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

# calculate growth data (after log) if there are some required
#   function depends on length of variables-vector (with one variable it needs different syntax)
if (length(growth_variables) != 0 & length(growth_variables) > 1){
  data_growth <- as.data.frame(sapply(data[, which(names(data) %in% growth_variables)], growth))
  data_growth <- data_growth[, growth_variables] # order the columns correctly to be able to rename it
  colnames(data_growth) <- growth_names # rename the columns
} else if (length(growth_variables) == 1){
  data_growth <- as.data.frame(growth(data[, which(names(data) %in% growth_variables)]))
  colnames(data_growth) <- growth_names
}

# combine data_log with the growth data and remove Date (don't take HP filter of dates)
#   remark: due to growth calculations 1 data point lost
data_log <- cbind(data_log[-1, ], data_growth)
data_log <- data_log[, -which(names(data_log) == "Date")] 



# use HP-filter to make data stationary, apply on each variable and save as list
hp_data <- lapply(data_log, hpfilter, freq = lambda)

# combine cycle data of HP filter into data frame
data_detrended <- as.data.frame(sapply(hp_data, `[`, "cycle"))

# add Date to data frame again for easier plots (also create it as long format for ggplot)
data_detrended <- cbind(Date = data$Date[-1], data_detrended)
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

# computing correlogramm against GDP for each variable and putting all in data frame
ccf.data <- as.data.frame(cbind(lag = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$CPI.cycle, lags)$lag,
                                CPI = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$CPI.cycle, lags)$correlation,
                                i3M = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$i3M.cycle, lags)$correlation,
                                i10Y = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$i10Y.cycle, lags)$correlation,
                                COM = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$COM.cycle, lags)$correlation,
                                MB = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$MB.cycle, lags)$correlation,
                                M1 = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$M1.cycle, lags)$correlation,
                                M2 = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$M2.cycle, lags)$correlation,
                                M3 = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$M3.cycle, lags)$correlation,
                                RER = ccf.data.frame(data_detrended$GDP.cycle, data_detrended$RER.cycle, lags)$correlation))

# get specified data in red_button together in long format and plot with ggplot
  if (money_corr == T) {
  ccf.data.money <- melt(ccf.data[, c("lag", "MB", "M1", "M2", "M3")], id = "lag")
  money_corr.plot <- corr.plot(ccf.data.money$lag, ccf.data.money$value, ccf.data.money)
}
if (interest_corr == T) {
  ccf.data.interest <- melt(ccf.data[, c("lag", "i3M", "i10Y")], id = "lag")
  interest_corr.plot <- corr.plot(ccf.data.interest$lag, ccf.data.interest$value, ccf.data.interest)
}
if (priceexrate_corr == T) {
  ccf.data.priceexrate <- melt(ccf.data[, c("lag", "CPI", "COM", "RER")], id = "lag")
  priceexrate_corr.plot <- corr.plot(ccf.data.priceexrate$lag, ccf.data.priceexrate$value, ccf.data.priceexrate)
}
if (choice_corr == T) {
  ccf.data.choice <- melt(ccf.data[, c(corr_variables)], id = "lag")
  choice_corr.plot <- corr.plot(ccf.data.choice$lag, ccf.data.choice$value, ccf.data.choice)
}

# get PDF of plotted data




# -----------------------------------------------------------------------------
# 5. sVAR
# -----------------------------------------------------------------------------
# need detrended variable names to get data from detrended-matrix
#   change names of variables to be same as in that matrix
svar_variables_detrended <- paste(svar_variables, ".cycle", sep = "")

# create separate data frame with svar data
data_svar <- data_detrended[, which(names(data_detrended) %in% svar_variables_detrended)]
data_svar <- data_svar[, svar_variables_detrended] # make correct order (!!!!!!!!!)


# choose optimal lag
var_optimal_lag <- VARselect(data_svar, lag.max = max_lag, type = "both")
cat("optimal lags sVAR:", "\n") # print optimal lags in console even if file is sourced
print(var_optimal_lag$selection)


# VAR estimates with chosen lag criterion
criteria <- paste(criteria, "(n)", sep = "")
var_estimate <- VAR(data_svar,
                    p = var_optimal_lag$selection[criteria],
                    type = "both")

if (summary_stat_var == T){
  cat("\n", "\n", "summary statistics of VAR estimates:", "\n")
  print(summary(var_estimate))
}



# Cholesky decomposition
# create A-matrix with NA for those values which have to be estimated
a_matrix <- diag(length(svar_variables))
to_estimate <- rep(NA, length(which(lower.tri(a_matrix)) == T))
a_matrix[lower.tri(a_matrix)] <- to_estimate

# sVAR estimates
svar_estimate <- SVAR(var_estimate, Amat = a_matrix)




# IRF calculation
response <- paste(response, ".cycle", sep = "") # renaming for getting correct data
impulse <- paste(impulse, ".cycle", sep = "")
irf_calculations <- irf(svar_estimate,
    response = response,
    impulse = impulse,
    n.ahead = n_ahead)

# save IRF data in a data frame
irf <- as.data.frame(irf_calculations$irf)
upper <- as.data.frame(irf_calculations$Upper)
colnames(upper) <- paste(names(upper), ".upper", sep = "")
lower <- as.data.frame(irf_calculations$Lower)
colnames(lower) <- paste(names(lower), ".lower", sep = "")


irf_data <- cbind("lag" = c(0, seq(1:n_ahead)),
                  irf,
                  upper,
                  lower)


# make long format for ggplot
melt(irf_data, id.vars = "lag")


# plot
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
# end PDF for plots
# -----------------------------------------------------------------------------
# stop putting plots into the pdf file
dev.off()
