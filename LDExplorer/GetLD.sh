#! /bin/bash

#### GetLD.sh ####
#
# Using 1000 Genomes data, calculate LD    
# for a given subset of people (population-based),
# a given subset of SNPs (variant filtering).
#
# Calculates the pairwise LD for all SNPs
#
# Nick Burns
# March 2016

POPFILE=/mnt/DataDrive/ReferenceData/1000Genomes_PopSample_Information.20130502.ALL.panel


# Arguments to this script used to define the chromosome and region
CHR=$1
START=$2
END=$3

# input / output files
VCFFILE=./Datasets/Genotype_${CHR}_${START}-${END}.vcf
SAMPLES=sample_list.txt

# Download 1000 Genomes data
tabix -fh ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz ${CHR}:${START}-${END} > ${VCFFILE}

# Calculate LD
/home/nickb/GenomeTools/PLINK/plink --vcf ${VCFFILE} --keep-fam ${SAMPLES} --snps-only no-DI --r2 --out ${VCFFILE%.vcf}       


