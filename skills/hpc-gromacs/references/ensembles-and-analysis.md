# GROMACS Ensembles And Analysis

## Contents

- Stage-to-ensemble map
- Common analysis commands
- Restart and continuation notes

## Stage-to-ensemble map

Use this quick map:

| Stage | Typical goal |
| --- | --- |
| EM | remove clashes and large forces |
| NVT | thermal equilibration at fixed volume |
| NPT | density and pressure equilibration |
| production | gather trajectory statistics |

Do not use the same `.mdp` unchanged for all stages.

## Common analysis commands

High-value official tools include:

- `gmx energy`
- `gmx rms`
- `gmx rdf`
- `gmx trjconv`
- `gmx gyrate`

Choose analysis from the physical question:

- stability and drift -> energy, temperature, pressure
- structural change -> RMSD, radius of gyration
- liquid structure -> RDF

## Restart and continuation notes

Design continuation deliberately:

- keep checkpoint and output naming consistent
- keep stage boundaries explicit
- do not overwrite key state files unless continuation policy is clear
