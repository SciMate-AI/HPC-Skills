# GPU Runtime Debugging And Profiling

## First-line runtime checks

Before deeper profiling, answer:

- which devices are visible
- which rank selected which device
- whether kernels fail immediately or only under load
- whether the failure reproduces on one GPU and one node

## Minimal observability

During repair, capture:

- rank-local device IDs
- launch geometry used by the failing kernel
- whether memory allocation failure or illegal access appears
- whether slowdown comes from kernel execution, transfer, or launch placement

## Triage order

1. fix visibility and rank mapping
2. fix memory-capacity and correctness issues
3. reduce to minimal kernel reproduction if needed
4. profile only after correctness is trustworthy

Profiling a broken mapping or crashing kernel usually adds noise.
