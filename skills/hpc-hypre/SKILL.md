---
name: hpc-hypre
description: Build, review, debug, and tune hypre-based sparse solver workflows. Use when working with hypre `IJ`, `Struct`, or `SStruct` interfaces, `BoomerAMG`, Krylov solvers, MPI-distributed sparse systems, PETSc integration, or hypre build and runtime failures.
---

# HPC hypre

Treat hypre as a solver-library family with distinct matrix interfaces and multigrid-heavy preconditioning workflows.

## Start

1. Read `references/interface-selection.md` before creating or repairing a hypre solve path.
2. Read `references/matrix-and-ownership-playbook.md` when choosing row ownership, indexing, or assembly discipline.
3. Read `references/boomeramg-and-krylov-playbook.md` when choosing `BoomerAMG`, Krylov solvers, or a first stable parameter set.
4. Read `references/boomeramg-parameter-matrix.md` when changing coarsening, interpolation, smoothing, or cycle choices.
5. Read `references/krylov-and-preconditioner-matrix.md` when the operator class does not fit the default `PCG` plus `BoomerAMG` baseline.
6. Read `references/structured-and-sstruct-playbook.md` when the problem is logically structured or semi-structured.
7. Read `references/build-and-integration.md` when building hypre directly or consuming it through PETSc or another host code.
8. Read `references/error-recovery.md` when setup, solve, or parallel behavior fails.

## Work sequence

1. Classify the discretization storage first:
   - general sparse assembled system -> `IJ`
   - structured grid with regular stencil semantics -> `Struct`
   - mostly structured with coupled variable blocks or irregular pieces -> `SStruct`
2. Choose a baseline solver pair that matches the operator:
   - SPD-like problems -> `PCG` with `BoomerAMG`
   - general nonsymmetric problems -> `GMRES` or `FlexGMRES` with `BoomerAMG` as the preconditioner
3. Get the baseline solve working before changing coarsening, interpolation, or relaxation details.
4. Keep distributed row ownership and matrix assembly consistent across ranks.

## Guardrails

- Do not use the structured interfaces when the data model is really an unstructured sparse matrix.
- Do not start by over-tuning `BoomerAMG`; defaults are the first checkpoint.
- Do not debug multigrid parameters before confirming the operator, nullspace, and boundary conditions are coherent.
- Do not assume host applications expose every hypre knob unless the integration layer documents it.

## Additional References

Load these on demand:

- `references/matrix-and-ownership-playbook.md` for `IJ` assembly and distributed indexing rules
- `references/boomeramg-parameter-matrix.md` for practical AMG knob selection
- `references/krylov-and-preconditioner-matrix.md` for solver-family selection beyond the default baseline
- `references/structured-and-sstruct-playbook.md` for structured-grid cases and hybrid layouts
- `references/build-and-integration.md` for PETSc-backed or direct-link builds
- `references/error-recovery.md` for setup, memory, and divergence signatures
- `references/error-pattern-dictionary.md` for quick matching of common hypre failure classes

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than rebuilding the solve path from scratch, especially:

- `hypre_ij_pcg_boomeramg.c`
- `hypre_build_example.sh`
- `hypre_ij_slurm.sh`

## Outputs

Summarize:

- chosen hypre interface
- baseline solver and preconditioner path
- multigrid knobs changed from default
- integration path such as direct hypre or PETSc-mediated usage
- the exact failure stage if the workflow is being repaired
