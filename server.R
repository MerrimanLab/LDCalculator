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
outCOMMAND <- ''

shinyServer(function(input, output, session) {
  
    ## File Inputs & SNP Include / Exclude
    ## Simplify things, and make users run this from one directory that contains their data files?
    ## then I can simply point to this directory in roots() below.
    
    # inputVCFFile
    shinyFileChoose(input, "inputVCFFile", session=session, roots=DIRECTORIES)
    output$outputVCFFile <- renderPrint({input$inputVCFFile$files$'0'[[2]]})
    
    # inputSNPFile
    shinyFileChoose(input, "inputSNPFile", session=session, roots=DIRECTORIES)
    output$outputSNPFile <- renderPrint({input$inputSNPFile$files$'0'[[2]]})
  
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
    outputMatrix <- renderText({input$radioMatrix})
    
    ## OnCreate
    output$outputCommand <- renderText({

          outCOMMAND <<- ''
          outVCFFILE <<- paste0(input$inputVCFFile$files$'0'[[2]], ',')
          outSNPFILE <<- paste0(input$inputSNPFile$files$'0'[[2]], ',')
          outSNPINCLUDE <<- paste0(input$textSNPInclude, ',')
          outSNPEXCLDUE <<- paste0(input$textSNPExclude, ',')
          outWINDOWSNPS <<- paste0(input$sliderWindowSNPs, ',')
          outWINDOWKB <<- paste0(input$sliderWindowKB, ',')
          outWINDOWFREQ <<- paste0(input$sliderWindowFreq, ',')
          outHAPLOVIEW <<- paste0(input$textHaploview, ',')
          outPED <<- paste0(input$textPED, ',')
          outMATRIX <<- input$radioMatrix
        
          outCOMMAND <<- paste0(outVCFFILE,
                               outSNPFILE,
                               outSNPINCLUDE,
                               outSNPEXCLDUE,
                               outWINDOWSNPS,
                               outWINDOWKB,
                               outWINDOWFREQ,
                               outHAPLOVIEW,
                               outPED,
                               outMATRIX)
          
          outCOMMAND
    })

})

