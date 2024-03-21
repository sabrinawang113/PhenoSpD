#!/bin/bash

#SBATCH --job-name=extract-filelist-79
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=20-1:0:00
#SBATCH --mem=100000M
#SBATCH --partition=low_p

cd /data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/

# Set environment variables
export FILE_SNP_A0_A1="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/SNP-a0-a1.txt.sorted.NAremoved"
export FILE_LIST="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/filelist_cis-SNPs/filelist-79"
export REMOVE=".txt.gz.annotated.gz.exclusions.gz.alleles.gz"
export DIRECTORY_OUT="/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/proteins_cis-SNPs/"

# Read each file from the file list and process it
while IFS= read -r file; do
    echo "# processing: $file"  # Debugging line
    # Extract colNAME from the file name
    colNAME=$(echo "$file" | sed -e "s/$REMOVE$//" | awk -F 'GWAS/' '{print $2}' | awk -F '_' '{print $1"_"$2}')
    echo "## file name: $colNAME"

    # Define temporary file
    tmp=$(mktemp -p /scratch/wangs/temp)
    
    # Unzip the file into a tmp file
    echo "## unzipping:"
    zcat "$file" > "$tmp"
    # head -n 5 "$tmp"
    
    # Extract columns 4, 7, and 10 and store them in the temporary file
    echo "## extracting columns 4, 7, and 10:"
    cut -f4,7,10 "$tmp" > "${tmp}_extracted"
    # head -n 5 "${tmp}_extracted"
    
    # Remove all rows with NA in column 4
    echo "## removing rows with 'NA' in column 4:"
    awk '$1 != "NA"' "${tmp}_extracted" > "${tmp}_filtered"
    # head -n 5 "${tmp}_filtered"
    
    # Sort the file using column 4
    echo "## sorting by column 4:"
    sort -k1 "${tmp}_filtered" > "${tmp}_sorted"
    # head -n 5 "${tmp}_sorted"
    
    # Left join the file onto $FILE_SNP_A0_A1
    echo "## joining file:"
    join -1 1 -2 1 -o 1.1,2.1,2.2,2.3 "$FILE_SNP_A0_A1" "${tmp}_sorted" > "${tmp}_joined"
    # head -n 5 "${tmp}_joined"
    
    # Add a header to the file
    echo "## adding header to the joined file:"
    header="SNP1 SNP2 ${colNAME}_b ${colNAME}_se"
    echo "$header" > "${tmp}_header"
    cat "${tmp}_joined" >> "${tmp}_header"
    # head -n 5 "${tmp}_header"
    
    # Extract b and se columns (space separated now)
    echo "## extracting columns 3 and 4:"
    cut -d ' ' -f1,3,4 "${tmp}_header" > "${tmp}"
    # head -n 5 "${tmp}"
    
    # Write to the output file
    mv "${tmp}" "${DIRECTORY_OUT}${colNAME}"
    echo "## Processed: $colNAME"

    # Remove temporary files
    rm -f "${tmp}" "${tmp}_extracted" "${tmp}_filtered" "${tmp}_sorted" "${tmp}_joined" "${tmp}_header"

done < "$FILE_LIST"
