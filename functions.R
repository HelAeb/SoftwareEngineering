# =============================================================================
# University of St.Gallen
# Course: HS16-7,610,1.00 Software Engineering for Economists
# Authors: Helena Aebersold, Divna Nikolic, Michèle Schoch
# Professor: Dr. Philipp Zahn
# Date: 28.12.2016
# =============================================================================

# =============================================================================
# FUNCTIONS FILE
# - This File contains all functions and is sourced by the script file
# =============================================================================

# -----------------------------------------------------------------------------
# -1. Preliminaries
# -----------------------------------------------------------------------------


# Function to check for packages and load missing ones
GetPackages <- function(requiredPackages) {
  # Checks if the given packages are installed and loads the missing ones
  #
  # Args: 
  #   requiredPackages: A vector of packages that should be loaded
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
