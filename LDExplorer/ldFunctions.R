# LDExplorer ldFunctions.R
#
# Supporting functions to explore LD datasets.
#
# Nick Burns
# March, 2016

ldRead <- function (ldFile) {
    
    # Reads in LD data into a data frame.
    #
    # Parameters:  
    # -----------
    #    ldFile: filename
    #        LD output from PLINK2, (CHR_A, BP_A, SNP_A, CHR_B, BP_B, SNP_B, R2)
    #        CHR_[A/B]: the chromosome on which the SNP is found
    #        SNP_[A/B]: the rsIDs of the SNPs
    #        BP_[A/B]: the position of the SNP (bases)
    #        R2: LD metric.
    #
    # Output:
    # -------
    #    Data frame as above.
    
    ldData <- read.table(ldFile, header = TRUE)
    return (ldData)
}

ldHeatmap <- function (ldFile) {
    
    # Reads in LD data, creates LD-based dissimilarity matrix, plots and clusters.
    #
    # Parameters:  
    # -----------
    #    ldFile: filename
    #        LD output from PLINK2, requires the following columns:
    #        (SNP_A, SNP_B, R2) where R2 is the LD (R^2) between SNPs A and B.
    #
    # Output:
    # -------
    #    Heatmap (including dendogram) of the data.
    
    # read in data, transform into NxN matrix of SNPs
    data <- ldRead(ldFile)
    data <- reshape2::dcast(data[, c("SNP_A", "SNP_B", "R2")], SNP_A ~ SNP_B, value.var = "R2")
    

    rownames(data) <- data[, 1]     # wrangle the data into a dissimilarity matrix
    data <- as.matrix(data[, -1])   # --------------------------------------------
    data[is.na(data)] <- 0          # set missing LD values as minimum LD
    data <- 1 - data                # create dissimilarity measure
    
    return (heatmap(data))
}

ldZoom <- function (ldFile) {
    
    # Reads in LD data, creates an LDZoom centered about the target snp.
    #
    # Parameters:  
    # -----------
    #    ldFile: filename
    #        LD output from PLINK2
    #
    # Output:
    # -------
    #    ldZoom:
    #        plot of POS against R2, centered about the target SNP
    
    ldData <- ldRead(ldFile)
    
    zoom <- ggplot(ldData, aes(x = BP_B / 1000000, y = R2)) +
        geom_point(aes(size = R2, colour = -R2), alpha = 0.8) +
        scale_colour_gradientn(colours=rainbow(3)) +
        xlab("Position (Mb)") +
        theme(legend.position = "none") + 
        geom_text_repel(data = ldData[ldData$R2 > 0.95, ],
                        aes(x = BP_B / 1000000, y = R2, label = SNP_B), colour="grey10", size=3) +
        theme_bw()
    
    return (zoom)
}

ldProxyTable <- function (proxyFile) {
    
    # reads in LD data and returns an ordered summary
    #
    # Parameters:
    # -----------
    #    proxyFile: filename
    #        LD output from PLINK, see ldProxy.sh
    #
    # Returns:
    # --------
    #    proxyData: data frame
    #        (Chr, Pos(A), Pos(B), SNP(A), SNP(B), R2)
    
    proxyData <- ldRead(proxyFile)
    
    # wrangle
    columns <- c("CHR_A", "BP_A", "BP_B", "SNP_A", "SNP_B", "R2")
    proxyData <- proxyData[, columns]
    colnames(proxyData) <- c("Chr", "Pos(A)", "Pos(B)", "SNP(A)", "SNP(B)", "R2")
    
    return (proxyData[order(proxyData$R2, decreasing = TRUE), ])
}