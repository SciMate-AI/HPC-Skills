# PETSc Solver Stack And Object Model

## Contents

- Core objects
- Solver-layer selection
- Data and layout choices
- Baseline workflow

## Core objects

PETSc is organized around a small set of major abstractions:

- `Vec`: distributed vector storage for unknowns, residuals, and right-hand sides
- `Mat`: linear operators, explicit matrices, or shells for matrix-free actions
- `KSP`: linear solvers
- `PC`: preconditioners attached to `KSP`
- `SNES`: nonlinear solvers built around residual and Jacobian callbacks
- `TS`: time-stepping and time-integration control
- `DM`: discretization, mesh, field-layout, and hierarchy support

Choose the object that matches the mathematical layer instead of forcing everything through a raw linear solve.

## Solver-layer selection

Use this default map:

| Problem shape | PETSc layer |
| --- | --- |
| `A x = b` | `KSP` |
| `F(u) = 0` | `SNES` |
| `M u_t = G(u, t)` or ODE/DAE evolution | `TS` |
| mesh or multilevel layout must drive assembly | add `DM` |

If the application is nonlinear, do not bypass `SNES` just to keep the code looking linear. `SNES` already manages Newton-style workflows, globalization, and nonlinear diagnostics.

If the application is transient, prefer `TS` over ad hoc outer loops when event handling, timestep control, or implicit solves matter.

## Data and layout choices

Distributed correctness comes before algorithm tuning.

Practical defaults:

- make ownership ranges explicit and consistent across `Vec` and `Mat`
- assemble into the same layout that the solver sees
- call the required assembly completion steps before solve
- keep boundary-condition and nullspace handling attached to the operator design, not hidden in a monitor script

Use matrix-free or shell operators only when the operator action is trustworthy and the preconditioning plan is explicit. A shell matrix with no credible preconditioner path is rarely a good first baseline.

## Baseline workflow

High-confidence sequence:

1. build the correct operator and right-hand side
2. assemble vectors and matrices completely
3. start with a robust baseline solver
4. inspect iteration counts and convergence reasons
5. only then move to more scalable or specialized preconditioners

When the application already has structured grids or coarse hierarchies, bring `DM` into the design early rather than bolting multigrid on after the fact.
