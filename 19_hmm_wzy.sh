#!/bin/bash
#SBATCH --job-name=hmmscan_wzy
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --output=hmmscan_wzy_%j.out
#SBATCH --error=hmmscan_wzy_%j.err

module purge
module load miniforge3/24.3.0-0
conda activate /conda_envs/hmmer_3.4

while read -r a; do
  f=$(ls "${a}"*.faa 2>/dev/null | head -1) || continue
  hmmscan --cpu 8 --tblout "${a}_wzy.tblout" Wzy.hmm "$f" > "${a}_wzy.out"
done < assemblies_without_wzy_in_KL.txt

# Assemblies carrying KL without a Wzy hit were screened for Wzy outside the K locus
# Assemblies found to have a hit outside the K locus were uploaded to Proksee/PHASTEST to check if the hit 
# was on a prophage https://proksee.ca/tools/phastest
# Bitscore threshold >35 was used to define putative hits to Wzy
# as outlined in https://doi.org/10.21203/rs.3.rs-9286338/v1