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
library(glida)

shinyServer(function(input, output) {
    
    # initialise data (calculate LD)
    initLD <- eventReactive(input$btnGetLD, {
        
        print("Initialising LD calculations. Please wait...")
        # Create the list of sample IDs
        ldPops <- input$inPop
        if (ldPops[1] == "ALL") {
            glida::ldPopulation(ldPops, allPops == TRUE)
        } else {
            glida::ldPopulation(ldPops, n = length(ldPops))
        }
        
        # Calculate LD for the given region
        glida::ldByRegion(input$txtChr, input$txtStart, input$txtEnd)
        
    })
    initZoom <- eventReactive(input$btnLDZoom, {
        
        leadSNP <- input$txtSNP
        genotypeFile <- sprintf("Genotype_%s_%s-%s.vcf",
                                input$txtChr, input$txtStart, input$txtEnd)
        proxyFile <- sprintf("Genotype_%s_%s-%s_Proxy.ld",
                             input$txtChr, input$txtStart, input$txtEnd)
        
        # Calculate LD relative to the leadSNP
        glida::ldProxy(leadSNP, vcf = genotypeFile)
        
        # print the summary table
        output$proxyTableSummary <- renderDataTable({
            glida::ldProxyTable(glida::ldRead(proxyFile))
        }, options = list(pageLength = 10)
        )

    })
    
    output$pltHeatmap <- renderPlot({
        initLD()
        ldFile <- sprintf("Genotype_%s_%s-%s.ld",
                          input$txtChr, input$txtStart, input$txtEnd)
        ldMatrix <- glida::ldDissimilarity(glida::ldRead(ldFile))
        
        glida::ldHeatmap(ldMatrix)
        
    })
    
    output$pltDendrogram <- renderPlot({
        
        ldFile <- sprintf("Genotype_%s_%s-%s.ld",
                          input$txtChr, input$txtStart, input$txtEnd)
        title <- sprintf("Cluster dendrogram: Chromosome %s: %s - %s",
                         input$txtChr, input$txtStart, input$txtEnd)
        
        # Cluster the LD data
        ldData <- glida::ldDissimilarity(glida::ldRead(ldFile))
        ldClusters <- glida:::ldCluster(ldData)
        
        glida::ldDendrogram(ldClusters, plotTitle = title)
    })
    
    output$pltZoom <- renderPlot({
        initZoom()
        proxyFile <- sprintf("Genotype_%s_%s-%s_Proxy.ld",
                            input$txtChr, input$txtStart, input$txtEnd)
        ldProxyData <- ldRead(proxyFile)
        
        # Query UCSC for nearby genes
        genes <- glida::queryUCSC(fromUCSCEnsemblGenes(
            chromosome = input$txtChr,
            start = input$txtStart,
            end = input$txtEnd
        ))
        
        # plot and annotate
        plotZoom <- glida::ldZoom(ldProxyData, ldThreshold = input$ldEps)
        glida::geneAnnotation(plotZoom, genes = genes)
        
    })
})