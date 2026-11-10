#!/bin/bash
#SBATCH --job-name=kleborate_kosc
#SBATCH --time=04:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=1
#SBATCH --output=/scripts/kleborate_kosc_%j.out
#SBATCH --error=/scripts/kleborate_kosc_%j.err

module load miniforge3/24.3.0-0
conda activate /software/kleborate_v3.2.4

kleborate \
  -a *.fasta \
  -o kleborate_results \
  -p kosc \
  --trim_headers