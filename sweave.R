# =============================================================================
# University of St.Gallen
# Course: HS16-9,272,1.00 Economics of Central Banking
# Author: Helena Aebersold
# Professor: Dr. Nicolas Cuche-Curti
# Date: 20.10.2016
# =============================================================================

# =============================================================================
# Sweave File
# - This File contains the code to compile the LateX .Rnw into a .tex which 
#     we then can run normally to make a .pdf with all the outputs from R
# =============================================================================

# IMPORTANT NOTE:
#   I work with Texmaker which saves the files as LateX files. When using other
#   LateX editors make sure to save the one with code junks in .Rnw. Make changes
#   only in that file, not in the normal .tex

# read "EPFL-Sweave-powerdot.pdf" for more information on Sweave

# The Sweave command is used in package "utils". Set your working directory right
#   and run this code, which will return a .tex file

# Set working directory
if (Sys.info()[['login']] == 'Helena Aebersold') {
  dir <- 'C:/Users/Helena Aebersold/Dropbox/HSG/Master/HS16/software_engineering_for_economists/SoftwareEngineering/'
} else if (Sys.info()[['login']] == '') {
  dir <- ""
} else if (Sys.info()[['login']] == '') {
  dir <- ""
} else {
  dir <- getwd()
}
setwd(dir)




Sweave("tex_file.tex")
#

# if you have problems running that .tex file in LateX, then make sure to adjust
#   the roots:
# http://tex.stackexchange.com/questions/153193/latex-error-sweave-sty-not-found






