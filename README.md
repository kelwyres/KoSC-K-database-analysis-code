# KoSC K database analysis code

This repository houses example code as used for the development and testing of the [_Klebsiella oxytoca_ Species Complex K locus database](https://github.com/klebgenomics/KoSC-surface-antigen-loci/tree/main), which can be used with [Kaptive](https://github.com/klebgenomics/Kaptive) to type capsule polysaccharide synthesis loci (K loci) from _Klebsiella oxytoca_ Species Complex and _Klebsiella indica_ whole genome sequences. **The code corresponds to the analysis described in [Ashcroft / McGarry et al bioRxiv 2026](https://doi.org/10.64898/2026.07.16.739023) and should be understood alongside the Methods section of the paper, which provides the description and rationale for the approach as well as the full citations for all third party tools.**

The repository is divided into sections that correspond to different sets of analyses. The compute infrastructure used to deploy the analyses is described at the start of each section, followed by a list of files within this repository that give example code for each step of the analysis. 

For full details on the contents of the K locus database and how to use it, please see the dedicated [database repository](https://github.com/klebgenomics/KoSC-surface-antigen-loci/tree/main). 

## Contents
- [Accessing, assembling and QC-ing preliminary dataset](#accessing-assembling-and-qc-ing-preliminary-dataset)
- [QC-ing final dataset and subsetting](#qc-ing-final-dataset-and-subsetting)
- [Database development](database-development)
- [Database testing](database-testing)
- [Figures and statistics](#figures-and-statistics)

## Accessing, assembling and QC-ing preliminary dataset

These analyses were performed on a distributed compute cluster, [M3](https://docs.erc.monash.edu/Compute/HPC/M3/), which leverages a slurm queuing system. The majority of the files outlined below represent example slurm submission scripts. The number of nodes and cores and the amount of memory requested for each analysis is shown within the script. (Note: for security reasons, file paths have been abbreviated, and account and queue names have been removed.)

1. `1_download_sra_reads.sh` - download reads with enaBrowserTools
2. `2_trim_reads.sh` - trim Illumina reads with Trim Galore
3. `3_unicycler.sh` - assemble short reads with Unicycler
4. `4_flye.sh` - assemble long reads with Flye
5. `5_multi_polishing.sh` - polish long read assemblies with short reads, using BWA, SamTools and Pilon
6. `6_metaphlan.sh` - run MetaPhlAn on reads
7. `7_kleborate.sh`- run Kleborate

## QC-ing final dataset and subsetting


## Database development

These analyses were performed on a distributed compute cluster, [M3](https://docs.erc.monash.edu/Compute/HPC/M3/), which leverages a slurm queuing system. The majority of the files outlined below represent example slurm submission scripts. The number of nodes and cores and the amount of memory requested for each analysis is shown within the script. (Note: for security reasons, file paths have been abbreviated, and account and queue names have been removed.)

`kaptive.sh` - extract K loci using BLASTn implemented in Kaptive 2
`meshclust.sh` - cluster K loci with MeShClust
`prokka.sh` - annotate loci with Prokka
`mmseqs.sh` - all vs all pairwise protein comparison
`hmm.sh` - run HMM search to inform manual annotation updates
`clinker.sh` - run Clinker to visualise and compare loci - change amino acid identity threshold within the graphical interface to identify loci that share all genes above the 82.5% threshold. (Note: Clinker was run on a Macbook Air, M4)  

## Database testing


## Figures and statistics




## Citations

If you found **this resource** useful, please cite: 
Ashcroft, M. / McGarry N. _et al._ Genomic characterisation of capsule polysaccharide loci in the _Klebsiella oxytoca_ Species Complex. DOI: https://doi.org/10.64898/2026.07.16.739023

If you use the **K locus database** please cite:  
Wyres _et al._ 2016. Identification of _Klebsiella_ capsule synthesis loci from whole genome data. Microbial Genomics:2(12) DOI: [10.1099/mgen.0.000102](https://doi.org/10.1099/mgen.0.000102).


## License

The code is distributed under [GNU Genral Public license v3.0](https://github.com/klebgenomics/KpSC_surface_antigen_loci/blob/main/LICENSE). 
