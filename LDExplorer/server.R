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
library(ggplot2)
library(ggrepel)
source("ldFunctions.R")

shinyServer(function(input, output) {
    
    # initialise data (calculate LD)
    initLD <- eventReactive(input$btnGetLD, {
        
        #command <- sprintf("./GetLD.sh %s %s %s",
        #                   input$txtChr, input$txtStart, input$txtEnd)
        #system(command)
        print("Commented out for testing. Uncomment this function for live use.")
    })
    initZoom <- eventReactive(input$btnLDZoom, {
        
        ldSNP <- input$txtSNP
        genotypeFile <- sprintf("./Datasets/Genotype_%s_%s-%s.vcf",
                                input$txtChr, input$txtStart, input$txtEnd)
        
        command <- sprintf("./ldProxy.sh %s %s", ldSNP, genotypeFile)
        system(command)
        
        output$proxyTableSummary <- renderDataTable({
            proxyFile <- sprintf("./Datasets/Genotype_%s_%s-%s_Proxy.ld",
                                 input$txtChr, input$txtStart, input$txtEnd)
            ldProxyTable(proxyFile)
        }, 
        options = list(pageLength = 10)
        )

    })
    
    output$pltHeatmap <- renderPlot({
        initLD()
        ldFile <- sprintf("./Datasets/Genotype_%s_%s-%s.ld",
                          input$txtChr, input$txtStart, input$txtEnd)
        
        ldHeatmap(ldFile)
        
    })
    
    output$pltZoom <- renderPlot({
        initZoom()
        proxyFile <- sprintf("./Datasets/Genotype_%s_%s-%s_Proxy.ld",
                            input$txtChr, input$txtStart, input$txtEnd)
        ldZoom(proxyFile)
    })
    
})