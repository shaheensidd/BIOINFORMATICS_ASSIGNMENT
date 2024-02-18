# check the working directory
getwd()

# install package/library 
library(dplyr)    
library(readr)

# import the given data file Homo_sapiens.gene_info.gz
gene_info_df <- read_tsv("Homo_sapiens.gene_info.gz", show_col_types = 'FALSE')
cat("Original dimension : ", dim(gene_info_df), "\n")

# Filter the column numbers which are to be sub-setted from the Original dataframe
columns_to_subset <- c(2, 3, 5)
#
# Filter all rows based on the columns to subset the dataframe
subset_gene_info_df <- gene_info_df[, columns_to_subset]
cat("Filtered dimension : ", dim(subset_gene_info_df), "\n")
#
# check subset_gene_info_df columns or filtered column names
cat("Filtered column are : ", colnames(subset_gene_info_df), "\n")

# CREATE MAPPINGS
message("......CREATING Symbol TO GeneID MAPPINGS......")
symbol_to_geneid_func <- function(df) {
  # create and empty list for mapping Symbol to GeneID
  symbol_to_geneid_map <- list()
  # loop over each row
  for (i in 1:nrow(df)) {
    #print(i)       #printing nth row number
    row <- df[i,]  #storing nth row
    #print(row)
    #
    # Get new symbols (from Synonyms column seaprated by |) for each row
    new_symbols <- strsplit(as.character(row$Synonyms), "|", fixed = TRUE)[[1]]
    #convert new_symbols to list
    symbol_list <-  as.list(unique(new_symbols))  
    # Compare total_symbol_list & symbol_list & Remove common elements from second list i.e. symbol_list
    symbol_list <- symbol_list[!(symbol_list %in% total_symbol_list)]
    # Unlist the updated symbol_list 
    symbol_list <- unlist(symbol_list)
    #print(symbol_list)
    #
    #
    # Append symbol_to_geneid_map with key-value pairs (for column Symbol & GeneID)
    symbol_to_geneid_map[[as.character(row$Symbol)]] <- as.character(row$GeneID)
    #
    if(length(symbol_list > 0))  #to skip empty list
    { 
      #print("TRUE")
      for (count in 1:length(symbol_list)) 
      {
        # Append symbol_to_geneid_map with key-value pairs (for column Synonyms & GeneID)
        symbol_to_geneid_map[[symbol_list[count]]] <- as.character(row$GeneID)
      }
    }
    #print("---------------------------------------------------------------------------------")
  }
  #
  return(symbol_to_geneid_map)
}


# to test for small subset of subset_gene_info_df
#new_df1 <- head(subset_gene_info_df, 5000)

# find unique Symbols in subset_gene_info_df and store them in a list 
total_symbol_list = as.list(unique(subset_gene_info_df$Symbol))
total_symbol_list = append(total_symbol_list, '-')
#print(total_symbol_list)

# calling function symbol_to_geneid_map with subsetted/filtered dataframe i.e. subset_gene_info_df
symbol_to_geneid_map <- symbol_to_geneid_func(subset_gene_info_df)
#symbol_to_geneid_map

# Extract keys (Symbol)
keys = list()
for (i in names(symbol_to_geneid_map))
{
  keys = append(keys, i)
}

# Extract values (GeneID)
values = list()
for (j in symbol_to_geneid_map)
{
  values = append(values, j)
}
#
# Print the length keys and values (should be equal)
cat("Total keys (i.e. Symbol) : ", length(keys), "\n")
cat("Total values (i.e. GeneID) : ", length(values), "\n")

# make a dataframe of Symbol to GeneID mapping
mapping_df = data.frame(Symbol=unlist(keys), GeneID=unlist(values))
# write the dataframe to a gene_info.csv file
write.csv(mapping_df, "gene_info.csv", row.names=FALSE)
cat("\n", "gene_info.csv Symbol to GeneID MAPPING file saved", "\n")

# reading gene_info.csv file
mapping_file <- read.csv("gene_info.csv")

# Load the given GMT file
gmt_file <- "h.all.v2023.1.Hs.symbols.gmt"  
# Read the given GMT file
gmt_data <- readLines(gmt_file)

# create a new object to store old and updated information
final_gmt_data <- gmt_data

# seq_along() creates a sequence from 1 up to the length of its input.
for (i in seq_along(gmt_data)) {
  #print(i)  # print line number
  old_gene_set <- unlist(strsplit(gmt_data[i], "\t"))
  # The first two values are “pathway name" and”pathway description" which has to be removed 
  gene_symbols <- old_gene_set[-c(1, 2)]
  #print(gene_symbols)
  #
  # Replace Symbol with GeneID if mapping is present, otherwise retain the original Symbol
  gene_set_ids <- ifelse(gene_symbols %in% mapping_file$Symbol,
                         mapping_file$GeneID[match(gene_symbols, mapping_file$Symbol)],
                         gene_symbols)    
  #print(gene_set_ids)
  # Update the gene_set_ids in the Original GMT file
  new_gene_set <- paste(c(old_gene_set[1:2], gene_set_ids), collapse = "\t")
  final_gmt_data[i] <- new_gene_set
}

# Save the final updated GMT file
writeLines(final_gmt_data, "updated_h.all.v2023.1.Hs.symbols.gmt")  
cat("\n", "updated_h.all.v2023.1.Hs.symbols.gmt file saved ", "\n")

# Load & Read the final updated GMT file
updated_gmt_file <- "updated_h.all.v2023.1.Hs.symbols.gmt"  
updated_gmt_data <- readLines(updated_gmt_file)

cat("\n", "Contents of Original GMT file : ", gmt_data, "\n")
cat("\n", "Contents of Updated GMT file : ", updated_gmt_data, "\n")



