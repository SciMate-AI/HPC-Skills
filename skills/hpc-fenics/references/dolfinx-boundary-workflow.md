# DOLFINx Boundary Workflow

## Contents

- Standard topological workflow
- Geometrical fallback
- Mixed-space caution
- Boundary debugging checklist

## Standard topological workflow

The official DOLFINx Poisson demo uses this boundary pattern:

1. identify boundary facets with `mesh.locate_entities_boundary(...)`
2. map those facets to degrees of freedom with `fem.locate_dofs_topological(...)`
3. build the boundary condition with `fem.dirichletbc(...)`

Use that workflow as the default for mesh-tagged or topologically meaningful boundaries.

Typical shape:

```python
facets = mesh.locate_entities_boundary(domain, dim=domain.topology.dim - 1, marker=...)
dofs = fem.locate_dofs_topological(V, entity_dim=domain.topology.dim - 1, entities=facets)
bc = fem.dirichletbc(value, dofs, V)
```

This is the cleanest path when the boundary condition is attached to facets of the mesh.

## Geometrical fallback

DOLFINx also provides `locate_dofs_geometrical(...)`.

Use it when:

- the geometric predicate is easier to express than facet tagging
- the relevant constraint is better described pointwise than by mesh tags

Prefer topological dof location when the mesh already carries boundary semantics. It tends to be more stable in parallel and easier to align with facet tags.

## Mixed-space caution

In mixed formulations, boundary conditions may apply to:

- the whole mixed space
- one subspace only
- a field whose natural boundary condition lives on an `H(div)` or discontinuous space

Official mixed-formulation demos emphasize:

- mixed and non-continuous spaces are common in serious formulations
- essential boundary conditions may need to be applied to subspaces
- blocked systems are often the right abstraction for solver design

Do not assume scalar Lagrange-space boundary logic transfers directly to mixed Poisson, Stokes, or `H(div)` problems.

## Boundary debugging checklist

If a DOLFINx solve fails or behaves oddly, check:

1. whether the marker function actually selects the intended boundary
2. whether `entity_dim` matches the boundary-entity dimension
3. whether the dofs belong to the right space or subspace
4. whether the condition is essential or should instead appear in the weak form
5. whether the problem is singular because only Neumann-like data was supplied
