# PETSc Build And Integration

## Purpose

Use this reference when PETSc must be configured, rebuilt, or linked into an application.

## Stack consistency

Keep these aligned across PETSc and the host code:

- compiler family
- MPI family
- BLAS or LAPACK and other math libraries
- external solver packages
- debug versus optimized build intent

A PETSc build produced with one MPI stack is not a safe runtime target for an application launched with another.

## Configure habits

Portable habits:

- keep one build directory or install prefix per toolchain
- save the configure command in a build note or script
- enable only the external packages you actually plan to use
- rebuild after changing compiler or MPI families instead of trying to patch the cache by hand

If the workflow depends on HYPRE, MUMPS, SuperLU_DIST, or other external packages, make that explicit at configure time and record it next to the run metadata.

## Application integration

Before tuning the solve:

1. confirm headers and libraries come from the intended PETSc install
2. confirm the executable launches with the same MPI family used at build time
3. confirm runtime options reach the intended PETSc objects
4. confirm external package options are actually available in the build

If an application wraps PETSc internally, expose enough logging to identify the actual `KSP`, `PC`, `SNES`, or `TS` objects being configured.

## Reproducibility

Record:

- PETSc version
- configure command
- install prefix
- compiler and MPI versions
- enabled external packages
- launcher used for production runs
