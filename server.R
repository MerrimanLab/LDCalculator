##
## LD Calculation Interface
##
## This interface allows users to define the input parameters for
## James's LD Calculation script and dynamically builds the command string.
##
## Nick Burns
## Dec 2015
##

## Server.R
library(shiny)
library(shinyFiles)
setwd("~/Documents/GitHub/LDCalculator")

## Global variables for final command text
DIRECTORIES <- c(wd='~/.')
outVCFFILE <- ''
outSNPFILE <- ''
outSNPINCLUDE <- ''
outSNPEXCLDUE <- ''
outWINDOWSNPS <- ''
outWINDOWKB <- ''
outWINDOWFREQ <- ''
outHAPLOVIEW <- ''
outPED <- ''
outMATRIX <- ''

shinyServer(function(input, output, session) {
  
    ## File Inputs & SNP Include / Exclude
    ## Simily things, and make users run this from one directory that contains their data files?
    ## then I can simply point to this directory in roots() below.
    
    # inputVCFFile
    shinyFileChoose(input, "inputVCFFile", session=session, roots=DIRECTORIES)
    output$outputVCFFile <- renderPrint({parseFilePaths(DIRECTORIES, input$inputVCFFile)[1:2]})
    
    # inputSNPFile
    shinyFileChoose(input, "inputSNPFile", session=session, roots=DIRECTORIES)
    output$outputSNPFile <- renderPrint({parseFilePaths(DIRECTORIES, input$inputSNPFile)[1:2]})
  
    # textSNPInclude
    outputSNPInclude <- renderText({input$textSNPInclude})
    # textSNPExclude
    outputSNPExclude <- renderText({input$textSNPExclude})
    
    ## Slider Controls
    outputWindowSNPs <- renderText({input$sliderWindowSNPs})
    outputWindowKB <- renderText({input$sliderWindowKB})
    outputWindowFreq <- renderText({input$sliderWindowFreq})
    
    ## Output Files
    outputHaploview <- renderText({input$textHaploview})
    outputPED <- renderText({input$textPED})
    
    ## Output as matrix
    outputMatrix <- renderText({input$checkMatrix})
    
    ## OnSubmit
    
})