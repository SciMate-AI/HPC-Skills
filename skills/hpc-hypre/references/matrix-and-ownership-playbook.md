# hypre Matrix And Ownership Playbook

## IJ assembly

For `IJ` matrices, make these decisions explicit:

- global row ownership on each rank
- index base and row or column conventions used by the host code
- when off-process entries are inserted and finalized

Many hypre issues that look like AMG trouble are really row-ownership or assembly trouble.

## Practical checks

- each rank owns a non-overlapping row range
- local assembly matches the declared ownership
- the final assembled matrix is the same operator the solver sees
- boundary rows and constrained rows are intentional, not accidental artifacts

## Debugging order

1. validate ownership and indexing
2. validate the raw matrix and right-hand side
3. start from a baseline Krylov plus `BoomerAMG` path
4. only then tune multigrid parameters
