# Modules And Spack Playbook

## Modules

Use modules when the site already publishes a validated stack.

Good habits:

- start from a clean module state when possible
- load compiler before MPI and MPI before application libraries when the site expects that order
- capture `module list` with the build record

Do not let an old shell session keep stale modules active while diagnosing a new build.

## Spack

Use Spack when:

- the site supports it
- the project needs reproducible user-managed dependency graphs
- multiple compiler or MPI variants must coexist cleanly

## Selection rules

Prefer:

1. site-published modules
2. site-supported Spack environment
3. project-local Spack environment
4. ad hoc source builds

The lower you go, the more stack ownership you assume.

## Reproducibility

For important builds, capture:

- module list
- Spack environment manifest if used
- compiler version
- MPI version
- exact configure command

That record is often more valuable than another round of guesswork after the build breaks.
