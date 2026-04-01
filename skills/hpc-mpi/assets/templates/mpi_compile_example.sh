#!/bin/bash
set -euo pipefail

src="${1:-mpi_hello_world.c}"
out="${2:-mpi_hello_world}"
compiler="${MPICC:-mpicc}"

"${compiler}" "${src}" -O2 -o "${out}"
