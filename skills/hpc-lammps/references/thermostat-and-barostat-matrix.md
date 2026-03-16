# LAMMPS Thermostat And Barostat Matrix

## Contents

- Integrator-first selection
- Common fix roles
- Deformation and non-equilibrium caution
- Selection matrix

## Integrator-first selection

Choose the time-integration role before choosing the thermostat.

Key rule:

- some fixes both integrate and thermostat or barostat
- some fixes only add stochastic or thermal forcing and still need an integrator

If that distinction is wrong, the script may run but the ensemble is not what the user asked for.

## Common fix roles

Use this map:

- `fix nve`
  - pure time integration
  - no thermostat or barostat
- `fix nvt`
  - time integration plus thermostat
- `fix npt`
  - time integration plus thermostat and barostat
- `fix langevin`
  - thermostat-like stochastic forcing
  - typically paired with `fix nve` for integration
- `fix deform`
  - box deformation control for driven loading or non-equilibrium workflows
  - usually combined thoughtfully with compatible integration and pressure control choices

Do not stack multiple full integrators on the same atoms unless the domains are explicitly disjoint.

## Deformation and non-equilibrium caution

If the workflow includes box deformation, shear, or driven loading:

- verify whether the target ensemble is still meaningful
- separate mechanical driving from thermostatting logic carefully
- avoid blindly combining `fix deform` with generic equilibration recipes

## Selection matrix

Use this decision pattern:

- microcanonical evolution after preparation -> `nve`
- canonical equilibration at fixed volume -> `nvt`
- pressure and temperature control with variable box -> `npt`
- stochastic thermostat on top of explicit integrator -> `langevin` plus `nve`
- imposed strain or box motion -> `fix deform` plus a compatible integration strategy

If the user asks for reproducible restart behavior, remember that stochastic fixes change the restart story.
