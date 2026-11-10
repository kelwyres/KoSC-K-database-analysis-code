#!/bin/bash
#SBATCH --job-name=kleborate_KoSC
#SBATCH --time=2-00:00:00
#SBATCH --mem=27200
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --nodes=1-1
#SBATCH --output=kleborate_KoSC-%j.log
#SBATCH --error=kleborate_KoSC-%j.log

# Software
module purge
module load blast/2.7.1
module load mash/2.2

source /software/envs/bin/activate # activate miniconda
conda activate /software/envs/envs/Kleborate  # activate conda env

mkdir Kleborate_output

# Tasks
for file in *.fasta; 
do
tag="$(basename $file .fasta)" # basename removes path and you can specify the tag
python3 /software/Kleborate/kleborate-runner.py --force_index --min_identity 85 --min_coverage 85 --min_spurious_identity 70 --min_spurious_coverage 70 --all -o Kleborate_output/"$tag".txt -a $file
done
