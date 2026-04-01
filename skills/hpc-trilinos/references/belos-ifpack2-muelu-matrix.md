# Trilinos Belos Ifpack2 MueLu Matrix

## Operator-class mapping

| Problem class | First baseline |
| --- | --- |
| SPD-like operator on `Tpetra` | `Belos` CG plus `Ifpack2` or `MueLu` |
| general nonsymmetric operator on `Tpetra` | `Belos` GMRES plus `Ifpack2` or `MueLu` |
| moderate debugging case with direct support | `Amesos2` baseline first |
| block- or package-abstracted application | `Stratimikos` wrapping the chosen inner packages |

## Ifpack2 versus MueLu

| Need | Direction |
| --- | --- |
| cheap local relaxation or overlap preconditioning | `Ifpack2` |
| algebraic multigrid for elliptic-like behavior | `MueLu` |
| first correctness baseline | whichever path the build already supports most directly |

## Switching rules

Switch from `Ifpack2` to `MueLu` when:

- the operator is elliptic-like
- local relaxation stalls at too many iterations
- map and operator correctness are already established

Switch from iterative to `Amesos2` when:

- the matrix is moderate in size
- direct solve support exists in the build
- you need to separate formulation defects from iterative tuning noise
