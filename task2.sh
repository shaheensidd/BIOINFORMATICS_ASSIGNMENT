# create a folder for task2
mkdir TASK_2


# enter the folder, task2 to be done in TASK_2 folder 
cd TASK_2


# remove files if any 
rm -rf *


# download the FASTA file from source
wget https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa


# check file is present in TASK_2 folder
echo "file downloaded"
ls

echo ""



# find total number of sequences (total amino acids)
total_number_sequences=$(grep -c "^>" NC_000913.faa) # counting > in the beginning of a line i.e. counts the number of lines in the file NC_000913.faa that start with > 
echo "Total number of sequences in the NC_000913.faa file : $total_number_sequences"

# find total length of all sequences
# 1. filters out lines that start with >
# 2. removes line breaks from the output of the previous grep command
# 3. calculates the length
total_length_sequences=$(grep -v "^>" NC_000913.faa | tr -d '\n' | wc -c)
echo "Total length of all sequences given in the NC_000913.faa file : $total_length_sequences"

# calculate average length of protein in E. coli MG1655 strain
protein_average_length=$((total_length_sequences / total_number_sequences))
echo "Average length of protein in E. coli MG1655 strain : $protein_average_length"
