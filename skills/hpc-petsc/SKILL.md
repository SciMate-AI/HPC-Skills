---
name: hpc-petsc
description: Build, review, debug, and tune PETSc-based solver workflows. Use when working with PETSc `Vec`, `Mat`, `KSP`, `PC`, `SNES`, `TS`, options-database tuning, MPI-distributed assembly, external package integration, or PETSc build and runtime failures.
---

# HPC PETSc

Treat PETSc as a layered solver toolkit. Start from the highest-level object that matches the mathematical problem and only drop lower when there is a clear reason.

## Start

1. Read `references/solver-stack-and-object-model.md` before creating or repairing a PETSc-based solve path.
2. Read `references/ksp-and-pc-matrix.md` when selecting Krylov methods, direct solves, or preconditioner families.
3. Read `references/snes-and-ts-patterns.md` when the application is nonlinear or time-dependent.
4. Read `references/options-and-ksp-snes-playbook.md` when translating runtime options into code or debugging prefix handling.
5. Read `references/runtime-option-matrix.md` when selecting monitors, residual diagnostics, or common options-database switches.
6. Read `references/dm-and-discretization-playbook.md` when `DM`, nullspaces, multigrid layout, or field decomposition matter.
7. Read `references/external-backend-matrix.md` when deciding whether to route through HYPRE, direct solvers, or matrix-free paths.
8. Read `references/build-and-integration.md` when configuring PETSc, enabling external packages, or integrating PETSc into another codebase.
9. Read `references/parallel-and-runtime-debugging.md` when a distributed run shows assembly, ownership, convergence, or monitoring problems.
10. Read `references/error-recovery.md` when configure, setup, or solve phases fail.

## Work sequence

1. Classify the problem first:
   - linear system -> `KSP`
   - nonlinear residual -> `SNES`
   - time-dependent problem -> `TS`
2. Choose the data model before tuning the solver:
   - `Vec` for distributed unknowns
   - `Mat` or matrix-free operator for the linearization
   - `DM` when mesh, hierarchy, or field layout must drive assembly and coarsening
3. Get a robust baseline solve working before tuning for scale.
4. Move configuration into the options database whenever practical so runs stay inspectable and reproducible.
5. Read convergence reason and monitor output before changing algorithms.

## Guardrails

- Do not hand-roll nonlinear or time-stepping logic that `SNES` or `TS` already manages unless the application truly needs it.
- Do not tune preconditioners before checking operator correctness, boundary conditions, and assembly completion.
- Do not mix compiler, MPI, and external solver stacks casually across PETSc and the host application.
- Do not treat options prefixes or convergence reasons as optional diagnostics.

## Additional References

Load these on demand:

- `references/ksp-and-pc-matrix.md` for operator-class to solver-family mapping
- `references/snes-and-ts-patterns.md` for nonlinear and transient workflow design
- `references/runtime-option-matrix.md` for monitor, logging, and option-database baselines
- `references/dm-and-discretization-playbook.md` for `DMDA`, `DMPlex`, field splits, and hierarchy-aware setup
- `references/external-backend-matrix.md` for HYPRE, direct-solver, and matrix-free integration tradeoffs
- `references/build-and-integration.md` for external package wiring such as HYPRE or direct-solver backends
- `references/parallel-and-runtime-debugging.md` for ownership ranges, assembly ordering, monitors, and distributed diagnostics
- `references/error-pattern-dictionary.md` for fast matching of common PETSc failure classes

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than rebuilding the solve path from scratch, especially:

- `ksp_poisson_minimal.c`
- `petsc4py_ksp_minimal.py`
- `petsc_build_example.sh`
- `petsc_ksp_slurm.sh`

## Outputs

Summarize:

- problem class and chosen PETSc layer
- matrix or operator strategy
- solver and preconditioner baseline
- runtime options or code-path decisions
- the exact failure phase if the workflow is being repaired
