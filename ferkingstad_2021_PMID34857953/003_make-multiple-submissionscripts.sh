#!/bin/bash

#SBATCH --job-name=make-multiple-submissionscripts
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=20-1:0:00
#SBATCH --mem=100000M
#SBATCH --partition=low_p

# set directory ====
cd /data/GWAS_data/work/000_GWAS_formatting/ferkingstad_2021_PMID34857953/005_phenospd/002_extract-info_proteins_cis-SNPs
rm filelist*
rm filenames
  
# create a file with the names of all files within a directory  ====
ls /data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/filelist_cis-SNPs/ > filenames.txt 

# create multiple .sh scripts from a single file with names in based on a master script  ====
# line 3 holds the job name
# line 13 holds the variable name
cat filenames.txt | while read i; do echo ${i}; 
awk '{ 
  if (NR == 3) 
    print "#SBATCH --job-name=extract-'"${i}"'";
  else if (NR == 14)
    print "export FILE_LIST=\"/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/filelist/'"${i}"'\"";
  else
    print $0
}' master.sh > ${i}.sh; done 
rm filenames.txt