# LAMMPS Units, Neighbor, And Timestep Rules

## Contents

- Unit-system consequences
- Timestep discipline
- Neighbor-list discipline
- Startup checklist

## Unit-system consequences

In LAMMPS, the unit style is not cosmetic. It changes the meaning of timestep, temperature, pressure, and force-field parameters.

Common examples:

- `metal`: time in picoseconds
- `real`: time in femtoseconds
- `lj`: reduced units

Do not transfer a timestep value between unit systems without converting its physical meaning.

## Timestep discipline

Choose timestep after:

1. unit style
2. force-field family
3. temperature and stiffness scale
4. whether the structure has been minimized

Practical rules:

- hot or newly assembled systems need smaller startup timesteps
- reactive or highly stiff systems often need more conservative timesteps than simple LJ or well-relaxed metallic systems
- if a run fails immediately, suspect the timestep even when the script syntax is clean

## Neighbor-list discipline

Neighbor settings are part of numerical stability.

Use:

- `neighbor <skin> bin`
- `neigh_modify delay 0 every 1 check yes`

especially for:

- hot systems
- strong deformation
- impacts
- early equilibration of imperfect structures

If atoms move too far between rebuilds, `Lost atoms` and related failures are expected, not surprising.

## Startup checklist

Before the first production run, verify:

1. unit style and timestep are physically compatible
2. neighbor rebuild settings are conservative enough
3. the system has been minimized if overlaps are plausible
4. thermostat and barostat damping are expressed in the chosen unit system, not copied blindly
