# 2024_GenomeWideMethylationPaper

This repository contains all the accessory scripts used in the paper LaFlamme, Christy W., _et al_. "Diagnostic Utility of Genome-wide DNA Methylation Analysis in Genetically Unsolved Developmental and Epileptic Encephalopathies and Refinement of a CHD2 Episignature." _medRxiv_ (2023): 2023-10.

## Description of scripts
*DMR_intersect_Array.pl* : Script to intersect DMRcate and Bumphunter calls for Array.  
*DMR_intersect_WGBS.pl* : Script to intersect DMRcate and DSS calls for WGBS.  
*annotation_percentage_calculator_T1.WGBS.pl* : Script to calculate proportional annotation for each CpG island w.r.t to intergenic, islands, shelves and shores in WGBS data.  
*annotation_percentage_calculator_T2.EPIC.and.WGBSOverlap.pl* : Script to calculate proportional annotation for each CpG island w.r.t to intergenic, islands, shelves and shores in EPIC data.  
*annotation_percentage_calculator_T3.pl* : Script to calculate proportional annotation for each CpG island w.r.t gene features such as UTRs, exons, introns, etc in WGBS data.
*overlap_calculator_and_merge_DMRs_count_samples_merge_sample_names.pl* : 
*GREEN_Var_hg38_bedtools_intersect.sh* : Script to intersect annotation resources with CHD2-Array/DMRs. A 90% cutoff maintained while annotatiing the regions with features as described in the methods section.  
*selected_GreenVarDB_links.sh* : Script to download resources used for annotation of CHD2-Array/DMRs.
