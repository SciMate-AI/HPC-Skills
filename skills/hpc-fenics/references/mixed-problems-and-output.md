# Mixed Problems And Output

## Contents

- Mixed formulations
- Stable space choices
- XDMF output rules
- Practical post-processing guidance

## Mixed formulations

Mixed formulations are first-class, not edge cases.

Official DOLFINx demos cover:

- mixed Poisson with block preconditioning
- Taylor-Hood Stokes
- divergence-conforming Navier-Stokes

Use a mixed formulation when:

- flux is a primary unknown
- incompressibility or saddle-point structure matters
- constitutive coupling introduces multiple interdependent unknowns

Do not collapse a mixed problem into a single scalar-space pattern just because the syntax is simpler.

## Stable space choices

The official mixed Poisson demo highlights a stable pattern:

- Raviart-Thomas for the flux-like `H(div)` field
- discontinuous Lagrange for the scalar field

Inference for the skill:

- stable mixed discretization is part of problem definition, not a late solver tweak
- if a mixed method is unstable, revisit the space pair before tweaking PETSc

For Stokes-like systems, use a stable velocity-pressure pair such as Taylor-Hood when the formulation calls for it.

## XDMF output rules

XDMF is convenient, but DOLFINx documents an important restriction:

- `write_function` only works directly for lowest-order discontinuous Lagrange or compatible continuous Lagrange functions whose nodes match the mesh nodes
- for discontinuous or high-order outputs, interpolation to a suitable space may be required
- the docs recommend VTX output for discontinuous or high-order spaces

This means:

- do not assume every finite-element field can be dumped to XDMF unchanged
- if output fails, inspect the element family and degree before blaming the file writer

## Practical post-processing guidance

Use this decision rule:

- ParaView-friendly nodal field on a compatible Lagrange space -> XDMF is fine
- discontinuous or higher-order field that violates XDMF assumptions -> interpolate or use VTX
- mixed solution -> split or project the component you actually want to visualize

When writing XDMF in DOLFINx:

1. write the mesh
2. write the function
3. if needed, interpolate into a visualization-friendly space first

For mixed solutions:

1. extract or split the component you actually want to inspect
2. collapse or interpolate it into an output-friendly space if required
3. write only that component instead of assuming the mixed object is directly plottable everywhere
