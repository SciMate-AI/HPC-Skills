# ElmerFEM Simulation, Body, And Solver Matrix

## Contents

- Block-responsibility matrix
- ID-link matrix
- Time-control matrix

## Block-responsibility matrix

| Concern | Primary block |
| --- | --- |
| global run mode and output cadence | `Simulation` |
| physical region assignment | `Body` |
| constitutive data | `Material` |
| active physics combination | `Equation` |
| algebraic solve method | `Solver` |
| supports or imposed data | `Boundary Condition` |
| starting state | `Initial Condition` |

Use this to decide where a change belongs instead of scattering settings through unrelated blocks.

## ID-link matrix

| Link | Meaning |
| --- | --- |
| `Body -> Material` | region uses a named material block |
| `Body -> Equation` | region activates a named physics block |
| `Equation -> Solver` | active solvers for the equation |
| `Boundary Condition -> Boundary ID` | imposed data targets a boundary entity |

If any one of these links is wrong, the case may run with the wrong physics assignment.

## Time-control matrix

| Goal | Typical Simulation controls |
| --- | --- |
| steady state | `Simulation Type = Steady State`, steady iteration count |
| transient | `Simulation Type = Transient`, timestep sizes, timestep intervals, output intervals |

Do not encode timestep assumptions in solver prose when they belong in `Simulation`.
