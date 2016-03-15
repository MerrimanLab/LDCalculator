#! /bin/bash

# LDProxy.sh
# Given a lead SNP ($1) and a VCF file ($2)
# calculate LD relative to this SNP

SNP=$1
VCFFILE=$2

~/GenomeTools/PLINK/plink --vcf ${VCFFILE} --r2 --ld-snp ${SNP} --ld-window-kb 1000 --ld-window 99999 --ld-window-r2 0.05 --out ${VCFFILE%.vcf}_Proxy
