# ElmerFEM Mesh, Boundary, And Output

## Contents

- mesh directory assumptions
- body and boundary IDs
- result and post-processing files

## Mesh directory assumptions

ElmerSolver expects a prepared mesh directory structure.

Practical rule:

- know the mesh root
- know the body IDs
- know the boundary IDs before writing BC sections

## Body and boundary IDs

Body and boundary sections connect the mesh to the `.sif`.

If an ID mapping is wrong:

- material assignment can be wrong
- equation assignment can be wrong
- boundary conditions can silently target the wrong region

Map IDs explicitly instead of relying on memory.

## Result and post-processing files

Typical outputs include solver logs and result files suitable for later visualization.

Ask for the result data that matches the active physics rather than using one generic output expectation for every run.
