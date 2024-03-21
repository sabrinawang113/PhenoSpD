#!/bin/bash

#SBATCH --job-name=make-multiple-submissionscripts
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=20-1:0:00
#SBATCH --mem=100000M
#SBATCH --partition=low_p

# set directory ====
cd /data/GWAS_data/work/000_GWAS_formatting/ferkingstad_2021_PMID34857953/005_phenospd/002_extract-info_proteins_cis-SNPs

# submit the filelist-*.sh scripts  ====
for file in filelist-*.sh; do
sbatch $file
sleep 2
done