# =============================================================================
# University of St.Gallen
# Course: HS16-7,610,1.00 Software Engineering for Economists
# Authors: Helena Aebersold, Divna Nikolic, Michèle Schoch
# Professor: Dr. Philipp Zahn
# Date: 16.01.2017
# =============================================================================

# =============================================================================
# Sweave File
# - This file contains the code to compile the LateX .Rnw into a .tex which 
#     we then can run normally to make a .pdf with all the outputs from R
# =============================================================================



# IMPORTANT NOTE:
#   We work with Texmaker which saves the files as LateX files 
#   when using other LateX editors make sure to save the one with code junks in .Rnw 
#   make changes only in that file, not in the normal .tex

# The Sweave command is used in package "utils", set your working directory right
#   and run this code, which will return a .tex file


# Set working directory
if (Sys.info()[['login']] == 'Helena Aebersold') {
  dir <- 'C:/Users/Helena Aebersold/Dropbox/HSG/Master/HS16/software_engineering_for_economists/SoftwareEngineering/'
} else if (Sys.info()[['login']] == 'Divna') {
  dir <- 'C:/Users/Divna/Documents/Uni/Master/3. Semester/Kontextstudium/Software Engineering for Economists/Group Project/SoftwareEngineering/'
} else if (Sys.info()[['login']] == 'Michèle') {
  dir <- 'C:/Users/Michèle/Documents/MAHS15/Software_Engineering_for_Economists/SoftwareEngineering'
} else if (Sys.info()[['login']] == 'Feld_PhilippZahn') {
  dir <- ""
} else {
  dir <- getwd()
}
setwd(dir)


Sweave("GroupProject_SoftwareEngineering_Aebersold_Nikolic_Schoch.tex")


# If you have problems running that .tex file in LateX, then make sure to adjust the roots, see:
#   http://tex.stackexchange.com/questions/153193/latex-error-sweave-sty-not-found
