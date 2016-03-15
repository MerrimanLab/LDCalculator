# LDExplorer ldFunctions.R
#
# Given an LD dataset, cluster the data and return a heatmap
#
# Nick Burns
# March, 2016

ldHeatmap <- function (ldFile) {
    
    data <- read.table(ldFile, header=TRUE)
    data <- reshape2::dcast(data[, c("SNP_A", "SNP_B", "R2")], SNP_A ~ SNP_B, value.var = "R2")
    rownames(data) <- data[, 1]
    data <- as.matrix(data[, -1])
    data[is.na(data)] <- 0
    data <- 1 - data
    
    return (heatmap(data))
}