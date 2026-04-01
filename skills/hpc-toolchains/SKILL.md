---
name: hpc-toolchains
description: Build, review, debug, and stabilize HPC compiler and build-toolchain workflows. Use when choosing compiler families such as GCC, Clang, or oneAPI; configuring CMake, `find_package`, or toolchain files; aligning BLAS or LAPACK or MPI stacks; using environment modules or Spack; or repairing ABI, link, and build-system failures.
---

# HPC Toolchains

Treat the toolchain as a coherent stack. Pick the compiler family, MPI family, math libraries, and build system together before tuning application-specific flags.

## Start

1. Read `references/compiler-family-selection.md` before choosing GCC, Clang, or vendor compilers.
2. Read `references/configure-and-build-matrix.md` when deciding between CMake, Make, Ninja, or wrapper-driven builds.
3. Read `references/cmake-and-find-package-playbook.md` when writing or repairing `CMakeLists.txt`, `find_package`, imported targets, or cache variables.
4. Read `references/toolchain-files-and-presets.md` when the build depends on reusable compiler, MPI, or site configuration.
5. Read `references/build-type-and-abi-hygiene.md` when debugging release versus debug mismatches, C++ standard mismatches, symbol issues, or ABI drift.
6. Read `references/blas-lapack-mpi-consistency.md` when linking against BLAS, LAPACK, ScaLAPACK, MPI, or vendor math stacks.
7. Read `references/modules-and-spack-playbook.md` when using environment modules, compiler wrappers, external packages, or Spack environments.
8. Read `references/error-recovery.md` when configure, compile, link, or runtime-loader failures occur.

## Work sequence

1. Decide the stack boundary first:
   - site-provided modules
   - Spack environment
   - container image
   - user-local source build
2. Pick one compiler family and keep the full dependency graph aligned to it.
3. Decide how dependencies are discovered:
   - wrapper compilers
   - `find_package`
   - `pkg-config`
   - explicit include and library paths only as a last resort
4. Keep build directories, cache state, and install prefixes separated by toolchain.
5. Record the exact configure command before tuning warning or optimization flags.

## Guardrails

- Do not mix compiler and MPI families casually across one build tree.
- Do not patch over a bad discovery path with many ad hoc include and library flags.
- Do not treat ABI, C++ standard, and release or debug mode as cosmetic metadata.
- Do not let one dependency come from a different module stack unless the site explicitly supports that mix.

## Additional References

Load these on demand:

- `references/cmake-and-find-package-playbook.md` for imported-target and cache-variable discipline
- `references/toolchain-files-and-presets.md` for reusable site or cluster build configuration
- `references/build-type-and-abi-hygiene.md` for symbol, ABI, and optimization mismatches
- `references/blas-lapack-mpi-consistency.md` for math-library and MPI stack alignment
- `references/modules-and-spack-playbook.md` for module and Spack-based reproducibility
- `references/error-pattern-dictionary.md` for fast matching of common toolchain failure classes

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than rebuilding the build stack from scratch, especially:

- `minimal-cmake-project/CMakeLists.txt`
- `minimal-cmake-project/main.cpp`
- `configure-gcc-openmpi.sh`
- `build-smoke-slurm.sh`
- `spack-env-minimal.yaml`

## Outputs

Summarize:

- chosen compiler and MPI family
- dependency-discovery method
- build-system strategy
- math-library and ABI alignment decisions
- the exact failure phase if the workflow is being repaired
