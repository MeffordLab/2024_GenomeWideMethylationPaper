# 2024_GenomeWideMethylationPaper

This repository contains all the accessory scripts used in the paper LaFlamme, Christy W., _et al_. "Diagnostic Utility of Genome-wide DNA Methylation Analysis in Genetically Unsolved Developmental and Epileptic Encephalopathies and Refinement of a CHD2 Episignature." _medRxiv_ (2023): 2023-10.

### Description of scripts
1. [*DMR_intersect_Array.pl*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/DMR_intersect_Array.pl) : Script to intersect DMRcate and Bumphunter calls for Array.  
2. [*DMR_intersect_WGBS.pl*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/DMR_intersect_WGBS.pl) : Script to intersect DMRcate and DSS calls for WGBS.  
3. [*annotation_percentage_calculator_T1.WGBS.pl*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/annotation_percentage_calculator_T1.WGBS.pl) : Script to calculate proportional annotation for each CpG island w.r.t to intergenic, islands, shelves and shores in WGBS data.  
4. [*annotation_percentage_calculator_T2.EPIC.and.WGBSOverlap.pl*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/annotation_percentage_calculator_T2.EPIC.and.WGBSOverlap.pl) : Script to calculate proportional annotation for each CpG island w.r.t to intergenic, islands, shelves and shores in EPIC data.  
5. [*annotation_percentage_calculator_T3.pl*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/annotation_percentage_calculator_T3.pl) : Script to calculate proportional annotation for each CpG island w.r.t gene features such as UTRs, exons, introns, etc in WGBS data.
6. [*overlap_calculator_and_merge_DMRs_count_samples_merge_sample_names.pl*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/overlap_calculator_and_merge_DMRs_count_samples_merge_sample_names.pl) : Script to merge contiguous DMRs if overlap is > 50 bp.  
7. [*generate_random_genomic_ranges.pl*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/generate_random_genomic_ranges.pl) : Generate random genomic regions of varying lengths with parameters minimium and maximum lengths, total number of regions. Takes into account Humna hg38 chromosome lengths.  
8. [*GREEN_Var_hg38_bedtools_intersect.sh*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/GREEN_Var_hg38_bedtools_intersect.sh) : Script to intersect annotation resources with CHD2-Array/DMRs. A 90% cutoff maintained while annotatiing the regions with features as described in the methods section.  
9. [*selected_GreenVarDB_links.sh*](https://github.com/MeffordLab/2024_GenomeWideMethylationPaper/blob/main/selected_GreenVarDB_links.sh) : Script to download resources used for annotation of CHD2-Array/DMRs.
