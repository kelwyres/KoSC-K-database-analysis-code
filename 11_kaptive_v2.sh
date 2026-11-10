#!/bin/bash
#SBATCH --job-name=kaptive2_KoSC
#SBATCH --time=3-00:00:00
#SBATCH --mem=54G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --nodes=1-1
#SBATCH --output=kaptive2_KoSC-%j.log
#SBATCH --error=kaptive2_KoSC-%j.log

# Software
module purge

# Tasks
for file in *.fasta;
do
python3 /software/Kaptive/kaptive.py -a $file \
--gap_fill_size 500 \
-k /software/Kaptive/reference_database/Klebsiella_k_locus_primary_reference.gbk \
-g /software/Kaptive/reference_database/wzi_wzc_db.fasta 
done
