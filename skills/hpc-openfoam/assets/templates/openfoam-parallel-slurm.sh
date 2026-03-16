#!/bin/bash
#SBATCH --job-name=openfoam_case
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --time=02:00:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

case_dir="${1:-$PWD}"
solver="${2:-simpleFoam}"

cd "$case_dir"

# module purge
# module load openfoam

decomposePar -force
srun -n "${SLURM_NTASKS}" "$solver" -parallel > "log.${solver}" 2>&1
reconstructPar
