#!/bin/bash
#SBATCH --job-name=pilon
#SBATCH --time=08:00:00
#SBATCH --mem=54G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --nodes=1-1
#SBATCH --output=multipolish_pilon-%j.log
#SBATCH --error=multipolish_pilon-%j.log

# Software
module purge

module load bwa/0.7.17-gcc5
module load samtools/1.9-gcc5

# Use this to call Pilon which is installed in environment as module load pilon isnt working
source /software/envs/bin/activate # activate miniconda
conda activate /software/envs/envs/panaroo  # activate conda env

# Tasks

cat multi_polish_5_rounds.txt | while read line; 
do

FILE="$line"
R1=/"$line"_1_val_1.fq.gz
R2=/"$line"_2_val_2.fq.gz

bwa index ${FILE}/assembly.fasta
bwa mem -t 24 ${FILE}/assembly.fasta ${R1} ${R2} | samtools sort | samtools view -@ 8 -b  > ${FILE}/${FILE}.bam
samtools index ${FILE}/${FILE}.bam

pilon --genome ${FILE}/assembly.fasta --bam ${FILE}/${FILE}.bam --output ${FILE}/${FILE}_pilon_polish_v1 --minmq 60 --minqual 10 --changes --vcf --fix bases

rm ${FILE}/*.fasta.*
rm ${FILE}/*.bam*

bwa index ${FILE}/${FILE}_pilon_polish_v1.fasta
bwa mem -t 24 ${FILE}/${FILE}_pilon_polish_v1.fasta ${R1} ${R2} | samtools sort | samtools view -@ 8 -b  > ${FILE}/${FILE}.bam
samtools index ${FILE}/${FILE}.bam

pilon --genome ${FILE}/${FILE}_pilon_polish_v1.fasta --bam ${FILE}/${FILE}.bam --output ${FILE}/${FILE}_pilon_polish_v2 --minmq 60 --minqual 10 --changes --vcf --fix bases

rm ${FILE}/*.fasta.*
rm ${FILE}/*.bam*

bwa index ${FILE}/${FILE}_pilon_polish_v2.fasta
bwa mem -t 24 ${FILE}/${FILE}_pilon_polish_v2.fasta ${R1} ${R2} | samtools sort | samtools view -@ 8 -b  > ${FILE}/${FILE}.bam
samtools index ${FILE}/${FILE}.bam

pilon --genome ${FILE}/${FILE}_pilon_polish_v2.fasta --bam ${FILE}/${FILE}.bam --output ${FILE}/${FILE}_pilon_polish_v3 --minmq 60 --minqual 10 --changes --vcf --fix bases

rm ${FILE}/*.fasta.*
rm ${FILE}/*.bam*

bwa index ${FILE}/${FILE}_pilon_polish_v3.fasta
bwa mem -t 24 ${FILE}/${FILE}_pilon_polish_v3.fasta ${R1} ${R2} | samtools sort | samtools view -@ 8 -b  > ${FILE}/${FILE}.bam
samtools index ${FILE}/${FILE}.bam

pilon --genome ${FILE}/${FILE}_pilon_polish_v3.fasta --bam ${FILE}/${FILE}.bam --output ${FILE}/${FILE}_pilon_polish_v4 --minmq 60 --minqual 10 --changes --vcf --fix bases

rm ${FILE}/*.fasta.*
rm ${FILE}/*.bam*

bwa index ${FILE}/${FILE}_pilon_polish_v4.fasta
bwa mem -t 24 ${FILE}/${FILE}_pilon_polish_v4.fasta ${R1} ${R2} | samtools sort | samtools view -@ 8 -b  > ${FILE}/${FILE}.bam
samtools index ${FILE}/${FILE}.bam

pilon --genome ${FILE}/${FILE}_pilon_polish_v4.fasta --bam ${FILE}/${FILE}.bam --output ${FILE}/${FILE}_pilon_polish_v5 --minmq 60 --minqual 10 --changes --vcf --fix bases

rm ${FILE}/*.bam*

done


