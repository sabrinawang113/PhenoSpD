#!/bin/bash

#SBATCH --job-name=009_append-files
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=20-1:0:00
#SBATCH --mem=100000M
#SBATCH --partition=high_p

cd /data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd
#ls data_cis-SNPs/data_cis-SNPs-rs*.txt | xargs -I {} sh -c 'head -n 1000000 {}' > data_cis-SNPs-sample.txt
ls data_cis-SNPs/data_cis-SNPs-rs*.txt
cat ./data_cis-SNPs/data_cis-SNPs-rs*.txt > data_cis-SNPs.txt