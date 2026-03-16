# FEniCS Boundary, IO, And Error Recovery

## Contents

- Boundary-condition handling
- Output strategy
- Common runtime failures

## Boundary-condition handling

Treat Dirichlet conditions as explicit data, not side comments.

Classic FEniCS pattern:

```python
bc = DirichletBC(V, Constant(0.0), boundary_marker)
```

DOLFINx requires explicit dof location and a constructed boundary condition object. Keep facet tagging and dof location consistent with the chosen space. Typical building blocks are:

- `mesh.locate_entities_boundary(...)`
- `fem.locate_dofs_topological(...)`
- `fem.dirichletbc(...)`

Remember:

- Neumann terms usually enter the weak form on boundary measures
- pure Neumann problems are singular unless you add a compatibility constraint or a reference value

## Output strategy

Prefer XDMF when the result will be inspected in ParaView and the field lives on a mesh that should be preserved with the output.

For DOLFINx, keep mesh and function output routines consistent with the function space and writer API used by that version.

## Common runtime failures

`ArityMismatch`

- likely cause: nonlinear problem written with `TrialFunction`
- fix: rewrite the unknown as `Function` and solve a residual form

`Singular matrix` or zero pivot

- likely cause: missing essential boundary conditions or a pure Neumann formulation
- fix: add a reference condition, point constraint, or another admissible constraint

`Shape mismatch`

- likely cause: mixing scalar and vector forms inconsistently
- fix: repair the space selection or the UFL operator

Missing attribute or import errors

- likely cause: classic and DOLFINx APIs mixed together, or version mismatch
- fix: normalize the script to one stack before continuing
