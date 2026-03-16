# FEniCS Time-Dependent And Nonlinear Patterns

## Contents

- Time-dependent workflow
- Nonlinear residual workflow
- Newton and line-search intuition
- State update discipline

## Time-dependent workflow

For transient problems, structure the script around:

1. a previous-state function
2. a current unknown
3. a timestep parameter
4. a loop that solves, writes output, and updates state

Use this pattern when:

- solving diffusion or transport in time
- marching a mixed system such as phase-field dynamics
- coupling transient coefficients to the previous solution

Do not fake transient behavior by repeatedly solving a steady problem without carrying state.

## Nonlinear residual workflow

For nonlinear PDEs, define:

- the unknown as `Function(...)`
- the residual form `F`
- the Jacobian when required by the chosen solver path

This matches the official nonlinear demos much better than trying to cast the problem into `a == L`.

Typical triggers for nonlinear treatment:

- coefficients depend on the unknown
- constitutive laws are nonlinear
- large-deformation kinematics
- chemical-potential or phase-field couplings with nonlinear free energy

## Newton and line-search intuition

Official DOLFINx nonlinear examples route through PETSc SNES.

Practical rule:

- if plain Newton is sensitive or diverges, prefer a documented line-search configuration before rewriting the PDE

Do not hide a poor initial guess or inconsistent boundary condition behind endless parameter tweaking.

## State update discipline

At the end of each timestep:

1. verify the solve succeeded
2. write the current field if needed
3. copy or assign the current state into the previous-state storage
4. advance time

If the script forgets to update state, the transient solve is semantically broken even if it runs.
