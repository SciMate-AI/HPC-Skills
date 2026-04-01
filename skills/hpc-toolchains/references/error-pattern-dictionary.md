# Toolchain Error Pattern Dictionary

## Pattern ID: `TOOLCHAIN_WRONG_COMPILER_FAMILY`

- Likely symptom: compile or link line mixes libraries from incompatible compiler stacks
- Root cause: one or more dependencies were built with a different compiler family
- Primary fix: rebuild or relink against one coherent compiler stack

## Pattern ID: `TOOLCHAIN_WRONG_MPI_STACK`

- Likely symptom: MPI wrappers compile cleanly but runtime launch or link behavior is unstable
- Root cause: the application and dependencies do not share one MPI family
- Primary fix: align wrapper compilers, MPI libraries, and launched runtime to the same stack

## Pattern ID: `TOOLCHAIN_CMAKE_DISCOVERY_DRIFT`

- Likely symptom: `find_package` resolves the wrong install or becomes nondeterministic
- Root cause: stale cache variables, mixed module state, or an ambiguous prefix path
- Primary fix: reset the build directory and point CMake at one intended dependency root

## Pattern ID: `TOOLCHAIN_ABI_MISMATCH`

- Likely symptom: unresolved symbols, mangling surprises, or crashes after a successful link
- Root cause: ABI or standard-library mismatch across dependencies
- Primary fix: align compiler family, language standard, and build type across the stack

## Pattern ID: `TOOLCHAIN_MODULE_STACK_CONTAMINATED`

- Likely symptom: builds differ between shells with no source change
- Root cause: stale or incompatible loaded modules
- Primary fix: start from a clean module state and capture the exact loaded stack
