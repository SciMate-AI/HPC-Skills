# Gmsh Import Export And Solver Handoff

## Import paths

Common import situations:

- scripted native geometry in `.geo`
- CAD import through OpenCASCADE-supported formats
- post-import tagging and meshing before solver export

## Export discipline

Before exporting, confirm:

- the mesh dimension matches the downstream workflow
- physical groups exist where the solver expects them
- file format and version are accepted by the next tool

## Downstream handoff

Typical handoff concerns:

- FEniCS or DOLFINx cares about physical tags and cell or facet markers
- OpenFOAM often needs conversion or a dedicated import path
- custom solvers may care about element type, numbering assumptions, or mesh version

## Practical rule

Do not treat `.msh` as a universal final format. The receiving solver decides what metadata and versioning matter.
