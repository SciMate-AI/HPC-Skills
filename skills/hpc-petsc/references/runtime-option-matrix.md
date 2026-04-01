# PETSc Runtime Option Matrix

## Contents

- Core monitoring switches
- Baseline debugging sets
- Prefix and capture discipline

## Core monitoring switches

Use monitoring options to localize the failing layer before changing algorithms.

| Goal | Typical PETSc direction |
| --- | --- |
| inspect linear residual trend | `-ksp_monitor` |
| inspect nonlinear residual trend | `-snes_monitor` |
| capture why a solve stopped | `-ksp_converged_reason` or `-snes_converged_reason` |
| inspect preconditioner selection | `-ksp_view` or `-pc_view` when available in the workflow |
| inspect options actually seen | `-options_view` when the application permits it |

## Baseline debugging sets

Useful repair bundles:

| Situation | First runtime option set |
| --- | --- |
| linear solve is unstable | `-ksp_monitor -ksp_converged_reason` |
| nonlinear solve is unstable | `-snes_monitor -snes_converged_reason -ksp_converged_reason` |
| options look ignored | `-options_view -ksp_view` |
| MPI run differs from serial | capture monitor and converged-reason output on the distributed run first |

## Prefix and capture discipline

If the application owns multiple PETSc objects:

- identify the active options prefix first
- do not assume bare options reach nested objects
- save the exact runtime option set with the run record

Uncaptured runtime flags are effectively irreproducible tuning.
