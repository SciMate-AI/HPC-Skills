#!/bin/bash
set -euo pipefail

src_dir="${1:-$PWD}"
build_dir="${2:-build-gcc-openmpi-release}"

# module purge
# module load gcc
# module load openmpi

export CC="${CC:-mpicc}"
export CXX="${CXX:-mpicxx}"
export FC="${FC:-mpifort}"

cmake -S "${src_dir}" -B "${build_dir}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER="${CC}" \
  -DCMAKE_CXX_COMPILER="${CXX}" \
  -DCMAKE_Fortran_COMPILER="${FC}"

cmake --build "${build_dir}" -j "${BUILD_JOBS:-8}"
