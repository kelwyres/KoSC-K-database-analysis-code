#!/bin/bash
#SBATCH --job-name=metaphlan
#SBATCH --time=3-00:00:00
#SBATCH --mem=27200
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1-1
#SBATCH --output=slurm_logs/metaphlan_KoSC-%j.log
#SBATCH --error=slurm_logs/metaphlan_KoSC-%j.log

# Software
module purge
module load metaphlan/3.0-sif
module load bowtie2/2.3.5

# source /miniconda3/bin/activate # activate miniconda
# conda activate /miniconda3/envs/py3_6 # activate conda env

# Tasks
cat Illumina_paired_end_accessions.txt | while read line;

do
metaphlan /"$line"_1_val_1.fq.gz,/"$line"_2_val_2.fq.gz --input_type fastq --index mpa_v31_CHOCOPhlAn_201901 --bowtie2db /software/databases/metaphlan_database --bowtie2out "$line"_bowtie2.out --nproc 8 -o "$line"_profile.txt
done

