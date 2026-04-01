# Trilinos Build And Explicit Instantiation

## Purpose

Use this reference when configuring Trilinos with CMake or diagnosing build and link failures.

## Package trimming

Prefer enabling the smallest package set that can support the application.

Benefits:

- faster configure and build times
- fewer transitive dependency surprises
- smaller link surface when debugging

## Type consistency

Keep these consistent across the application and enabled Trilinos packages:

- scalar type
- local ordinal type
- global ordinal type
- node or execution-space assumptions when relevant

Trilinos link failures often come from mismatched template instantiations rather than missing include paths.

## Build habits

Portable habits:

- keep one build directory per compiler and MPI toolchain
- record the exact CMake configure command
- do not mix debug and release assumptions in the same build tree
- verify the enabled packages match the application's actual code paths

If the host code uses `Tpetra`, ensure the build actually enables the `Tpetra`-side solver packages it expects, such as `Belos`, `Ifpack2`, or `MueLu`.

## Explicit-instantiation failures

When a symbol is missing at link time:

1. identify the exact package and type combination required
2. confirm that package was enabled
3. confirm the required scalar and ordinal combination is instantiated in the build
4. confirm the application is not mixing incompatible package families
