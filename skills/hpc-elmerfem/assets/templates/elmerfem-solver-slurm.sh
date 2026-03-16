#!/bin/bash
#SBATCH --job-name=elmer_case
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=02:00:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

sif_file="${1:-case.sif}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load elmerfem

srun -n "${SLURM_NTASKS}" ElmerSolver "$sif_file" > elmer.log 2>&1
