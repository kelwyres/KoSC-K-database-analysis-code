# KoSC K database analysis code

This repository houses example code as used for the development and testing of the [_Klebsiella oxytoca_ Species Complex K locus database](https://github.com/klebgenomics/KoSC-surface-antigen-loci/tree/main), which can be used with [Kaptive](https://github.com/klebgenomics/Kaptive) to type capsule polysaccharide synthesis loci (K loci) from _Klebsiella oxytoca_ Species Complex and _Klebsiella indica_ whole genome sequences. **The code corresponds to the analysis described in [Ashcroft / McGarry et al bioRxiv 2026](https://doi.org/10.64898/2026.07.16.739023) and should be understood alongside the Methods section of the paper, which provides the description and rationale for the approach as well as the full citations for all third party tools.**

The repository is divided into sections that correspond to different sets of analyses. Each section details a list of files within this repository that provide the relevant example code. 

Unless otherwise stated, the analyses were performed on a distributed compute cluster, [M3](https://docs.erc.monash.edu/Compute/HPC/M3/), which leverages a slurm queuing system. The majority of the files outlined below represent example slurm submission scripts. The number of nodes and cores and the amount of memory requested for each analysis are shown within the script. (Note: for security reasons, file paths have been abbreviated, and account and queue names have been removed.)

For full details on the contents of the K locus database and how to use it, please see the dedicated [database repository](https://github.com/klebgenomics/KoSC-surface-antigen-loci/tree/main). 

## Contents
- [Accessing, assembling and QC-ing preliminary dataset](#accessing-assembling-and-qc-ing-preliminary-dataset)
- [QC-ing final dataset and subsetting](#qc-ing-final-dataset-and-subsetting)
- [Database development](database-development)
- [Database testing](database-testing)
- [Data summary, statistics and figures](#data-summary-statistics-and-figures)

## Accessing, assembling and QC-ing preliminary dataset

1. `1_download_sra_reads.sh` - Download reads from European Nucleotide Archive with enaBrowserTools.
2. `2_trim_reads.sh` - Trim Illumina reads with Trim Galore.
3. `3_unicycler.sh` - Assemble Illumina reads with Unicycler.
4. `4_flye.sh` - Assemble PacBio reads with Flye.
5. `5_multi_polishing.sh` - Polish Flye assemblies with Illumina reads, using BWA, SamTools and Pilon.
6. `6_metaphlan.sh` - Run MetaPhlAn on reads to detect species contamination.
7. `7_kleborate_v2.sh`- Run Kleborate on assemblies for species confirmation and assembly statistics.

## QC-ing final dataset and subsetting

8. `8_checkM2.sh` - Run checkM2 on genome assemblies to generate QC metrics for genomes not accessed via AllTheBacteria.
9. `9_mash_dereplication.md` - Includes code for running Mash, plus R code for processing and dereplicating genomes into the non-redundant dataset. (Note: part of this analysis was performed using R, running on a Macbook Air, M4.)  
10. `10_kleborate_v3` - Run Kleborate on assemblies for assembly statistics and 7-gene multi-locus sequence types

## Database development

11. `11_kaptive_v2.sh` - Extract K loci using BLASTn implemented in Kaptive 2.
12. `12_meshclust.sh` - Cluster K loci with MeShClust.
13. `13_prokka.sh` - Annotate loci with Prokka.
14. `14_mmseqs.sh` - All vs all pairwise protein comparison. (Note: this step was run on a Macbook Air, M2.)
15. `15_protein_classification` - this directory contains a Jupyter notebook with the code for clustering (via MMSeqs2) and annotating K locus genes via HMM search. Output tables as defined in the Notebook are also included. (Note: this step was run on a Macbook Air, M2.)
16. `16_K_locus_extraction.md` - Includes python code for extracting additional K loci from assembly files by BLAST search, alongside instructions for running the code and reference flanking gene sequences.
17. `17_clinker.sh` - Run Clinker to visualise and compare loci - change amino acid identity threshold within the graphical interface to identify loci that share all genes above the 82.5% threshold. (Note: this step was run on a Macbook Air, M4.)  

## Database testing

18. `18_kaptive_v3.sh` - Run Kaptive v3.2.1 to generate typing results reported in paper using the _K. oxytoca_ Species Complex database archived [here](10.5281/zenodo.22866203) and the _K. pneumoniae_ Species Complex database archived [here](https://github.com/klebgenomics/Kaptive/releases/tag/v3.2.0).
19. `19_hmm_wzy.sh` - Run HMM search for _wzy_ genes in genomes with K loci without annotated _wzy_. 

## Data summary, statistics and figures

20. `clinker_figure1` - Contains the input files required to generate the Clinker plot in Figure 1. Code for running clinker is provided in `17_clinker.sh`. Change amino acid identity threshold used for 'links' to 82.5% and re-order the loci horizontally to match the figure. Gene names were annotated in Adobe Illustrator. (Note: this step was run on a Macbook Air, M4.)
21. `stats_and_figs_in_R` - Contains the input data files and R code (`.rmd` format) used to generate data summaries and statistics reported in the manuscript, as well as Figures 2 - 4. The code is also provided in a rendered `.html` file. (Note: this step was run on a Macbook Air, M4.) 

## Citations

If you found this resource useful, please cite: 
Ashcroft, M. / McGarry N. _et al._ Genomic characterisation of capsule polysaccharide loci in the _Klebsiella oxytoca_ Species Complex. DOI: https://doi.org/10.64898/2026.07.16.739023

## License

The code is distributed under [GNU Genral Public license v3.0](https://github.com/klebgenomics/KpSC_surface_antigen_loci/blob/main/LICENSE). 
