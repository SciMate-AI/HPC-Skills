---
name: hpc-gmsh
description: Build, review, debug, and automate Gmsh geometry and meshing workflows. Use when working with `.geo` scripts, the Gmsh Python API, GEO versus OpenCASCADE modeling, physical groups, mesh-size fields, transfinite or recombine options, mesh export and solver handoff, or Gmsh CLI and meshing failures.
---

# HPC Gmsh

Treat Gmsh as a geometry-plus-meshing stack. Choose the modeling kernel first, then make topology tags and meshing controls explicit before exporting anything downstream.

## Start

1. Read `references/modeling-kernels-and-geometry.md` before creating or repairing a Gmsh model.
2. Read `references/physical-groups-and-entity-tagging.md` when solver handoff depends on boundary or region tags.
3. Read `references/mesh-size-and-field-control.md` when choosing global mesh size, point sizes, background fields, or local refinement.
4. Read `references/transfinite-and-recombine-playbook.md` when the mesh should be structured, swept, or recombined into quads or hex-dominant elements.
5. Read `references/cli-and-python-api-playbook.md` when choosing between `.geo`, CLI, and the Python API.
6. Read `references/import-export-and-solver-handoff.md` when importing CAD, exporting `.msh`, or preparing meshes for FEniCS, OpenFOAM, or other solvers.
7. Read `references/error-recovery.md` when geometry construction, tagging, or meshing fails.

## Work sequence

1. Choose one modeling path and stay consistent:
   - GEO kernel for simple scripted primitives and explicit points or curves
   - OpenCASCADE for CAD-style solids, booleans, and more robust constructive geometry
2. Build clean topology before tuning mesh size.
3. Define physical groups before export if any downstream solver needs stable material or boundary IDs.
4. Use structured meshing tools only where the topology actually supports them.
5. Export only after confirming element dimension, entity tagging, and file format version match the downstream code.

## Guardrails

- Do not mix GEO-style assumptions with OpenCASCADE booleans casually.
- Do not rely on raw entity tags staying stable after geometry edits unless physical groups are defined.
- Do not force transfinite or recombine settings onto incompatible topology.
- Do not treat export format or mesh version as an afterthought when handing the mesh to another solver.

## Additional References

Load these on demand:

- `references/modeling-kernels-and-geometry.md` for GEO versus OpenCASCADE and boolean-modeling choices
- `references/physical-groups-and-entity-tagging.md` for stable boundary and subdomain labeling
- `references/mesh-size-and-field-control.md` for local refinement and background-field usage
- `references/transfinite-and-recombine-playbook.md` for mapped meshing and recombination choices
- `references/cli-and-python-api-playbook.md` for script-path selection and batch meshing
- `references/import-export-and-solver-handoff.md` for `.msh` versioning, conversion, and downstream expectations
- `references/error-pattern-dictionary.md` for fast matching of common Gmsh failure signatures

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than rebuilding the mesh workflow from scratch, especially:

- `minimal_rectangle_2d.geo`
- `occ_box_python.py`
- `gmsh-batch-mesh.sh`
- `gmsh-mesh-slurm.sh`

## Outputs

Summarize:

- chosen modeling kernel
- physical groups and intended downstream meaning
- mesh-size or field strategy
- structured-meshing or recombine choices if any
- export format and the exact failure class if the workflow is being repaired
