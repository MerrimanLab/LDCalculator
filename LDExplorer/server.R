# LDExplorer server.R
#
# The LD Explorer is motivated by the need to explore patterns of LD.
# This tool is largely inspired by the interactive analysis tool developed by
# the National Cancer Institute (NCI) (http://analysistools.nci.nih.gov/LDlink/?tab=home).
# Though it has been extended to work with 1000 Genomes data as well
# as user-supplied data sets (in VCF format).
#
# Nick Burns
# March, 2016

library(shiny)
library(reshape2)
source("ldFunctions.R")

shinyServer(function(input, output) {
    
    # initialise data (calculate LD)
    initLD <- eventReactive(input$btnGetLD, {
        
        #command <- sprintf("./GetLD.sh %s %s %s",
        #                   input$txtChr, input$txtStart, input$txtEnd)
        #system(command)
        print("Commented out for testing. Uncomment this function for live use.")
    })
    
    output$pltHeatmap <- renderPlot({
        initLD()
        ldFile <- sprintf("./Datasets/Genotype_%s_%s-%s.ld",
                          input$txtChr, input$txtStart, input$txtEnd)
        
        ldHeatmap(ldFile)
        
    })
})