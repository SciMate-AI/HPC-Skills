# Trilinos Error Recovery

## Configure and link failures

If configure or link fails:

- confirm the required packages are enabled
- confirm the application and Trilinos agree on scalar and ordinal types
- confirm the intended `Tpetra` or `Epetra` family is the one actually used
- confirm the MPI and compiler stack is consistent across all libraries

## Runtime solver failures

If iteration behaves badly:

1. reduce to a minimal package stack
2. use a direct `Amesos2` baseline when available
3. verify map consistency and operator correctness
4. reintroduce `Belos`, `Ifpack2`, or `MueLu` tuning only after the baseline is coherent

## Common failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| parameters seem ignored | wrong package or wrong parameter-list path | trace the configuration path into the active package |
| solver fails before meaningful iteration | inconsistent maps or malformed operator | validate map construction and assembly first |
| unresolved symbols at link time | missing package enable or missing type instantiation | inspect CMake enables and template combinations |
| runtime differs between builds | package set or type set changed between builds | compare configure commands and enabled package summaries |

## Reporting

A useful Trilinos repair report includes:

- enabled package set
- `Tpetra` or `Epetra` choice
- scalar and ordinal types
- solver and preconditioner path
- exact build, link, or runtime failure signature
