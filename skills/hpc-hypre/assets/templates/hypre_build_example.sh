#!/bin/bash
set -euo pipefail

src="${1:-hypre_ij_pcg_boomeramg.c}"
out="${2:-hypre_ij_pcg_boomeramg}"
compiler="${MPICC:-mpicc}"

if [ -z "${HYPRE_DIR:-}" ]; then
  echo "Export HYPRE_DIR to the hypre install prefix" >&2
  exit 1
fi

"${compiler}" "${src}" -o "${out}" \
  -I"${HYPRE_DIR}/include" \
  -L"${HYPRE_DIR}/lib" -lHYPRE
