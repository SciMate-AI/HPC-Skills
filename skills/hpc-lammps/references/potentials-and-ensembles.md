# LAMMPS Potentials And Ensembles

## Contents

- Units and timesteps
- Potential mapping
- Neighbor settings
- Thermostat and barostat guidance

## Units and timesteps

Pick the unit system before choosing a timestep.

Examples:

- `metal`: time is picoseconds
- `real`: time is femtoseconds
- `lj`: reduced units

If the user gives a timestep without units, resolve the unit system first. A copied timestep across unit systems is unsafe.

## Potential mapping

Match `pair_style` and `pair_coeff` exactly to the potential family.

Common patterns:

- Lennard-Jones: explicit epsilon, sigma, and cutoff
- EAM or MEAM: wildcard mapping with the potential file and element names
- reactive force fields: additional charge or control-file requirements may apply

For many-body potentials, make the atom-type to element map explicit and verify the file path exists before run submission.

## Neighbor settings

Neighbor lists are part of stability control, not mere performance tuning.

Safe defaults for dynamic runs often include:

- `neighbor <skin> bin`
- `neigh_modify delay 0 every 1 check yes`

Use tighter rebuild logic on hot, high-strain, or impact-like simulations.

## Thermostat and barostat guidance

Use one integrator per atom group for the same timestep evolution.

Practical rules:

- minimize before assigning large thermal velocities
- `Tdamp` should be on the order of 100 timesteps
- `Pdamp` should be on the order of 1000 timesteps
- prefer an NVT equilibration stage before NPT when the initial structure is fragile

Remember the integration split:

- `fix nvt` and `fix npt` already integrate time evolution
- thermostat-only modifiers such as Langevin-style damping need a separate integrator like `fix nve`

If the box starts oscillating or pressure becomes non-numeric, inspect damping and startup sequencing before changing the force field.
