# hypre Build And Integration

## Purpose

Use this reference when building hypre itself or wiring hypre into another solver stack.

## Stack consistency

Keep compiler and MPI families consistent across:

- hypre
- the host application
- any wrapper library such as PETSc

Mismatched MPI stacks often surface as runtime instability that looks unrelated to linear algebra.

## Integration modes

Common modes:

- direct use of hypre APIs in an application
- PETSc selecting hypre-backed preconditioners
- another application linking a build that already bundles hypre

Before tuning solver options, confirm which of those modes is active. Many "missing option" problems are really integration-boundary problems.

## Build habits

Portable habits:

- keep one build or install path per toolchain
- record whether GPU support or accelerator-specific backends are enabled
- record whether the build is debug or optimized
- record the exact hypre version used by the application

If the application reaches hypre only through PETSc, debug the PETSc-to-hypre handoff first instead of assuming the full hypre native interface is exposed.
