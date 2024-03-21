#!/bin/bash

#SBATCH --job-name=phenospd_sample
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=20-1:0:00
#SBATCH --mem=512000M
#SBATCH --partition=high_p

# download phenospd directory from github ====
# git clone https://github.com/MRCIEU/PhenoSpD.git
# Rscript /home/wangs/PhenoSpD/script/my_phenospd.r --sumstats /home/wangs/PhenoSpD/data/PhenoSpD_input_example.txt --out /data/GWAS_data/work/UKB_PPP/phenospd/combined/phenospd_test

cd /home/wangs/PhenoSpD/

export SCRIPT=/home/wangs/PhenoSpD/script/my_phenospd.r
export DATA=/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/data_cis-SNPs-sample.txt
export OUTPUT=/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/phenospd_cis-SNPs-sample

Rscript ${SCRIPT} --sumstats ${DATA} --out ${OUTPUT}