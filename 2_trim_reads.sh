#!/bin/bash
#SBATCH --job-name=Illumina_trim
#SBATCH --time=1-00:00:00
#SBATCH --mem=54G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1-1
#SBATCH --output=trimming-%j.log
#SBATCH --error=trimming-%j.log

# Software
module purge
# using cutadapt version 3.3 causes trim galore to break
module load trim_galore/0.5.0

# Tasks
cat accessions.txt | 
while read line;
do
trim_galore --paired --phred33 -q 20 /EKNZ/"$line"_1.fastq.gz /EKNZ/"$line"_2.fastq.gz
done
