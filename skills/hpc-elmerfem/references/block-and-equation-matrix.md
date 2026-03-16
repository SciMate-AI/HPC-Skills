# ElmerFEM Block And Equation Matrix

## Contents

- block responsibility matrix
- physics-to-equation matrix
- time-control matrix

## Block responsibility matrix

| Concern | Primary block |
| --- | --- |
| global run control | `Simulation` |
| physical constants | `Constants` |
| region-to-material and equation mapping | `Body` |
| constitutive parameters | `Material` |
| active physics coupling | `Equation` |
| linear or nonlinear solve controls | `Solver` |
| supports and boundary data | `Boundary Condition` |
| starting state | `Initial Condition` |

## Physics-to-equation matrix

| Goal | Typical equation and solver family |
| --- | --- |
| heat conduction | heat equation style blocks |
| linear elasticity | stress or elasticity solver blocks |
| multiphysics coupling | multiple solvers under a shared equation structure |

Choose the physics family first, then populate the right solver and equation blocks.

## Time-control matrix

| Goal | Typical Simulation controls |
| --- | --- |
| steady run | steady-state style controls |
| transient run | timestep controls and transient output cadence |

Do not leave transient-only controls half-filled in a nominally steady `.sif`.
