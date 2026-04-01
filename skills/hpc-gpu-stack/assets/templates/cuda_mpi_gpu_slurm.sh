#!/bin/bash
#SBATCH --job-name=cuda_mpi
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=2
#SBATCH --gpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

exe="${1:-./cuda_vector_add_minimal}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load cuda
# module load mpi-stack

export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
srun -n "${SLURM_NTASKS}" --gpus-per-task=1 "${exe}"
