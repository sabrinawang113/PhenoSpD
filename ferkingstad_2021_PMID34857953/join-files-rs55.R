rm(list=ls())

# environment ====
library(data.table)
library(dplyr)
library(tidyverse)

DIRECTORY <- "/data/GWAS_data/work/ferkingstad_2021_PMID34857953/phenospd/"

# data ====
print("load data")
list_files <- list.files(paste0(DIRECTORY, "proteins_cis-SNPs"), full.names = T)

list_data_colname <- lapply(list_files, function(file) fread(file, sep = " ", header = TRUE, nrows = 0))
list_data <- lapply(seq_along(list_files), function(i) {
  data <- fread(list_files[[i]], sep = " ", header = FALSE, colClasses = "character")[grepl("^rs55", V1)]
  setnames(data, names(list_data_colname[[i]]))
  return(data)
})

# format data ====
print("format data")
for (i in seq_along(list_data)) {
  # remove rows where col SNP1 does not start with "rs" 
  #list_data[[i]] <- subset(list_data[[i]], grepl("^rs", SNP1)) ##done separately
  # remove rows with no values
  #list_data[[i]] <- subset(list_data[[i]], SNP1 != "rsid")  ##done separately
  # remove duplicated rsid
  list_data[[i]] <- list_data[[i]][!duplicated(list_data[[i]]$SNP1) & !duplicated(list_data[[i]]$SNP1, fromLast = TRUE), ]
}

# merge data by SNP1  ====
print("merge data by SNP1")
master_data <- list_data %>% reduce(inner_join, by = "SNP1")
#master_data <- master_data[order(master_data$SNP1), ]
#tail(master_data)
#head(master_data)
#length(unique(master_data$SNP1))

# change col name ====
print("change col name")
colnames(master_data) <- sapply(colnames(master_data), function(colname) {
  parts <- strsplit(colname, "_")[[1]]
  paste(parts[1], parts[length(parts)], sep = "_")
})
colnames(master_data)[colnames(master_data) == "SNP1_SNP1"] <- "SNP"

# merge with snpa0a1 ====
print("merge with snpa0a1")
snpa0a1 <- fread(paste0(DIRECTORY, "SNP-a0-a1.txt"), header = T, sep = " ")
merged_data <- merge(snpa0a1, master_data, by = "SNP", all = FALSE)
#print(head(merged_data, 15))

# filter rows for allele_0 and allele_1 ====
print("filter rows for allele_0 and allele_1")
merged_data <- merged_data %>%
  filter(allele_0 %in% c("A", "C", "T", "G") & allele_1 %in% c("A", "C", "T", "G"))

# set SNP as row name  ====
print("set SNP as row name")
row.names(merged_data) <- merged_data$SNP
merged_data <- merged_data %>%
  select(-SNP) 

# save ====
print("save")
write.table(merged_data, paste0(DIRECTORY, "data_cis-SNPs/data_cis-SNPs-rs55.txt"),
            row.names = TRUE, col.names = FALSE, quote = FALSE, sep = " ")
