#!/bin/bash
#SBATCH --job-name=cuda_single
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gpus=1
#SBATCH --time=00:10:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

exe="${1:-./cuda_vector_add_minimal}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load cuda

export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
srun -n 1 "${exe}"
