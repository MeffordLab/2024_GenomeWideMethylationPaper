#!/bin/bash
#https://github.com/edg1983/GREEN-VARAN/blob/master/resources/GREENDB_collection.txt

wget -c GRCh38_TFBS regions https://zenodo.org/record/5705936/files/GRCh38_TFBS.merged.bed.gz
wget -c GRCh38_TFBS regions https://zenodo.org/record/5705936/files/GRCh38_TFBS.merged.bed.gz.csi
wget -c GRCh38_DNase regions https://zenodo.org/record/5705936/files/GRCh38_DNase.merged.bed.gz
wget -c GRCh38_DNase regions https://zenodo.org/record/5705936/files/GRCh38_DNase.merged.bed.gz.csi
wget -c GRCh38_GREENDB_bed GREENDB_bed https://zenodo.org/record/5636209/files/GRCh38_GREEN-DB.bed.gz
wget -c GRCh38_GREENDB_bed GREENDB_bed https://zenodo.org/record/5636209/files/GRCh38_GREEN-DB.bed.gz.csi