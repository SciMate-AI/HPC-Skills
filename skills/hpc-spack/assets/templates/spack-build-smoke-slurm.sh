#!/bin/bash
#SBATCH --job-name=spack_smoke
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:30:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

env_dir="${1:-$PWD/spack-env}"
spack_root="${SPACK_ROOT:-}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load spack

if [ -n "${spack_root}" ]; then
  # Shell support is required for `spack env activate`.
  # shellcheck disable=SC1091
  . "${spack_root}/share/spack/setup-env.sh"
fi

spack env activate "${env_dir}"
spack concretize
spack install -j "${SLURM_CPUS_PER_TASK}"
