# Toolchain Error Recovery

## Configure failures

If configure fails:

1. inspect the active compiler and MPI wrappers
2. inspect the dependency-discovery path such as modules, `CMAKE_PREFIX_PATH`, or `_DIR` variables
3. isolate the build in a clean build directory before changing more flags

## Compile failures

If compile fails:

- confirm the language standard and compiler family are the intended ones
- confirm headers come from the same stack as the libraries
- reduce custom warning and optimization flags until the baseline compiles

## Link failures

If link fails:

1. identify which library family is missing or mismatched
2. check whether the wrong compiler or MPI family entered the link line
3. remove duplicate or stale library paths before adding new ones
4. rebuild against one coherent stack if the link line is fundamentally mixed

## Runtime-loader failures

If the executable builds but fails at startup:

- inspect runtime library search paths
- inspect whether modules differ between build shell and run shell
- inspect whether the executable was launched under a different MPI stack than the one it was linked against
