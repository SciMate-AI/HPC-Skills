# LAMMPS Units, Fix, And Compute Matrix

## Contents

- Unit-system matrix
- Ensemble-fix matrix
- Analysis-command matrix

## Unit-system matrix

Use this as a sanity table.

| Unit style | Typical use | Time meaning |
| --- | --- | --- |
| `lj` | reduced-model fluids and toy systems | reduced units |
| `metal` | metallic materials | picoseconds |
| `real` | molecular systems | femtoseconds |

If the timestep and damping values were copied from another unit style, convert them before running.

## Ensemble-fix matrix

Use this when picking integration logic.

| Goal | Typical fix path |
| --- | --- |
| Hamiltonian evolution | `fix nve` |
| constant temperature, fixed volume | `fix nvt` |
| constant temperature and pressure | `fix npt` |
| stochastic thermostat with explicit integrator | `fix langevin` + `fix nve` |
| box deformation or imposed strain | `fix deform` plus compatible integration |

Do not stack multiple full integrators on the same atoms unless the atom groups are intentionally disjoint.

## Analysis-command matrix

Use this to choose the right analysis surface.

| Target quantity | Typical command family | Output rank |
| --- | --- | --- |
| radial distribution function | `compute rdf` | global array |
| mean-squared displacement | `compute msd` | global vector |
| chunked profile or grouped analysis | `compute chunk/atom`, `fix ave/chunk` | chunk-based array |
| time-averaged scalar or vector monitor | `fix ave/time` | global scalar/vector/array |

If the quantity is global, do not try to push it through a per-atom dump by default.
