#!/bin/bash

#SBATCH --job-name=001_make_snp-a0-a1.sh
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=10-10:0:00
#SBATCH --mem=10000M
#SBATCH --partition=low_p

# files
    FILE_IN="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/GWAS/10015_119_KCNAB2_KCAB2.txt.gz.annotated.gz.exclusions.gz.alleles.gz"
    FILE_OUT="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/SNP-a0-a1.txt"

# define temporary file
    mkdir -p /scratch/wangs/temp
    tmp=$(mktemp -p /scratch/wangs/temp)
    
# extract all SNPs and A0 A1 from 1 GWAS
    echo "## extract SNP A0 A1:"
    zcat "$FILE_IN" | head -n 10
    zcat "$FILE_IN" | cut -f4-6 | awk '$1 != "NA"' | sort -k1 > "${tmp}_extracted"
    head -n 5 "${tmp}_extracted"
    
# change separator from tab to space to match protein files
    echo "## change separator:"
    awk '{gsub(/\t/, " "); print}' "${tmp}_extracted" > "${tmp}_space"
    head -n 5 "${tmp}_space"
    
# add a header to the file
    echo "## adding header to the joined file:"
    header="SNP allele_0 allele_1"
    echo "$header" > "$FILE_OUT"
    cat "${tmp}_space" >> "$FILE_OUT"
    head -n 5 "$FILE_OUT"