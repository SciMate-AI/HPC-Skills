# Compiler Family Selection

## Contents

- GCC
- Clang or LLVM
- Vendor compilers
- Selection rules

## GCC

Use GCC when:

- the site's default scientific stack is GCC-based
- broad open-source package compatibility matters more than vendor-specific tuning
- mixed C, C++, and Fortran builds need a predictable baseline

GCC is usually the safest portable starting point for open-source HPC software.

## Clang or LLVM

Use Clang when:

- the site or project already standardizes on LLVM tooling
- diagnostics quality or sanitizers are the immediate priority
- the dependent libraries are known to support the chosen Clang toolchain

Do not switch to Clang casually if the MPI and math stack was built around GCC assumptions.

## Vendor compilers

Use vendor compilers such as oneAPI or AOCC when:

- the site provides a validated stack built around them
- the application benefits from vendor math or architecture-specific tuning
- the dependency graph has already been tested with that family

Vendor compilers are strongest when the site supports the whole stack, not just the front-end compiler command.

## Selection rules

Pick the compiler family first, then align:

- C compiler
- C++ compiler
- Fortran compiler
- MPI wrappers
- math libraries
- dependency binaries and static archives

One mismatched compiler family in the middle of the graph is often enough to create link or runtime instability.
