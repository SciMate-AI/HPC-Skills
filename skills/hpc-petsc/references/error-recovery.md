# PETSc Error Recovery

## Configure and build failures

If PETSc fails during configure or build:

1. confirm compiler and MPI wrappers are the intended ones
2. remove stale assumptions about external package availability
3. rebuild with a clean toolchain-specific build path if the stack changed materially

## Setup failures

If object setup fails before iteration:

- inspect vector and matrix sizes
- inspect ownership consistency
- inspect assembly completion order
- inspect whether the requested `PC` or external backend exists in the build

## Solve failures

If iteration starts but does not converge:

1. capture convergence reason and monitor output
2. reduce to a robust baseline solver if memory permits
3. validate scaling, nullspace handling, and boundary conditions
4. reintroduce advanced preconditioners only after the baseline is sound

## Reporting

A useful PETSc repair report includes:

- PETSc version
- build or external package facts
- problem class
- selected `KSP` or `SNES` or `TS`
- exact convergence or divergence reason
