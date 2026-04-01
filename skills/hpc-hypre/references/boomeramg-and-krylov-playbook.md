# hypre BoomerAMG And Krylov Playbook

## Contents

- Baseline pairings
- Tuning order
- Monitoring

## Baseline pairings

Use a stable pairing before touching advanced AMG knobs.

Recommended first passes:

- SPD-like systems: `PCG` plus `BoomerAMG`
- nonsymmetric systems: `GMRES` or `FlexGMRES` with `BoomerAMG` as the preconditioner

That baseline is usually more informative than immediately changing coarsening or interpolation recipes.

## Tuning order

Tune in this order:

1. verify the matrix and right-hand side are assembled correctly
2. verify boundary conditions and nullspace treatment
3. verify the baseline Krylov plus AMG path converges coherently
4. only then adjust AMG details such as coarsening, interpolation, relaxation, or cycle behavior

Change one multigrid lever at a time and keep a record of the exact setting. Parallel AMG tuning is easy to destabilize if many parameters move at once.

## Monitoring

During repair, track:

- residual reduction trend
- iteration count
- setup versus solve cost
- whether memory pressure comes from the coarse hierarchy or from the host application's matrix build

If setup cost or memory explodes, reduce the problem to a baseline configuration before introducing aggressive coarsening or hybrid smoothers.
