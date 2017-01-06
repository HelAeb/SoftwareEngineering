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
if (separate_pdf == T){ # if want to have separate PDF files, create "CycleData.pdf" with these plots
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
# 4. correlogramm: dynamic correlations
# -----------------------------------------------------------------------------

# lag and leads
lag_lead <- -lag_corr:lag_corr

# rename to get correct data from detrended data frame
corr_core <- paste(corr_core, ".cycle", sep = "")
corr_variables <- paste(corr_variables, ".cycle", sep = "")

# calculate the correlations
correlations <- sapply(data_detrended[, which(names(data_detrended) %in% corr_variables)],
                        corr.data, # apply function corr.data which calculates and gets the correlations
                        x = data_detrended[corr_core], # correlated against the corr_core variable
                        lags = lag_corr)

# combine in data frame with lags
correlation_data <- cbind(lag_lead,
                          as.data.frame(correlations))
correlation_data_long <- melt(correlation_data, id.vars = "lag_lead")


# plots
if (separate_pdf == T){ # if want to have separate PDF files, create "IRF.pdf" with these plots
  pdf("Correlogram.pdf")
  plot <- corr.plot(correlation_data_long)
  print(plot)
  dev.off()
} else { # else print plots; they are added to the overall plot-PDF
  plot <- corr.plot(correlation_data_long)
  print(plot)
}




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
var_optimal_lag <- VARselect(data_svar, lag.max = max_lag_svar, type = "both")
cat("optimal lags sVAR:", "\n") # print optimal lags in console even if file is sourced
print(var_optimal_lag$selection)


# VAR estimates with chosen lag criterion or given lag
if (is.character(criteria) == T){
  criteria <- paste(criteria, "(n)", sep = "")
  var_estimate <- VAR(data_svar,
                    p = var_optimal_lag$selection[criteria],
                    type = "both")
} else {
  var_estimate <- VAR(data_svar,
                      p = criteria,
                      type = "both")
}



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
response_cycle <- paste(response, ".cycle", sep = "") # renaming for getting correct data
impulse_cycle <- paste(impulse, ".cycle", sep = "")
irf_calculations <- irf(svar_estimate,
    response = response_cycle,
    impulse = impulse_cycle,
    n.ahead = n_ahead)

# save IRF data in a data frame
irf <- as.data.frame(irf_calculations$irf)

irf_name <- c() # rename the columns
for (i in 1:length(impulse)){
  irf_name <- c(irf_name, paste(response, "after", impulse[i], "shock", sep = " "))
}
colnames(irf) <- irf_name


# add lags to data frame
irf_data <- cbind("lag" = c(0, seq(1:n_ahead)),
                  irf)


# make long format for ggplot
irf_data_long <- melt(irf_data, id.vars = "lag")


# IRF plots
if (separate_pdf == T){ # if want to have separate PDF files, create "IRF.pdf" with these plots
  pdf("IRF.pdf")
  for (i in 1:length(irf_name)){
    plot <- white.theme.irf.plot(subset(irf_data_long, variable == irf_name[i]))
    print(plot)
  }
  dev.off()
} else { # else print plots; they are added to the overall plot-PDF
  for (i in 1:length(irf_name)){
    plot <- white.theme.irf.plot(subset(irf_data_long, variable == irf_name[i]))
    print(plot)
  }
}





# -----------------------------------------------------------------------------
# end PDF for plots
# -----------------------------------------------------------------------------
# stop putting plots into the pdf file
dev.off()
