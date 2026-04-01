# CUDA And Host Compiler Matrix

## Contents

- Build-baseline choices
- Host-compiler discipline
- Common compatibility rules

## Build-baseline choices

Choose the baseline from the actual toolchain boundary:

| Need | First direction |
| --- | --- |
| minimal CUDA source build | `nvcc` plus a supported host compiler |
| larger multi-library codebase | CMake with explicit CUDA language enable or explicit `nvcc` wrapper rules |
| MPI plus CUDA code | keep the MPI wrappers and CUDA host compiler story coherent from the start |

## Host-compiler discipline

`nvcc` does not make host-compiler compatibility disappear.

Practical rules:

- use the host compiler family supported by the active CUDA toolkit
- if the site publishes a validated module pair such as CUDA plus GCC, prefer that pair
- do not override the host compiler casually once dependencies are already built
- if build errors mention unsupported host compilers or front-end parsing trouble, reduce to the simplest validated pair first

## Common compatibility rules

Treat these as high risk until proven safe:

- CUDA toolkit from one module stack plus host compiler from another unrelated stack
- application objects built with one C++ ABI setting and dependencies built with another
- rebuilding only one layer after changing compiler family

The safest baseline is one coherent CUDA-plus-host-compiler pair through the whole build.
