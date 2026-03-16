# GROMACS File And Parameter Matrix

## Contents

- File responsibility matrix
- High-value `.mdp` controls
- Compatibility checks

## File responsibility matrix

| Concern | Primary file or command |
| --- | --- |
| molecular coordinates and box | structure file such as `.gro` |
| molecular topology and force field | `.top` and included `.itp` files |
| run parameters | `.mdp` |
| compiled run input | `.tpr` from `grompp` |
| execution | `gmx mdrun` |
| trajectory analysis | `gmx energy`, `gmx rms`, `gmx rdf`, `gmx trjconv`, and related analysis tools |

## High-value `.mdp` controls

Treat these as first-response settings:

| Concern | Typical `.mdp` keys |
| --- | --- |
| integrator or minimization mode | `integrator` |
| timestep | `dt` |
| number of steps | `nsteps` |
| temperature coupling | `tcoupl`, `tc-grps`, `tau-t`, `ref-t` |
| pressure coupling | `pcoupl`, `tau-p`, `ref-p` |
| constraints | `constraints`, `constraint-algorithm` |
| output cadence | `nstxout`, `nstvout`, `nstenergy`, `nstlog`, `nstxout-compressed` |

## Compatibility checks

Before trusting a setup:

1. force field and water model must match
2. timestep must match constraint strategy and model stability
3. thermostat and barostat must match the intended stage
4. cutoffs and long-range settings must match the selected force field recommendations
