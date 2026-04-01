# MPI Wrapper Compilers And Build

## Contents

- Wrapper roles
- Build hygiene
- Mixed-stack failure prevention

## Wrapper roles

MPI wrapper compilers such as `mpicc`, `mpicxx`, and `mpifort` exist to inject the right include paths, link flags, and MPI libraries for the active stack.

Use them when:

- building a native MPI application
- compiling a mixed MPI and math-library code path
- checking whether an environment module exposes a coherent MPI toolchain

## Build hygiene

Practical rules:

- keep one build directory per compiler plus MPI combination
- record the exact wrapper path used for compilation
- inspect what the wrapper expands to if link behavior is surprising
- keep C, C++, and Fortran wrappers from the same MPI stack when the application is mixed-language

## Mixed-stack failure prevention

High-risk patterns:

- `CC=gcc` plus manual MPI link flags copied from another environment
- `mpicc` from one module and `cmake` cache values from another module set
- serial BLAS or math libraries that secretly pull in a conflicting MPI dependency chain

If the link step or runtime loader behaves unexpectedly, reduce to the wrapper compilers from one known-good module set before adding more complexity.
