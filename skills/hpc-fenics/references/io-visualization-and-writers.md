# DOLFINx IO, Visualization, And Writer Manual

## Contents

- XDMF
- VTK
- VTX
- Visualization-safe output
- Mesh and tag writing

## XDMF

The DOLFINx IO docs describe XDMF as the preferred format for geometry order less than or equal to 2.

Use XDMF when:

- the mesh geometry is low-order
- the output field is compatible with XDMF's interpolation behavior
- ParaView interoperability matters

Remember:

- `write_mesh` and `write_function` are separate operations
- the function is associated with a mesh path in the file

## VTK

The DOLFINx IO docs state that VTK supports arbitrary-order Lagrange geometry.

Use VTK when:

- geometry order exceeds what you want to rely on with XDMF
- the workflow specifically expects VTK output

## VTX

The official docs describe `VTXWriter` as ADIOS2-based and suitable for:

- arbitrary-order Lagrange geometry
- arbitrary-order discontinuous Lagrange functions

Use VTX when:

- the output field is discontinuous or high-order
- XDMF assumptions become restrictive
- ParaView compatibility through ADIOS2-backed output is acceptable in the environment

## Visualization-safe output

The official interpolation and IO demo shows a critical pattern:

- special finite-element fields may need interpolation into discontinuous Lagrange spaces for artifact-free visualization

Inference for the skill:

- the right visualization field may differ from the native solve field
- output format and interpolation strategy are part of post-processing design, not an afterthought

## Mesh and tag writing

The IO docs also expose mesh-tag writing and reading helpers.

Use them when:

- preserving boundary or subdomain markers in exported data matters
- debugging imported meshes and boundary labeling
- coupling output to another tool requires explicit region metadata
