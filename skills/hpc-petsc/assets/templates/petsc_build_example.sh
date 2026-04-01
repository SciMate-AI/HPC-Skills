#!/bin/bash
set -euo pipefail

src="${1:-ksp_poisson_minimal.c}"
out="${2:-ksp_poisson_minimal}"
compiler="${MPICC:-mpicc}"

if command -v pkg-config >/dev/null 2>&1 && pkg-config --exists PETSc; then
  "${compiler}" "${src}" -o "${out}" $(pkg-config --cflags --libs PETSc)
elif [ -n "${PETSC_DIR:-}" ] && [ -n "${PETSC_ARCH:-}" ]; then
  "${compiler}" "${src}" -o "${out}" \
    -I"${PETSC_DIR}/include" \
    -I"${PETSC_DIR}/${PETSC_ARCH}/include" \
    -L"${PETSC_DIR}/${PETSC_ARCH}/lib" -lpetsc
else
  echo "Set pkg-config for PETSc or export PETSC_DIR and PETSC_ARCH" >&2
  exit 1
fi
