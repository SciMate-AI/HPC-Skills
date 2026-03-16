#!/bin/bash
#SBATCH --job-name=calculix_job
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=02:00:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

job_name="${1:-model}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load calculix

srun -n 1 ccx -i "$job_name"
