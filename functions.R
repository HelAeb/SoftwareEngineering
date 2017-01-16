# =============================================================================
# University of St.Gallen
# Course: HS16-7,610,1.00 Software Engineering for Economists
# Authors: Helena Aebersold, Divna Nikolic, Michèle Schoch
# Professor: Dr. Philipp Zahn
# Date: 16.01.2017
# =============================================================================

# =============================================================================
# FUNCTIONS FILE
# - This file contains all functions and is sourced by the script file (working code)
# =============================================================================



# -----------------------------------------------------------------------------
# 0. Preliminaries
# -----------------------------------------------------------------------------

# Function to check for packages and load missing ones
GetPackages <- function(requiredPackages) {
  # checks if the given packages are installed and loads the missing ones
  #
  # Args: 
  #   requiredPackages = a vector of packages that should be loaded
  # Returns:
  #   loads packages
  newPackages <- requiredPackages[!(requiredPackages %in% 
                                      installed.packages()[ ,"Package"])]
  if (length(newPackages) > 0) {
    cat("Loading missing packages:", newPackages)
    install.packages(newPackages)
  }
  sapply(requiredPackages, require, character.only=TRUE)
}



# -----------------------------------------------------------------------------
# 2. First look at data 
# -----------------------------------------------------------------------------

# Function returning a ggplot on white background, where the Dates are on the x-axis
#   and the values are on the y-axis, line types are according to the variables
white.theme.date.plot <- function(data, title){
  # returns a ggplot with white background theme
  #
  # Args: 
  #   data = data set in long format, containing the columns "Date", "value" and "variable"
  # Returns:
  #   ggplot on white background, Date on x-axis and values of the variable on y-axis 
  #   the line type is according to the variables
  plot <- ggplot(data = data,
                 aes(x = Date, y = value, linetype = variable)) +
    geom_line() +
    scale_linetype("") +
    theme_bw() + 
    theme(plot.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.key = element_blank(),
          axis.title.y = element_blank()) +
    theme(panel.border= element_blank()) +
    theme(axis.line.x = element_line(color="black"),
          axis.line.y = element_line(color="black")) +
    labs(title = title)
  return(plot)
}



# -----------------------------------------------------------------------------
# 3. clean data II: stationarity
# -----------------------------------------------------------------------------

# Function returning growth rates 
growth <- function(data){
  # calculates growth rate
  #
  # Args:
  #   data = data of which one wants to calculate the growth
  # Returns:
  #   growth rate of data
  first_diff <- diff(data)  / # take first difference
    data[-length(data)] * 100 # calculate growth rate
  first_diff # return results
}



# -----------------------------------------------------------------------------
# 4. Correlogramm: dynamic correlations
# -----------------------------------------------------------------------------

# Function returning correlation calculations
corr.data <- function(x, y, lags) {
  # returns the correlations (acf data of the ccf function)
  #
  # Args:
  #   x, y = time series data
  #   lags = number of lags and leads
  # Returns:
  #   the correlation data (acf) of the ccf function
  ccf.data <- ccf(x, y, lag.max = lags, type = "correlation", plot = F)
  correlation <- ccf.data$acf
  return(correlation)
}

# Function plotting dynamic correlogram
corr.plot <- function(data) {
  # returns dynamic correlation plot with white theme
  #
  # Args: 
  #   data = data set containing lag_lead and correlations
  # Returns:
  #   dynamic correlation with lag/lead on x-axis and cross correlations on y-axis
  plot <- ggplot(data = data,
                 aes(x = lag_lead, y = value, linetype = variable)) +
    geom_line() +
    scale_linetype("") +
    labs(x = "Lags", y = "Cross-correlation") +
    theme_bw() + 
    theme(plot.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.key = element_blank()) +
    theme(panel.border= element_blank()) +
    theme(axis.line.x = element_line(color="black"),
          axis.line.y = element_line(color="black")) +
  labs(title = paste("Dynamic Correlation with", corr_core, sep = " "))
  return(plot)
}



# -----------------------------------------------------------------------------
# 5. sVAR
# -----------------------------------------------------------------------------

# Function returning a ggplot of the IRF on white background, where the lags are on the x-axis 
#   and the values are on the y-axis, line types are according to the variables
white.theme.irf.plot <- function(data){
  # returns a ggplot with white background theme of the IRF
  #
  # Args: 
  #   data = data set in long format, containing the columns "Date", "value" and "variable"
  # Returns:
  #   ggplot on white background, lags on x-axis and values of the variable on y-axis
  #   the line type is according to the variables
  plot <- ggplot(data = data,
                 aes(x = lag, y = value)) +
    geom_line() +
    geom_hline(aes(yintercept = 0), col = "grey") +
    scale_linetype("") +
    theme_bw() + 
    theme(plot.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.key = element_blank(),
          axis.title.y = element_blank()) +
    theme(panel.border= element_blank()) +
    theme(axis.line.x = element_line(color="black"),
          axis.line.y = element_line(color="black")) +
    scale_x_continuous(expand = c(0, 0)) +
    labs(title = paste("IRF of", as.character(unique(data$variable)), sep = " "))
  return(plot)
}
