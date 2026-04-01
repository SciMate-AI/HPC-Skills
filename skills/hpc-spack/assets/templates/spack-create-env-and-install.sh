#!/bin/bash
set -euo pipefail

env_dir="${1:-$PWD/spack-env}"
manifest="${2:-spack-env-minimal.yaml}"
spack_root="${SPACK_ROOT:-}"

if [ -n "${spack_root}" ]; then
  # Shell support is required for `spack env activate`.
  # shellcheck disable=SC1091
  . "${spack_root}/share/spack/setup-env.sh"
fi

mkdir -p "${env_dir}"
cp "${manifest}" "${env_dir}/spack.yaml"

cd "${env_dir}"
spack env activate .
spack concretize
spack install
