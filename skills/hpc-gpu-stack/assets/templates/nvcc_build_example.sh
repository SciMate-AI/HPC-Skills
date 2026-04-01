#!/bin/bash
set -euo pipefail

src="${1:-cuda_vector_add_minimal.cu}"
out="${2:-cuda_vector_add_minimal}"
cuda_arch="${CUDA_ARCH:-sm_80}"
host_cxx="${HOST_CXX:-}"

cmd=(nvcc "${src}" -O3 -o "${out}" "-arch=${cuda_arch}")
if [ -n "${host_cxx}" ]; then
  cmd+=(-ccbin "${host_cxx}")
fi

"${cmd[@]}"
