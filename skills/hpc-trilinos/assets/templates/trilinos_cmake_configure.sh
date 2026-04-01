#!/bin/bash
set -euo pipefail

src_dir="${1:-$PWD}"
build_dir="${2:-build-trilinos-app}"
trilinos_dir="${TRILINOS_DIR:-}"

if [ -z "${trilinos_dir}" ]; then
  echo "Export TRILINOS_DIR to the Trilinos install prefix or CMake package path" >&2
  exit 1
fi

cmake -S "${src_dir}" -B "${build_dir}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DTrilinos_DIR="${trilinos_dir}"

cmake --build "${build_dir}" -j "${BUILD_JOBS:-8}"
