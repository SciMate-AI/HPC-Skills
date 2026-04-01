# Trilinos Stratimikos And Parameter Lists

## Stratimikos

Use `Stratimikos` when the host code wants a solver strategy layer instead of wiring `Belos`, `Ifpack2`, or `MueLu` manually.

It is useful when:

- solver configuration must come from parameter files
- the application swaps solver stacks without recompiling
- multiple backends share one high-level configuration path

## Parameter-list discipline

`Teuchos::ParameterList` trees become fragile when package names and nesting drift.

Useful rules:

- keep one authoritative root parameter list
- record the exact package and sublist path used by the host code
- change one subtree at a time during debugging

If a parameter appears ignored, verify the active package path before assuming the algorithm is wrong.
