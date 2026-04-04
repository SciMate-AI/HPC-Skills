---
name: hpc-gmsh
description: Build, review, debug, and automate Gmsh geometry and meshing workflows. Use when working with `.geo` scripts, the Gmsh Python API, GEO versus OpenCASCADE modeling, physical groups, mesh-size fields, transfinite or recombine options, boundary layers, structured/unstructured algorithm selection, mesh partitioning, periodic meshes, high-order elements, mesh export and solver handoff (FEniCS, OpenFOAM, Elmer, SU2, etc.), CAD/STL import, or Gmsh CLI and meshing failures.
---

# HPC Gmsh

Treat Gmsh as a geometry-plus-meshing stack. Choose the modeling kernel first, then make topology, sizing, and structured-meshing decisions explicit before exporting downstream.

## Start

1. Read `references/modeling-kernels-and-geometry.md` before creating or repairing a Gmsh model — covers GEO versus OpenCASCADE selection, boolean operations, extrusions, transformations, CAD/STL import, embedded and compound entities, synchronization rules.
2. Read `references/physical-groups-and-entity-tagging.md` when solver handoff depends on boundary or region tags — covers export behavior, physical group stability after booleans, downstream solver requirements matrix.
3. Read `references/algorithm-selection-guide.md` when choosing 2D or 3D meshing algorithms — covers MeshAdapt, Delaunay, Frontal-Delaunay, HXT, parallel meshing, optimization, element order, subdivision.
4. Read `references/mesh-size-and-field-control.md` when choosing mesh sizes — covers the full size determination hierarchy, all field types (Distance, Threshold, Box, Ball, Cylinder, BoundaryLayer, MathEval, AutomaticMeshSizeField, etc.), combining fields, size callbacks.
5. Read `references/boundary-layer-and-refinement-recipes.md` when boundary layers, distance-based refinement, or CFD-specific mesh recipes are needed — covers BL parameters, y+ estimation, fan points, wake refinement, complete 2D CFD recipe.
6. Read `references/transfinite-and-recombine-playbook.md` when the mesh should be structured, swept, or recombined — covers TransfiniteCurve/Surface/Volume syntax with grading, Recombine, structured extrusion with Layers, periodic meshes, high-order, complete hex workflow.
7. Read `references/cli-and-python-api-playbook.md` when choosing between `.geo`, CLI, and the Python API — covers complete CLI flag reference, Python API patterns for geometry, meshing, fields, partitioning, periodic meshes, CAD import.
8. Read `references/import-export-and-solver-handoff.md` when importing CAD/STL or exporting meshes — covers all output formats, MSH4.1/MSH2 format details, element type table, downstream handoff recipes for FEniCS, OpenFOAM, Elmer, SU2, ABAQUS, Code_Aster, mesh partitioning.
9. Read `references/error-recovery.md` when meshing or geometry construction fails — covers diagnostic commands, recovery decision tree, geometry/meshing failure recovery sequences, reporting template.
10. Read `references/error-pattern-dictionary.md` for fast matching of specific Gmsh failure signatures — 14 patterns covering wrong kernel, missing physical groups, transfinite incompatibility, synchronize missing, boolean tag instability, 3D boundary recovery, negative Jacobians, periodic mismatch, and more.

## Scenario Recipes

Load the relevant recipe when the task involves:

- `references/algorithm-selection-guide.md` — 2D/3D algorithm selection matrices, parallel meshing, optimization passes, element order, subdivision for all-quad/all-hex
- `references/boundary-layer-and-refinement-recipes.md` — BoundaryLayer field setup, y+ targeting, fan points, distance+threshold refinement, box/ball/cylinder refinement, MathEval sizing, complete 2D CFD airfoil recipe, 3D BL strategies
- `references/transfinite-and-recombine-playbook.md` — structured hex/quad meshing, TransfiniteCurve grading (Progression, Bump), periodic mesh setup (affine transforms), extruded mesh with Layers, high-order elements
- `references/import-export-and-solver-handoff.md` — STEP/IGES/BREP/STL import and healing, MSH4.1/MSH2/VTK/SU2/CGNS/MED format details, downstream solver physical group requirements, mesh partitioning with Metis

## Work Sequence

1. Choose one modeling path and stay consistent:
   - **GEO kernel** for simple scripted primitives, explicit point/curve control, and hybrid discrete models
   - **OpenCASCADE** for CAD-style solids, booleans (fuse/cut/fragment), fillets, pipes, lofts, and STEP/IGES import
2. Build clean topology before tuning mesh size:
   - create all geometry
   - perform all boolean operations
   - call `synchronize()`
   - inspect entities and boundaries
3. Define physical groups after geometry is finalized:
   - physical groups encode solver-facing semantics (inlet, outlet, walls, fluid, solid)
   - use `getBoundary()` and `getEntitiesInBoundingBox()` to identify surfaces after booleans
   - if physical groups are defined, only tagged elements are exported (use `Mesh.SaveAll = 1` to override)
4. Select the meshing algorithm:
   - 2D default: Delaunay (5) for speed, Frontal-Delaunay (6) for quality, MeshAdapt (1) for robustness
   - 3D default: Delaunay (1) for robustness, HXT (10) for parallel speed
   - embedded entities and size fields require Delaunay or HXT
5. Configure mesh sizing:
   - start coarse and uniform, then add local refinement one field at a time
   - disable `MeshSizeFromPoints`, `MeshSizeFromCurvature`, `MeshSizeExtendFromBoundary` when fields are authoritative
   - combine multiple fields with `Min` and set as `Background Field`
6. Use structured meshing only where topology supports it:
   - transfinite requires 3- or 4-sided surfaces with compatible node counts on opposite edges
   - extrusion with `Layers` produces structured hex/prism
   - recombine converts tris to quads (use Blossom algorithm + smoothing for quality)
7. Optimize and validate before export:
   - optimize tets: `gmsh.model.mesh.optimize("Netgen")`
   - high-order: `setOrder(2)` then `optimize("HighOrder")`
   - check quality: `getElementQualities(tags, "minSICN")`
8. Export in the format matching the downstream solver:
   - verify physical groups are present in the output
   - verify element types and mesh dimension match solver expectations

## Guardrails

- Do not mix GEO kernel and OpenCASCADE in the same model.
- Do not define physical groups before `synchronize()` — entity tags may be stale.
- Do not rely on raw entity tags staying stable after boolean operations — use `BooleanFragments` + the output map.
- Do not force transfinite or recombine settings onto incompatible topology.
- Do not use `Mesh.SaveAll = 1` with MSH2 if physical group info is needed — MSH2 discards it.
- Do not treat export format or mesh version as an afterthought — the receiving solver decides what metadata matters.
- Do not add multiple competing size fields without combining them through a `Min` field.
- Do not use embedded entities with algorithms other than Delaunay or HXT — they will be silently ignored.
- Do not skip `optimize("HighOrder")` after `setOrder(2)` — curved elements on complex geometry will have negative Jacobians.
- Do not mesh 3D without first verifying the 2D surface mesh is valid — 3D boundary recovery depends on it.

## Additional References

Load these on demand:

- `references/modeling-kernels-and-geometry.md` — GEO versus OpenCASCADE, boolean operations, extrusions, transformations, CAD/STL import, embedded/compound entities
- `references/physical-groups-and-entity-tagging.md` — physical group syntax, export behavior, downstream solver requirements
- `references/algorithm-selection-guide.md` — 2D and 3D algorithm matrices, parallel meshing, optimization, element order
- `references/mesh-size-and-field-control.md` — complete field reference (Distance, Threshold, Box, Ball, Cylinder, BoundaryLayer, MathEval, AutomaticMeshSizeField), size hierarchy, callbacks
- `references/boundary-layer-and-refinement-recipes.md` — BL setup, y+ targeting, wake refinement, complete CFD recipes
- `references/transfinite-and-recombine-playbook.md` — structured meshing, periodic meshes, high-order, hex workflow
- `references/cli-and-python-api-playbook.md` — all CLI flags, Python API patterns, .geo scripting reference
- `references/import-export-and-solver-handoff.md` — format details, element types, solver handoff recipes, partitioning
- `references/error-pattern-dictionary.md` — 14 failure patterns with symptoms, diagnosis, and fixes
- `references/error-recovery.md` — diagnostic commands, recovery decision tree, reporting template

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than building from scratch:

- `minimal_rectangle_2d.geo` — simplest OCC rectangle with physical groups
- `occ_box_python.py` — 3D box with boundary extraction via Python API
- `parametric_cylinder_in_box.geo` — parametric external flow geometry with distance-based refinement
- `airfoil_bl_2d.py` — 2D airfoil with boundary layer, wake refinement, and fan points
- `periodic_channel_hex.py` — structured hex channel with periodic BCs (DNS/LES)
- `step_import_mesh.py` — STEP import, healing, physical groups, parallel meshing
- `gmsh-batch-mesh.sh` — minimal batch meshing script
- `gmsh-mesh-slurm.sh` — SLURM-submitted batch meshing

## Outputs

Summarize:

- chosen modeling kernel and why
- physical groups and their intended downstream meaning
- meshing algorithm (2D and 3D) and why
- mesh-size strategy: fields used, MeshSizeMin/Max, background field
- structured-meshing or recombine choices if any
- element order and optimization passes
- export format and the exact failure class if the workflow is being repaired
- mesh statistics: element counts by type, minimum quality metric
