#!/bin/bash

#SBATCH --job-name=join-files-rs19
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=20-1:0:00
#SBATCH --mem=100000M
#SBATCH --partition=high_p

cd /data/GWAS_data/work/000_GWAS_formatting/ferkingstad_2021_PMID34857953/005_phenospd/002_extract-info_proteins_cis-SNPs

Rscript join-files-rs19.R
