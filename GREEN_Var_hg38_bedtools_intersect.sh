module load bedtools

#Calculate intersect and overlap with greenvar database files
INPUTFILE=$1 #Random_genomic_ranges_4767_Rep1.bed
FILENAME=$(echo "$INPUTFILE"| cut -d'/' -f2 | cut -d'.' -f1)

bedtools intersect -wa -wb -f 0.90 -a ${INPUTFILE} -b GRCh38_TFBS.merged.bed > ${FILENAME}_file1_TFBS_0.9.txt
bedtools intersect -wa -wb -f 0.90 -a ${INPUTFILE} -b GRCh38_DNase.merged.bed.gz > ${FILENAME}_file2_DNase_0.9.txt
bedtools intersect -wa -wb -f 0.90 -a ${INPUTFILE} -b GRCh38_GREEN-DB.bed.gz > ${FILENAME}_file3_AllGreenDB_0.9.txt
