#!/bin/bash
#SBATCH --job-name=checkm2_KoSC
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=checkm2_%j.out

module load miniforge3/24.3.0-0
conda activate /software/conda_envs/checkm2_v1.1.0

checkm2 predict -i . -x fasta -o checkm2_results --threads 16

# Run from directory with *.fasta* files
# v1.1.0 CheckM2 used