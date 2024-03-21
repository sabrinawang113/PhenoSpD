#!/bin/bash

#SBATCH --job-name=001_make-multiple-filelists.sh
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=10-10:0:00
#SBATCH --mem=10000M
#SBATCH --partition=low_p

# define the directory containing your gwas files ====
directory="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/GWAS/"

# make proteins_cis-SNPs filelist
awk '{print "/data/GWAS_data/work/ferkingstad_2021_PMID34857953/GWAS/"$NF}' /data/GWAS_data/work/ferkingstad_2021_PMID34857953/cis_snp_list.txt | tail -n +2 > /data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/filelist_cis-snps.txt
FILE="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/filelist_cis-snps.txt"
sed -i 's/\.txt\.gz\.annotated\.gz\.exclusions\.gz\.alleles\.gz\.unzipped/\.txt\.gz\.annotated\.gz\.exclusions\.gz\.alleles\.gz/g' "$FILE"

# set number of protein files to split ====
cd /data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/
  FILE="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/filelist_cis-snps.txt"
  lines_per_file=$((($(wc -l < "$FILE") / 99) + 1))
  echo $lines_per_file
  
# split to create the new files  ====
input_file="filelist_cis-snps.txt"
mkdir /data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/filelist_cis-SNPs/
output_prefix="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/filelist_cis-SNPs/filelist-"
split --lines="$lines_per_file" --numeric-suffixes=1 "$input_file" "$output_prefix"