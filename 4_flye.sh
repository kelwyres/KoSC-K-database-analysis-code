#!/bin/bash
#SBATCH --job-name=SequelII_flye
#SBATCH --time=3-00:00:00
#SBATCH --mem=27200
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1-1
#SBATCH --output=slurm_logs/flye-%j.log
#SBATCH --error=slurm_logs/flye-%j.log

# Software
module purge

module load flye/2.8
# module load blast/2.7.1
# module load mash/2.2

# Tasks
cat pacbio_longreads.txt | while read line ;
do
flye --pacbio-hifi /pacbio_sequelII/$line/"$line".fastq.gz --out-dir /pacbio_sequellII/$line -i 5 --threads 16 --asm-coverage 40 -g 6m
done

