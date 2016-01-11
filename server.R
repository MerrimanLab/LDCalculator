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
optVCFFILE <- ''
optSNPFILE <- ''
optSNPINCLUDE <- ''
optSNPEXCLDUE <- ''
optWINDOWSNPS <- ''
optWINDOWKB <- ''
optWINDOWFREQ <- ''
optHAPLOVIEW <- ''
optPED <- ''
optMATRIX <- ''

# other control options
optSNPLISTONLY <- "TRUE"
optOUTPUTFILE <- sprintf("LDOutput_%s.out", Sys.Date())
optLOGFILE <- sprintf("LDLogFile_%s.log", Sys.Date())

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

          outCOMMAND <- 
            "COMMAND -v %s -R %s -s %s -S %s -c %s -w %s -r %s -l %s -m %s -o %s -i %s -O %s -h %s -p %s"
          
          optVCFFILE <<- if (is.null(input$inputVCFFile$files$'0'[[2]])) '' 
                         else input$inputVCFFile$files$'0'[[2]]  
          optSNPFILE <<- if (is.null(input$inputSNPFile$files$'0'[[2]])) '' 
                         else input$inputSNPFile$files$'0'[[2]] 
          optSNPINCLUDE <<- input$textSNPInclude
          optSNPEXCLDUE <<- input$textSNPExclude
          optWINDOWSNPS <<- input$sliderWindowSNPs
          optWINDOWKB <<- input$sliderWindowKB
          optWINDOWFREQ <<- input$sliderWindowFreq
          optHAPLOVIEW <<- input$textHaploview
          optPED <<- input$textPED
          optMATRIX <<- if (input$radioMatrix == 1) 'FALSE'
                        else 'TRUE'
        
          outCOMMAND <- sprintf(
              outCOMMAND,
              optVCFFILE,
              optSNPINCLUDE,
              optSNPFILE,
              optSNPLISTONLY,
              '???',
              optWINDOWSNPS,
              optWINDOWFREQ,
              optWINDOWKB,
              optMATRIX,
              optOUTPUTFILE,
              optSNPEXCLDUE,
              optLOGFILE,
              optHAPLOVIEW,
              optPED
          )
          
          outCOMMAND
    })

})

