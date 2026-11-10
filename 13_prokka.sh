#!/bin/bash
#SBATCH --job-name=prokka
#SBATCH --time=3-00:00:00
#SBATCH --mem=54G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1-1
#SBATCH --output=prokka_dereplicated-%j.log
#SBATCH --error=prokka_dereplicated-%j.log

# Software
module purge

source /software/envs/bin/activate # activate miniconda
conda activate /software/envs/envs/panaroo # activate conda env


# Tasks
cat accessions.txt | while read line; 
do
prokka --outdir prokka/$line --gcode 11 --addgenes --genus Klebsiella --strain $line --cpus 16 --proteins /ref_db/Klebsiella_k_locus_primary_reference_locusupd_noprotIDs_v2.gbk --force --centre X --compliant "$line".fasta
done
