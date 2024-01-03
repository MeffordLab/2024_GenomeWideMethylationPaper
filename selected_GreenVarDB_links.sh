#!/bin/bash
#https://github.com/edg1983/GREEN-VARAN/blob/master/resources/GREENDB_collection.txt

#GRCh38_TFBS regions
wget -c https://zenodo.org/record/5705936/files/GRCh38_TFBS.merged.bed.gz
wget -c https://zenodo.org/record/5705936/files/GRCh38_TFBS.merged.bed.gz.csi

#GRCh38_DNase regions 
wget -c https://zenodo.org/record/5705936/files/GRCh38_DNase.merged.bed.gz
wget -c https://zenodo.org/record/5705936/files/GRCh38_DNase.merged.bed.gz.csi

#GRCh38_GREENDB_bed GREENDB_bed 
wget -c https://zenodo.org/record/5636209/files/GRCh38_GREEN-DB.bed.gz
wget -c https://zenodo.org/record/5636209/files/GRCh38_GREEN-DB.bed.gz.csi