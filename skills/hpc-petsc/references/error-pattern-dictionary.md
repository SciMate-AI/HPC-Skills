# PETSc Error Pattern Dictionary

## Pattern ID: `PETSC_OPTIONS_IGNORED`

- Likely symptom: solver behavior does not change after option edits
- Root cause: wrong object or wrong options prefix
- Primary fix: inspect the actual object path and prefix routing before changing algorithms

## Pattern ID: `PETSC_EXTERNAL_BACKEND_MISSING`

- Likely symptom: requested `PC` or factorization backend is rejected at runtime
- Root cause: PETSc was not built with the external package
- Primary fix: verify configure-time package support and rebuild consistently if needed

## Pattern ID: `PETSC_PARALLEL_ASSEMBLY_BROKEN`

- Likely symptom: serial works but MPI runs diverge or fail early
- Root cause: ownership or assembly sequence mismatch
- Primary fix: validate ownership ranges and assembly completion on all ranks

## Pattern ID: `PETSC_NONLINEAR_MODEL_INCOHERENT`

- Likely symptom: `SNES` diverges immediately or behaves erratically
- Root cause: residual, Jacobian, or initial guess inconsistency
- Primary fix: validate nonlinear model pieces before tuning line search or linear subsolvers
