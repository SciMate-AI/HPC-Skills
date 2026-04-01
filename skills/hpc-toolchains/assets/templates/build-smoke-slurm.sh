#!/bin/bash
#SBATCH --job-name=toolchain_smoke
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:20:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

src_dir="${1:-$PWD}"
build_dir="${2:-build-gcc-openmpi-release}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load gcc
# module load openmpi
# module load cmake

export CC="${CC:-mpicc}"
export CXX="${CXX:-mpicxx}"
export FC="${FC:-mpifort}"

cmake -S "${src_dir}" -B "${build_dir}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER="${CC}" \
  -DCMAKE_CXX_COMPILER="${CXX}" \
  -DCMAKE_Fortran_COMPILER="${FC}"

cmake --build "${build_dir}" -j "${SLURM_CPUS_PER_TASK}"
