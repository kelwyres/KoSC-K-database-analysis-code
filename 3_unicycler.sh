#!/bin/bash
#SBATCH --job-name=unicycler
#SBATCH --time=1-00:00:00
#SBATCH --mem=27200
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1-1
#SBATCH --output=unicycler-%j.log
#SBATCH --error=unicycler-%j.log

# Software
module purge
# using cutadapt version 3.3 causes trim galore to break
module load python/3.8.5
module load blast+/2.0.0
module load unicycler/0.4.7


# Tasks
unicycler -1 /ERR1015328_1_val_1.fq.gz -2 /ERR1015328_2_val_2.fq.gz -o ERR1015328
