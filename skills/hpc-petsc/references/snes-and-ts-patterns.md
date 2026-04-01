# PETSc SNES And TS Patterns

## SNES

Use `SNES` when the application solves `F(u) = 0`.

Default repair sequence:

1. confirm the residual is mathematically correct
2. confirm the Jacobian matches the residual
3. start from a conservative Newton-style path
4. inspect nonlinear convergence reasons before changing globalization

Line search or trust-region tuning only matters after the residual and Jacobian are credible.

## TS

Use `TS` when timestep control, events, implicit stages, or ODE or DAE structure matter.

Keep these explicit:

- state vector layout
- residual or RHS form
- timestep policy
- restart or checkpoint policy when long runs matter

Do not hide a transient solve inside a hand-written time loop if the workflow depends on adaptive stepping or implicit nonlinear solves.

## Nested solver logic

For implicit time integrators, separate:

- outer time integration choices
- nonlinear solve choices
- inner linear solve and preconditioner choices

Changing all three layers at once makes failures hard to localize.
