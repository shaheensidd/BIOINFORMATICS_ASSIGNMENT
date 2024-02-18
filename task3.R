# check the working directory
getwd()

# import packages/library
library(dplyr)    
library(readr)
library(ggplot2)

# import data file Homo_sapiens.gene_info.gz without unzipping
gene_info_df <- read_tsv("Homo_sapiens.gene_info.gz", show_col_types = 'FALSE')
cat("Original dimension : ", dim(gene_info_df), "\n")

# Find unique values of the column 'chromosome'
unique_chr_values <- unique(gene_info_df$chromosome)
cat("Unique values in the column 'chromosome' in Original dataframe : ", unique_chr_values, "\n")
cat("No. of unique values in the column 'chromosome' in Original dataframe : ", length(unique_chr_values), "\n")

# Values to be dropped from the dataframe
to_remove <- c("-","X|Y","10|19|3")
#print(to_remove)

# Values to be kept in the dataframe
to_keep <- setdiff(unique_chr_values, to_remove)
#print(to_keep))

# remove rows which contain "-","X|Y","10|19|3" in column chromosome
filtered_gene_info_df <- gene_info_df %>% filter(chromosome %in% to_keep)
cat("\n", "Filtered dimension : ", dim(filtered_gene_info_df), "\n")

chr_num <- unique(filtered_gene_info_df$chromosome)
cat("Unique values in the column 'chromosome' in Filtered dataframe : ", chr_num, "\n")
cat("No. of unique values in the column 'chromosome' in Filtered dataframe : ", length(chr_num), "\n")
#gene_sym <- unique(filtered_gene_info_df$Symbol)
#cat("No. of unique values in the column 'Symbol' in Filtered dataframe : ", length(gene_sym), "\n")

# select rectangular size
options(repr.plot.width = 25, repr.plot.height = 15)

# plot bar graph using filtered dataframe
# # 1. plotting
# # 2. put title and centre its positioning
# # 3. select panel background as white
# # 4. style line as black using theme
# # 4. name x & y axis, resize and orient them
# # 5. orient title using theme
ggplot(filtered_gene_info_df, aes(x=factor(chromosome, level=c('1', '2', '3', '4','5', '6', '7', '8','9', '10', '11', '12','13', '14', '15', '16','17', '18', '19', '20','21', '22', 'X', 'Y','MT', 'Un' )))) + 
  geom_bar() +
  labs(title = "Number of genes in each chromosome", x = "Chromosomes", y = "Gene count") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(panel.background = element_rect(fill = "white")) + 
  theme(axis.line = element_line(linewidth = 1, colour = "black")) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) + 
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0)) + 
  theme(plot.title = element_text(size = rel(2.0), angle = 0))

# save output as a pdf file
ggsave("task3.pdf")
cat("\n", "task3.pdf file saved", "\n")

