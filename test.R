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

if (Sys.info()[['login']] == 'Helena Aebersold') {
  dir <- 'C:/Users/Helena Aebersold/Dropbox/HSG/Master/HS16/software_engineering_for_economists/SoftwareEngineering/'
} else if (Sys.info()[['login']] == 'Divna') {
  dir <- "C:/Users/Divna/Documents/Uni/Master/3. Semester/Kontextstudium/Software Engineering for Economists/Group Project/SoftwareEngineering/"
} else if (Sys.info()[['login']] == 'Michèle') {
  dir <- "C:/Users/Michèle/Documents/MAHS15/Software_Engineering_for_Economists/SoftwareEngineering"
} else if (Sys.info()[['login']] == 'Feld_PhilippZahn') {
  dir <- ""
} else {
  dir <- getwd()
}
setwd(dir)

# Source function file (from wd)
source("./functions.R")

# Used packages in this analaysis
packageList <- c("kimisc", "ggplot2", "plyr", "zoo", "mFilter", "stats", "tseries",
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

#   GDP and GDP_DEF
gdp <- ggplot( data = subset(swiss_long, (variable == "GDP")),
        aes(x = Date, y = value, linetype = variable)) +
  geom_line() +
  scale_linetype("") +
  theme_bw() + 
  theme(plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.key = element_blank(),
        axis.title.y = element_blank())+
  theme(panel.border= element_blank())+
  theme(axis.line.x = element_line(color="black"),
        axis.line.y = element_line(color="black"))






       
ggplot(data = swiss, aes(x = Date, y = GDP)) +
  geom_line()
ggplot(data = swiss, aes(x = Date, y = GDP_DEF)) +
  geom_line()
#   Money aggregates (MB, M1, M2, M3)
ggplot(data = swiss, aes(x = Date, y = MB)) +
  geom_line() +
  geom_line(data = swiss, aes(x = Date, y = M1), linetype = 2) +
  geom_line(data = swiss, aes(x = Date, y = M2), linetype = 3) +
  geom_line(data = swiss, aes(x = Date, y = M3), linetype = 4)
#   CPI
ggplot(data = swiss, aes(x = Date, y = CPI)) +
  geom_line()
#   interest rates (short and long run)
ggplot(data = swiss, aes(x = Date, y = i3M)) +
  geom_line() +
  geom_line(data = swiss, aes (x = Date, y = i10Y), linetype = 2)




