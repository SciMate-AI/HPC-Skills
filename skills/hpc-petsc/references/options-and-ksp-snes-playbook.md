# PETSc Options And KSP Or SNES Playbook

## Contents

- Options-database discipline
- Linear solver baselines
- Nonlinear solver baselines
- Monitoring and interpretation

## Options-database discipline

PETSc is designed to separate solver configuration from application code.

Prefer this order:

1. make the code expose the right objects and callbacks
2. put algorithm choices in the options database
3. capture the exact runtime options with the run record

This keeps solver experiments reproducible and reduces code churn.

## Linear solver baselines

Start from the operator class, not from a favorite Krylov method.

| Operator class | First baseline |
| --- | --- |
| symmetric positive definite | `cg` with a matching SPD preconditioner |
| general sparse nonsymmetric | `gmres` with an algebraic or factorization-style preconditioner |
| debugging a moderate-size system | `preonly` plus `lu` if an appropriate direct backend exists |

Robust debugging pattern for moderate problems:

```text
-ksp_type preonly
-pc_type lu
```

Use that to separate formulation bugs from iterative-solver instability when memory allows it.

If the preconditioner comes from HYPRE or another external package, confirm PETSc was configured with that backend before diagnosing runtime option failures.

## Nonlinear solver baselines

For nonlinear problems, start with a plain Newton-style path and add sophistication only when the residual behavior demands it.

Useful first questions:

- is the initial guess physically reasonable
- is the Jacobian consistent with the residual
- is divergence caused by the nonlinear model or by the inner linear solver

Default nonlinear repair sequence:

1. verify residual and Jacobian assembly
2. turn on nonlinear monitoring
3. use a conservative line-search baseline if the full Newton step is unstable
4. tune inner `KSP` only after the nonlinear model is behaving coherently

## Monitoring and interpretation

Always read PETSc's reported reason for termination.

Minimum diagnostics during repair:

- linear residual monitor or convergence reason
- nonlinear residual monitor or convergence reason
- iteration count
- whether the solve stopped by convergence, divergence, or iteration limit

Changing algorithms without reading the reason code is low-signal debugging.
