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
globalOptions <- list(
    POPULATION = FALSE,                            # control: checkPopulation
    CHR = FALSE,                                   # control: textRegChr1KG or textRegChrUsr
    REGIONstart = FALSE, 
    REGIONend = FALSE,                             # control: textRegStart1KG, textRegEND1KG 
                                                  #       or,textRegStartUsr, textRegENDUsr
    SNPFILE = FALSE,                               # control: inputSNPFile1KG or, inputSNPFileUsr
    SNPINCLUDE = FALSE,                            # control: textSNPInclude1KG or, textSNPIncludeUsr
    SNPEXCLUDE = FALSE,                            # control: textSNPExclude1KG or, textSNPExcludeUsr
    OUTPUTHaploview = FALSE, 
    OUTPUTPairwise = FALSE,
    OUTPUTProxy = FALSE,                          # control: radioOutputFormat1Kg, or radionOutputFormatUsr
    OUTFILE = FALSE,                               # control: textOutputFile1Kg or, textOutputFileUsr
    PROXYWINDOW = FALSE,                           # control: textProxyWindow1KG or, textProxyWindowUsr
    LDLIMIT = FALSE,                               # control: sliderProxySNP1KG or, sliderProxySNPUsr
    VCFFILE = FALSE,                               # control: inputVCFFile
    SAMPLEEXCLUDE = FALSE                          # control: textSampleExcl
)

shinyServer(function(input, output, session) {

    #### 1000 Genomes Tab ####
    # SNP Info panel
    shinyFileChoose(input, "inputSNPFile1KG", session = session, roots = c(wd='/home/'))
    output$outSNPFile1KG <- renderPrint({ 
        tmpFile <- as.character(parseFilePaths(c(wd='/home/'), input$inputSNPFile1KG)$datapath)
        globalOptions$SNPFILE <<- tmpFile
        tmpFile
    })
    
    # Final Action button
    gatherOptions1KG <- eventReactive(input$actionBtn, {
        
        # get values from all controls
        globalOptions$POPULATION <<- input$checkPopulation
        globalOptions$CHR <<- input$textRegChr1KG
        globalOptions$REGIONstart <<- input$textRegStart1KG
        globalOptions$REGIONend <<- input$textRegEnd1KG
        globalOptions$SNPFILE <<- as.character(parseFilePaths(c(wd='/home/'), input$inputSNPFile1KG)$datapath)
        
        tmp <- input$radioOutputFormat1KG
        if (tmp == 1) {
            globalOptions$OUTPUTHaploview <<- TRUE
        } else if (tmp == 2) {
            globalOptions$OUTPUTPairwise<<- TRUE
        } else {
            globalOptions$OUTPUTProxy<<- TRUE
        }
        globalOptions$OUTFILE <<- input$textOutputFile1KG
        globalOptions$PROXYWINDOW <<- input$textProxyWindow1KG
        globalOptions$LDLIMIT <<- input$sliderProxySNP1KG
        
    })
    
    # Display the final options
    output$outputGLOBALOPTIONS <- renderText({

            gatherOptions1KG()
            
            toString(lapply(1:length(globalOptions), function (opt) {
                key <- names(globalOptions)[opt]
                paste0(key, ": ", globalOptions[key], "\n")}))
            
    })
    
    #### User Data Tab ####
    # VCF File Input (user data tab)
    shinyFileChoose(input, "inputVCFFile", session = session, roots = c(wd='/home/'))
    output$outVCFFile <- renderPrint({
        tmpFile <- as.character(parseFilePaths(c(wd='/home/'), input$inputVCFFile)$datapath)
        globalOptions$VCFFile <<- tmpFile
        tmpFile
    })
    
    # SNP Info panel
    shinyFileChoose(input, "inputSNPFileUsr", session = session, roots = c(wd='/home/'))
    output$outSNPFileUsr <- renderPrint({ 
        tmpFile <- as.character(parseFilePaths(c(wd='/home/'), input$inputSNPFileUsr)$datapath)
        globalOptions$SNPFILE <<- tmpFile
        tmpFile
    })
    
    # Final Action button
    gatherOptionsUsr <- eventReactive(input$actionBtnUsr, {
        
        # get values from all controls
        globalOptions$POPULATION <<- input$checkPopulation
        globalOptions$CHR <<- input$textRegChrUsr
        globalOptions$REGIONstart <<- input$textRegStartUsr
        globalOptions$REGIONend <<- input$textRegEndUsr
        globalOptions$SNPFILE <<- as.character(parseFilePaths(c(wd='/home/'), input$inputSNPFileUsr)$datapath)
        
        tmp <- input$radioOutputFormatUsr
        if (tmp == 1) {
            globalOptions$OUTPUTHaploview <<- TRUE
        } else if (tmp == 2) {
            globalOptions$OUTPUTPairwise<<- TRUE
        } else {
            globalOptions$OUTPUTProxy<<- TRUE
        }
        globalOptions$OUTFILE <<- input$textOutputFileUsr
        globalOptions$PROXYWINDOW <<- input$textProxyWindowUsr
        globalOptions$LDLIMIT <<- input$sliderProxySNPUsr
        
    })
    
    # Display the final options
    output$outputGLOBALOPTIONSUsr <- renderText({
        gatherOptionsUsr()
        
        toString(lapply(1:length(globalOptions), function (opt) {
            key <- names(globalOptions)[opt]
            paste0(key, ": ", globalOptions[key], "\n")}))

    })

})

