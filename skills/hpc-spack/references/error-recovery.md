# Spack Error Recovery

## Concretization failures

If concretization fails:

1. inspect provider policy and external packages first
2. reduce variant pressure on the root specs
3. verify compiler entries are valid and visible to Spack
4. separate unrelated roots into different environments if necessary

## Install failures

If build or install fails:

- confirm the chosen compiler is the one actually used
- confirm externals and site libraries are compatible with the stack
- inspect whether the package should be rebuilt from source or modeled as an external
- reduce to a smaller environment when the full graph hides the failing edge

## Reuse failures

If binary reuse or mirrors behave unexpectedly:

- inspect target architecture and compiler compatibility
- inspect whether the environment expects source builds but reuse policy is taking precedence
- inspect whether the reused binary assumes a different external package model

## Reporting

A useful Spack repair report includes:

- root specs
- compiler and MPI policy
- external package assumptions
- whether the environment is locked
- the exact concretization, install, or reuse symptom
