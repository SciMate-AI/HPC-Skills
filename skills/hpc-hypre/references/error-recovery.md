# hypre Error Recovery

## Setup failures

If setup fails before iteration:

- confirm the chosen interface matches the actual matrix layout
- confirm row ownership and indexing conventions are consistent across ranks
- confirm the requested solver path is supported by the integration layer in use

## Convergence failures

If the solve runs but behaves poorly:

1. reduce to a baseline Krylov plus `BoomerAMG` pairing
2. inspect whether the operator is SPD-like or genuinely nonsymmetric
3. inspect boundary-condition and nullspace treatment
4. reintroduce AMG tuning only after the baseline is coherent

## Memory or setup-cost failures

If multigrid setup becomes too expensive:

- verify the matrix is not malformed or vastly over-connected
- verify partitioning is reasonable
- back out experimental AMG tuning
- compare setup cost with a simpler baseline before deeper optimization

## Reporting

A useful hypre repair report includes:

- hypre interface family
- Krylov solver
- `BoomerAMG` role such as solver or preconditioner
- integration layer such as direct use or PETSc-mediated use
- the exact setup or convergence symptom
