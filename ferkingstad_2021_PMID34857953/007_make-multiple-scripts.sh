#!/bin/bash

#SBATCH --job-name=make-multiple-submissionscripts
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=20-1:0:00
#SBATCH --mem=100000M
#SBATCH --partition=low_p

# set directory ====
cd /data/GWAS_data/work/000_GWAS_formatting/ferkingstad_2021_PMID34857953/005_phenospd/002_extract-info_proteins_cis-SNPs
rm join-files-*

# read files for snps starting with rs10...rs99 = 9x10 = 90 scripts

# rs10 scripts =====
# save col names for rs10 files
# j=rsid
j=10
FILENAME="join-files-rs$j"
OUTPUT="data_cis-SNPs-rs$j.txt"
echo "FILENAME: ${FILENAME}, OUTPUT: ${OUTPUT}, rs: ${j}"

awk -v rs="${j}" -v output="${OUTPUT}" '
{
    if (NR == 16)
        print "  data <- fread(list_files[[i]], sep = \" \", header = FALSE, colClasses = \"character\")[grepl(\"^rs" rs "\", V1)]";
    else if (NR == 67)
        print "write.table(merged_data, paste0(DIRECTORY, \"data_cis-SNPs/" output "\"),";
    else if (NR == 68)
        print "            row.names = TRUE, col.names = TRUE, quote = FALSE, sep = \" \")";        
    else
        print $0
}' 005_master-join-files.R > "${FILENAME}.R"

awk -v job="${FILENAME}" '
    {
        if (NR == 3)
            print "#SBATCH --job-name=" job "";
        else if (NR == 12)
            print "Rscript " job ".R";
        else
            print $0
    }' 006_master-join-files.sh > "${FILENAME}.sh"
sleep 2

# for rs11...rs99 scripts  =====
# col names = FALSE
# j=rsid
for ((j=11; j<=99; j++)); do
FILENAME="join-files-rs$j"
OUTPUT="data_cis-SNPs-rs$j.txt"
echo "FILENAME: ${FILENAME}, OUTPUT: ${OUTPUT}, rs: ${j}"

awk -v rs="${j}" -v output="${OUTPUT}" '
{
    if (NR == 16)
        print "  data <- fread(list_files[[i]], sep = \" \", header = FALSE, colClasses = \"character\")[grepl(\"^rs" rs "\", V1)]";
    else if (NR == 67)
        print "write.table(merged_data, paste0(DIRECTORY, \"data_cis-SNPs/" output "\"),";
    else if (NR == 68)
        print "            row.names = TRUE, col.names = FALSE, quote = FALSE, sep = \" \")";        
    else
        print $0
}' 005_master-join-files.R > "${FILENAME}.R"

awk -v job="${FILENAME}" '
    {
        if (NR == 3)
            print "#SBATCH --job-name=" job "";
        else if (NR == 12)
            print "Rscript " job ".R";
        else
            print $0
    }' 006_master-join-files.sh > "${FILENAME}.sh"
done