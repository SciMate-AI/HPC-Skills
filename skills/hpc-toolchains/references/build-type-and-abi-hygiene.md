# Build Type And ABI Hygiene

## Contents

- Build-type alignment
- C++ standard alignment
- ABI risk patterns
- Repair order

## Build-type alignment

Keep debug and release artifacts separated.

Practical rules:

- build dependencies and the application with compatible optimization and debug expectations
- do not reuse one build tree for both debug and release
- record sanitizers, assertions, and special debug toggles explicitly

## C++ standard alignment

If the project and dependencies use C++, keep the language standard explicit and coherent.

Typical failure sources:

- one library built as C++17 and another consumed as C++14 with incompatible assumptions
- hidden compiler defaults changing across module loads

## ABI risk patterns

High-risk mismatches include:

- compiler-family mismatch across linked C++ libraries
- standard-library mismatch
- debug versus release allocator or assertion mismatch
- incompatible Fortran runtime across math libraries

## Repair order

1. identify the exact compiler and standard-library family
2. identify the build type of the application and key dependencies
3. reduce the link line to the intended stack only
4. rebuild the mismatched dependency instead of layering more link flags on top
