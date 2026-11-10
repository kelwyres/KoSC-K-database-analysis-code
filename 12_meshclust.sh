#!/bin/bash
#SBATCH --job-name=meshclust
#SBATCH --time=04:00:00
#SBATCH --mem=54G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1-1
#SBATCH --output=meshclust_KoSC-%j.log
#SBATCH --error=meshclust_KoSC-%j.log

# Software
module purge
# need this to run meshclust
module load gcc/8.1.0

source /software/envs/bin/activate # activate miniconda
conda activate /software/envs/meshclust # activate conda env

# Tasks

meshclust -d all_extracted_capsule_seqs.fasta -o output.txt -t 0.90 -e y -a n
