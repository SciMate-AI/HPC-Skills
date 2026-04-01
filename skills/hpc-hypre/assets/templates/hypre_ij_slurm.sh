#!/bin/bash
#SBATCH --job-name=hypre_ij
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

exe="${1:-./hypre_ij_pcg_boomeramg}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load hypre

export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
srun -n "${SLURM_NTASKS}" "${exe}"
