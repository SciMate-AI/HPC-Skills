# Trilinos Package Selection

## Contents

- Core package roles
- `Tpetra` versus `Epetra`
- Minimal coherent stacks

## Core package roles

Common package roles:

- `Teuchos`: utilities, parameter lists, communicators, and support infrastructure
- `Tpetra`: modern distributed linear algebra objects and maps
- `Epetra`: legacy distributed linear algebra path
- `Belos`: iterative linear solvers
- `Ifpack2`: local and overlap-style preconditioners for `Tpetra`
- `MueLu`: algebraic multigrid preconditioning
- `Amesos2`: direct solver interface layer
- `Stratimikos`: higher-level linear solver strategy wrapper

Choose only the packages the application really needs.

## `Tpetra` versus `Epetra`

Use `Tpetra` for new work unless the application is explicitly tied to `Epetra`.

Practical rule:

- new code or modernized distributed solvers -> `Tpetra`
- older code frozen around legacy interfaces -> `Epetra`

Do not switch families casually mid-debug session. Map and type consistency matter more than package count.

## Minimal coherent stacks

Useful starting points:

| Need | Package set |
| --- | --- |
| iterative sparse solve on modern stack | `Teuchos`, `Tpetra`, `Belos` |
| add local preconditioning | add `Ifpack2` |
| add AMG | add `MueLu` |
| use a direct solver wrapper | add `Amesos2` |
| solver abstraction layer | add `Stratimikos` when the host code wants a strategy interface |

Start small and expand only when the workflow requires it.
