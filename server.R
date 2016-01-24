##
## LD Calculation Interface
##
## Front end for LDCalculation. Contains two tabs:
##    100Genomes:  allows users to calculate LD for given SNPs from 1000 Genomes
##    User Data:   allows users to define their own VCF files and Samples to calculate LD for.
##
## Values from input widgets are saved to global variables in server.R. These may then be used
## to pass parameters to the backend for the calculation of LD.
##
## Nick Burns
## Jan 2016
##

## Server.R
library(shiny)
library(shinyFiles)
setwd("~/Documents/GitHub/LDCalculator")

## Global variables for final command text
##
##

# other control options
##
##

shinyServer(function(input, output, session) {
  
})

