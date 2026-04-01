# Trilinos Linear Solver And Preconditioner Playbook

## Baseline solve paths

Pick the baseline from the operator class and package family.

| Problem class | First baseline |
| --- | --- |
| SPD-like sparse operator on `Tpetra` | `Belos` CG plus a matching `Ifpack2` or `MueLu` preconditioner |
| general nonsymmetric sparse operator on `Tpetra` | `Belos` GMRES plus `Ifpack2` or `MueLu` |
| debugging a moderate-size problem with direct support available | `Amesos2` baseline first |

The direct baseline is valuable because it separates formulation defects from preconditioner or Krylov tuning when memory allows it.

## Parameter-list discipline

Trilinos workflows often route configuration through `Teuchos::ParameterList`.

Useful habits:

- keep one authoritative parameter list per solver stack
- change one package's settings at a time during debugging
- record the exact package and sublist names used by the application

If parameters appear ignored, confirm they reach the intended package instead of assuming the algorithm is at fault.

## Map and operator consistency

Before changing solver parameters, verify:

- domain and range maps are consistent
- matrix assembly uses the expected scalar and ordinal types
- preconditioners are built on the same operator family the solver sees

Inconsistent maps cause failures that no `Belos` or `MueLu` tuning can repair.
