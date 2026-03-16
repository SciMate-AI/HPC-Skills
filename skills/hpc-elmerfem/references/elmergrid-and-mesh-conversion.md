# ElmerGrid And Mesh Conversion Manual

## Contents

- ElmerGrid role
- mesh conversion workflow
- mesh-source caveats

## ElmerGrid role

The official Elmer documentation notes that Elmer uses ElmerGrid to convert many external mesh formats into Elmer mesh directories.

Use ElmerGrid when:

- the mesh comes from Gmsh, Salome, Netgen, or another external generator
- the final solver expects an Elmer mesh directory

## Mesh conversion workflow

Practical sequence:

1. generate mesh in the external mesher
2. convert with ElmerGrid
3. inspect body and boundary IDs in the converted mesh
4. write the `.sif` against those IDs

Do not write boundary conditions before you know the converted boundary numbering.

## Mesh-source caveats

The official Elmer notes point out that Elmer itself is not the main mesh generator for complex geometry workflows.

Inference for the skill:

- mesh conversion is often the real source of ID mapping bugs
- if a boundary condition seems ignored, inspect the converted mesh IDs before tuning solver blocks
