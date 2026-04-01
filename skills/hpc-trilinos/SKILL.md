---
name: hpc-trilinos
description: Build, review, debug, and tune Trilinos-based solver workflows. Use when working with Trilinos packages such as `Tpetra`, `Epetra`, `Belos`, `Ifpack2`, `Amesos2`, `MueLu`, `Teuchos`, or `Stratimikos`, or when diagnosing Trilinos CMake, template-instantiation, MPI, and runtime integration failures.
---

# HPC Trilinos

Treat Trilinos as a package ecosystem. Choose the smallest coherent package set that matches the application's scalar types, maps, and solver needs.

## Start

1. Read `references/package-selection.md` before creating or repairing a Trilinos-based solve path.
2. Read `references/tpetra-map-and-operator-playbook.md` when distributed maps, import or export, or operator consistency is in doubt.
3. Read `references/linear-solver-and-preconditioner-playbook.md` when choosing `Belos`, `Ifpack2`, `MueLu`, or `Amesos2`.
4. Read `references/package-enable-matrix.md` when choosing the minimum coherent CMake package set for a build.
5. Read `references/belos-ifpack2-muelu-matrix.md` when mapping operator class to iterative, direct, local-preconditioner, or AMG paths.
6. Read `references/stratimikos-and-parameterlists.md` when a host code wraps Trilinos through strategy objects or nested `Teuchos::ParameterList` trees.
7. Read `references/build-and-explicit-instantiation.md` when configuring Trilinos with CMake, choosing package enables, or diagnosing template-instantiation failures.
8. Read `references/error-recovery.md` when build, link, map-consistency, or runtime solver behavior fails.

## Work sequence

1. Decide the linear algebra family first:
   - modern distributed stack -> `Tpetra`
   - legacy code constrained to older interfaces -> `Epetra`
2. Keep maps, scalar types, local ordinals, and global ordinals consistent before tuning solver packages.
3. Choose a baseline solve path:
   - iterative -> `Belos`
   - local relaxation or overlap preconditioning -> `Ifpack2`
   - multigrid -> `MueLu`
   - direct solve backend -> `Amesos2`
4. Start from the minimal package enable set that can express the workflow.

## Guardrails

- Do not mix `Tpetra` and `Epetra` casually in one path without an explicit compatibility reason.
- Do not blame `Belos` or `MueLu` for failures caused by inconsistent maps or scalar-type mismatches.
- Do not enable large swaths of Trilinos packages when only a few are needed.
- Do not ignore explicit-instantiation and template-parameter consistency when diagnosing link errors.

## Additional References

Load these on demand:

- `references/tpetra-map-and-operator-playbook.md` for map layout, import or export, and operator correctness
- `references/package-enable-matrix.md` for trimmed package-enable planning
- `references/belos-ifpack2-muelu-matrix.md` for solver and preconditioner family selection
- `references/stratimikos-and-parameterlists.md` for parameter-tree routing and wrapped solver stacks
- `references/build-and-explicit-instantiation.md` for CMake enables, package trimming, and template consistency
- `references/error-recovery.md` for map, package, and solver integration failures
- `references/error-pattern-dictionary.md` for quick matching of common Trilinos failure classes

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than rebuilding the solve path from scratch, especially:

- `tpetra_belos_ifpack2_minimal.cpp`
- `tpetra_belos_ifpack2_CMakeLists.txt`
- `stratimikos_solver_params.xml`
- `trilinos_cmake_configure.sh`
- `trilinos_belos_slurm.sh`

## Outputs

Summarize:

- chosen linear algebra stack
- package set in use
- solver and preconditioner baseline
- build and template-instantiation decisions that matter
- the exact failure stage if the workflow is being repaired
