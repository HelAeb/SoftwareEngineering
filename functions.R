# =============================================================================
# University of St.Gallen
# Course: HS16-7,610,1.00 Software Engineering for Economists
# Authors: Helena Aebersold, Divna Nikolic, Michèle Schoch
# Professor: Dr. Philipp Zahn
# Date: 28.12.2016
# =============================================================================

# =============================================================================
# FUNCTIONS FILE
# - This File contains all functions and is sourced by the script file (working code)
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Preliminaries
# -----------------------------------------------------------------------------

# Function to check for packages and load missing ones
GetPackages <- function(requiredPackages) {
  # Checks if the given packages are installed and loads the missing ones
  #
  # Args: 
  #   requiredPackages = A vector of packages that should be loaded
  # Returns:
  #   Loads packages
  newPackages <- requiredPackages[!(requiredPackages %in% 
                                      installed.packages()[ ,"Package"])]
  if (length(newPackages) > 0) {
    cat("Loading missing packages:", newPackages)
    install.packages(newPackages)
  }
  sapply(requiredPackages, require, character.only=TRUE)
}



# -----------------------------------------------------------------------------
# 2. first look at data 
# -----------------------------------------------------------------------------

# Function returning a ggplot on white background, where on the x-axis are the Dates
#   and on the y-axis are the values. Line types are according to the variables
white.theme.date.plot <- function(data, title){
  # returns a ggplot with white background theme
  #
  # Args: 
  #   data = data set in long format, containing the columns "Date", "value" and "variable"
  # Returns:
  #   ggplot on white background, Date on x-axis and values of the variable on y-axis. 
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
  #   data: data of which one wants to calculate the growth
  # Returns:
  #   growth rate of data
  first_diff <- diff(data)  / # take first difference
    data[-length(data)] * 100 # calculate growth rate
  first_diff # return results
}




# -----------------------------------------------------------------------------
# 4. correlogramm
# -----------------------------------------------------------------------------

# function computing dynamic correlogram and putting it together into a data frame
ccf.data.frame <- function(x, y, lags) {
  # makes a data frame out of ccf (cross-correlation function) for ggplot
  #
  # Args:
  #   x, y: time series data
  #   lags: number of lags and leads (specified in red_button)
  # 
  # Returns:
  #   a data frame containing the lags and cross-correlations
  ccf.data <- ccf(x, y, lag.max = lags, type = "correlation", plot = F)
  ccf.df <- data.frame(lag = ccf.data$lag,
                       correlation = ccf.data$acf)
}








