# KoSC K database analysis code

This repository houses example code as used for the development and testing of the [_Klebsiella oxytoca_ Species Complex K locus database](https://github.com/klebgenomics/KoSC-surface-antigen-loci/tree/main), which can be used with [Kaptive](https://github.com/klebgenomics/Kaptive) to type capsule polysaccharide synthesis loci (K loci) from _Klebsiella oxytoca_ Species Complex and _Klebsiella indica_ whole genome sequences. **The code corresponds to the analysis described in [Ashcroft / McGarry et al bioRxiv 2026](https://doi.org/10.64898/2026.07.16.739023) and should be understood alongside the Methods section of the paper, which provides the description and rationale for the approach as well as the full citations for all third party tools.**

The repository is divided into sections that correspond to different sets of analyses. The compute infrastructure used to deploy the analyses is described at the start of each section, followed by a list of files within this repository that give example code for each step of the analysis. 

For full details on the contents of the K locus database and how to use it, please see the dedicated [database repository](https://github.com/klebgenomics/KoSC-surface-antigen-loci/tree/main). 

## Contents
- [Accessing, assembling and QC-ing preliminary dataset](#accessing-assembling-and-qc-ing-preliminary-dataset)
- [QC-ing final dataset and subsetting](#qc-ing-final-dataset-and-subsetting)
- [Database development](database-development)
- [Database testing](database-testing)
- [Data summary, statistics and figures](#data-summary-statistics-and-figures)

## Accessing, assembling and QC-ing preliminary dataset

These analyses were performed on a distributed compute cluster, [M3](https://docs.erc.monash.edu/Compute/HPC/M3/), which leverages a slurm queuing system. The majority of the files outlined below represent example slurm submission scripts. The number of nodes and cores and the amount of memory requested for each analysis is shown within the script. (Note: for security reasons, file paths have been abbreviated, and account and queue names have been removed.)

1. `1_download_sra_reads.sh` - download reads from European Nucleotide Archive with enaBrowserTools
2. `2_trim_reads.sh` - trim Illumina reads with Trim Galore
3. `3_unicycler.sh` - assemble Illumina reads with Unicycler
4. `4_flye.sh` - assemble PacBio reads with Flye
5. `5_multi_polishing.sh` - polish Flye assemblies with Illumina reads, using BWA, SamTools and Pilon
6. `6_metaphlan.sh` - run MetaPhlAn on reads to detect species contamination
7. `7_kleborate_v2.sh`- run Kleborate on assemblies for species confirmation and assembly statistics

## QC-ing final dataset and subsetting

These analyses were performed on a distributed compute cluster, [M3](https://docs.erc.monash.edu/Compute/HPC/M3/), which leverages a slurm queuing system. The number of nodes and cores and the amount of memory requested for each analysis is shown within the slurm submission scripts. (Note: for security reasons, file paths have been abbreviated, and account and queue names have been removed.) The Mash dereplication process was partly perfomed within R on a standard Macbook Air, M4 (see file 9 for details).

8. `8_checkM2.sh` - run checkM2 on genome assemblies to generate QC metrics for genomes not accessed via AllTheBacteria
9. `9_mash_dereplication.md` - includes code for running Mash on the M3 compute infrastructure, plus R code for processing and dereplicating genomes into the non-redundant dataset
10. `10_kleborate_v3 - run Kleborate on assemblies for assembly statistics and 7-gene multi-locus sequence types

## Database development

These analyses were performed on a distributed compute cluster, [M3](https://docs.erc.monash.edu/Compute/HPC/M3/), which leverages a slurm queuing system. The majority of the files outlined below represent example slurm submission scripts. The number of nodes and cores and the amount of memory requested for each analysis is shown within the script. (Note: for security reasons, file paths have been abbreviated, and account and queue names have been removed.)

11. `11_kaptive_v2.sh` - extract K loci using BLASTn implemented in Kaptive 2
12. `12_meshclust.sh` - cluster K loci with MeShClust
13. `13_prokka.sh` - annotate loci with Prokka
14. `14_mmseqs.sh` - all vs all pairwise protein comparison
15. `15_hmm.sh` - run HMM search to inform manual annotation updates
16. `16_K_locus_extraction.md` - includes python code for extracting additional K loci from assembly files by BLAST search, alongside instructions for running the code and reference flanking gene sequences
17. `17_clinker.sh` - run Clinker to visualise and compare loci - change amino acid identity threshold within the graphical interface to identify loci that share all genes above the 82.5% threshold. (Note: Clinker was run on a Macbook Air, M4)  

## Database testing

18. `18_kaptive_v3.sh` - run Kaptive v3.2.1 to generate typing results reported in paper using the _K. oxytoca_ Species Complex database archived [here](10.5281/zenodo.22866203) and the _K. pneumoniae_ Species Complex database archived here
19. `19_hmm_wzy.sh` - run HMM search for _wzy_ genes in genomes with K loci without annotated _wzy_ 

## Citations

If you found **this resource** useful, please cite: 
Ashcroft, M. / McGarry N. _et al._ Genomic characterisation of capsule polysaccharide loci in the _Klebsiella oxytoca_ Species Complex. DOI: https://doi.org/10.64898/2026.07.16.739023

If you use the **K locus database** please cite:  
Wyres _et al._ 2016. Identification of _Klebsiella_ capsule synthesis loci from whole genome data. Microbial Genomics:2(12) DOI: [10.1099/mgen.0.000102](https://doi.org/10.1099/mgen.0.000102).


## License

The code is distributed under [GNU Genral Public license v3.0](https://github.com/klebgenomics/KpSC_surface_antigen_loci/blob/main/LICENSE). 
