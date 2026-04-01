#!/bin/bash
#SBATCH --job-name=mpi_hybrid
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=2
#SBATCH --time=00:10:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

exe="${1:-./mpi_hello_world}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load mpi-stack

export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
srun -n "${SLURM_NTASKS}" -c "${SLURM_CPUS_PER_TASK}" "${exe}"
