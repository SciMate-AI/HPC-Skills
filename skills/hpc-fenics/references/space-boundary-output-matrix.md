# FEniCS Space, Boundary, And Output Matrix

## Contents

- Unknown-to-space matrix
- Boundary-condition matrix
- Writer-selection matrix

## Unknown-to-space matrix

Use this as a fast formulation table.

| Mathematical unknown | Typical space choice |
| --- | --- |
| scalar field | scalar Lagrange space |
| vector field | vector Lagrange space |
| flux plus scalar | mixed space, often `H(div)` plus discontinuous scalar |
| velocity plus pressure | mixed stable velocity-pressure pair |

If the physical unknown and chosen space do not align, fix the space before tuning PETSc.

## Boundary-condition matrix

Use this to decide where the condition belongs.

| Condition type | Typical representation |
| --- | --- |
| essential/Dirichlet | boundary condition object on dofs |
| natural/Neumann | boundary integral in the weak form |
| Robin or mixed flux-value law | weak-form boundary term, sometimes with additional coefficients |
| pure Neumann-only problem | add compatibility/reference handling to avoid singularity |

## Writer-selection matrix

Use this for post-processing decisions.

| Target data | Preferred path |
| --- | --- |
| low-order mesh and compatible nodal field | XDMF |
| arbitrary-order Lagrange geometry | VTK or VTX |
| discontinuous or high-order field | VTX, or interpolate to a visualization-friendly space first |
| mixed solution component | extract/split/collapse component, then write |

The right writer depends on both mesh geometry and function element type.
