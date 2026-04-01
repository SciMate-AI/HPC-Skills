# Spack Compiler And MPI Matrix

## Planning the matrix

Do not let compiler and MPI combinations emerge accidentally.

Useful default matrix:

| Need | First direction |
| --- | --- |
| one stable production stack | one compiler family and one MPI provider |
| compare compiler performance | separate environments per compiler family |
| compare MPI providers | keep the compiler fixed and vary MPI provider in separate environments |
| many package families depend on MPI | make MPI provider policy explicit near the environment root |

## Why separate environments matter

Compiler and MPI cross-products quickly multiply build cost and failure surface.

Separate environments when:

- ABI isolation matters
- runtime launchers differ
- site support boundaries differ by compiler or MPI family

Use one environment only when the packages really must coexist under one solved graph.
