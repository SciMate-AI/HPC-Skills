# Spack Environments And Concretization

## Environments

Use a Spack environment when multiple packages must share:

- compiler policy
- MPI provider policy
- common dependency constraints
- reproducible concretization

This is the default for project stacks. Ad hoc single-package installs are lower-confidence once several dependencies interact.

## Concretization policy

Key questions:

- should the environment concretize together as one graph
- should root specs share dependencies where possible
- are lockfiles needed for reproducibility across machines or over time

Practical sequence:

1. write `spack.yaml`
2. concretize
3. inspect the solved graph
4. lock if reproducibility matters
5. install only after the graph is believable

## Failure-prevention rules

- if concretization surprises you, inspect providers and externals before adding more variant noise
- if several roots fight over dependencies, decide whether they belong in one environment or in separate environments
- if a stack is meant to be stable, keep the lockfile with the environment record
