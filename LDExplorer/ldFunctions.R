# LDExplorer ldFunctions.R
#
# Given an LD dataset, cluster the data and return a heatmap
#
# Nick Burns
# March, 2016

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
    data <- read.table(ldFile, header=TRUE)
    data <- reshape2::dcast(data[, c("SNP_A", "SNP_B", "R2")], SNP_A ~ SNP_B, value.var = "R2")
    

    rownames(data) <- data[, 1]     # wrangle the data into a dissimilarity matrix
    data <- as.matrix(data[, -1])   # --------------------------------------------
    data[is.na(data)] <- 0          # set missing LD values as minimum LD
    data <- 1 - data                # create dissimilarity measure
    
    return (heatmap(data))
}