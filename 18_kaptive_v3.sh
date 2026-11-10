#!/bin/bash
#SBATCH --job-name=kaptive_v321
#SBATCH --time=04:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --output=kaptive_v321_%j.out
#SBATCH --error=kaptive_v321_%j.err

module load miniforge3/24.3.0-0

conda activate /software/kaptive_v3.2.1


kaptive assembly \
  Klebsiella_oxytoca_Species_Complex_K_locus_database.gbk \
  *.fasta \
  -o v3.2.1_KoSC_K_kaptive_results.tsv

  # replace 'Klebsiella_oxytoca_Species_Complex_K_locus_database.gbk' with the relevant database gbk file name
  # ensure matched database .logic file is in the same directory
  # Files for running the version of the K. oxytoca Species Complex database used in the publication are archived at
  # https://doi.org/10.64898/2026.07.16.739023.