# ElmerFEM Physics And Output Matrix

## Contents

- Physics-to-solver matrix
- Physics-to-material matrix
- Output-intent matrix

## Physics-to-solver matrix

| Goal | Typical solver family |
| --- | --- |
| heat conduction | heat solver block |
| linear elasticity | stress or elasticity solver block |
| Stokes or Navier-Stokes flow | flow solver block |
| multiphysics coupling | multiple coordinated solvers |

If the physics request and solver family differ, fix that before touching linear-system settings.

## Physics-to-material matrix

| Physics | High-value material fields |
| --- | --- |
| heat | conductivity and thermal properties |
| elasticity | Young's modulus, Poisson ratio, density as needed |
| flow | viscosity, density |

Missing material data is often a physics-definition error, not a linear-solver issue.

## Output-intent matrix

| User goal | Output emphasis |
| --- | --- |
| final temperature field | heat-solver field output |
| structural displacement or stress | elasticity result fields |
| transient history | output intervals and transient snapshots |
| debugging region assignment | body and boundary ID verification before solve |

If the user mainly wants a final field, reduce unnecessary transient or multi-field output noise.
