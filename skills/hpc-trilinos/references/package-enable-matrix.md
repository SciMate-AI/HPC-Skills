# Trilinos Package Enable Matrix

## Minimal package sets

| Need | Package direction |
| --- | --- |
| modern sparse iterative baseline | `Teuchos`, `Tpetra`, `Belos` |
| add local preconditioning | add `Ifpack2` |
| add AMG | add `MueLu` |
| add direct solver wrapper | add `Amesos2` |
| strategy-wrapper configuration | add `Stratimikos` |

Enable the smallest coherent set that can express the workflow.

## Build trimming rules

- do not enable `Epetra` unless the code actually uses it
- do not enable `MueLu` just because multigrid may be useful later
- keep solver-package enables aligned with the linear algebra family actually used by the application

## Failure prevention

Many build and link failures come from an incoherent package set rather than from missing include paths. Start from the table above and grow only when the code path requires it.
