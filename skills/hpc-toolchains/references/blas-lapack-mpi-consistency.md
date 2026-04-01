# BLAS LAPACK And MPI Consistency

## Contents

- Math-library alignment
- MPI wrapper alignment
- Vendor-stack rules

## Math-library alignment

Keep these aligned:

- BLAS and LAPACK provider
- ScaLAPACK provider if used
- compiler family used to build them
- threaded runtime assumptions

Do not mix one vendor BLAS with unrelated compiler runtimes unless the site explicitly validates that combination.

## MPI wrapper alignment

For MPI-enabled builds, treat the wrapper compiler as part of the toolchain identity.

Check:

- `mpicc`, `mpicxx`, and `mpifort` come from the intended MPI family
- the wrapped compilers match the chosen base compiler family
- downstream libraries were built against the same MPI family

## Vendor-stack rules

If a site provides a tightly integrated stack, prefer all of it together:

- compiler family
- MPI family
- vendor math libraries

Breaking a validated vendor stack is a common way to create subtle runtime or link failures.
