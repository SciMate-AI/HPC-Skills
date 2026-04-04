# Gmsh Error Pattern Dictionary

## Pattern ID: `GMSH_WRONG_KERNEL_FOR_OPERATION`

- **Symptom**: `Unknown command "BooleanUnion"`, or boolean operations silently produce no result; `Fillet` or `ThruSections` not recognized
- **Root cause**: GEO kernel used where OpenCASCADE is required, or `SetFactory("OpenCASCADE")` is missing / placed after geometry commands
- **Diagnostic**: check if `SetFactory("OpenCASCADE")` appears at the top of the `.geo` file, before any geometry command
- **Fix**: add `SetFactory("OpenCASCADE");` as the first geometry-related line. In Python API, use `gmsh.model.occ.*` instead of `gmsh.model.geo.*`

## Pattern ID: `GMSH_PHYSICAL_GROUPS_MISSING_OR_WRONG`

- **Symptom**: downstream solver sees 0 elements, 0 boundary patches, or "no cells" error; mesh file appears empty
- **Root cause**: physical groups were omitted, defined on wrong dimension, or defined before `synchronize()` causing stale tags
- **Diagnostic**:
  ```bash
  gmsh mesh.msh -v 3 -parse_and_exit 2>&1 | grep -i "physical"
  ```
  Or in Python: `print(gmsh.model.getPhysicalGroups())`
- **Fix**: define physical groups after all geometry operations and `synchronize()`. Verify dimension matches downstream expectations (dim=2 for 3D boundary patches, dim=3 for volume regions). If `Mesh.SaveAll = 0` (default) and physical groups exist, only tagged elements are exported.

## Pattern ID: `GMSH_MESH_EMPTY_AFTER_EXPORT`

- **Symptom**: mesh file has 0 elements or solver reports empty mesh
- **Root cause**: physical groups are defined but the mesh dimension doesn't match. E.g., only `Physical Volume` defined but meshing was done with `-2` (2D only). Or physical groups reference tags that no longer exist after booleans.
- **Diagnostic**: check that `gmsh.model.getEntitiesForPhysicalGroup(dim, tag)` returns non-empty lists
- **Fix**: ensure mesh dimension matches physical group dimensions. Use `Mesh.SaveAll = 1` as a quick diagnostic — if that exports elements, the issue is physical group assignment.

## Pattern ID: `GMSH_TRANSFINITE_ON_INCOMPATIBLE_TOPOLOGY`

- **Symptom**: `Could not find a transfinite mapping for surface X`, mesh has triangles where quads were expected, or meshing fails on specific surfaces
- **Root cause**: surface is not bounded by exactly 3 or 4 curves, or opposite edges have mismatched transfinite node counts
- **Diagnostic**:
  ```python
  boundary = gmsh.model.getBoundary([(2, surf_tag)])
  print(f"Surface {surf_tag} has {len(boundary)} boundary curves")
  for dim, tag in boundary:
      nodes = gmsh.model.mesh.getNodes(1, abs(tag))
      print(f"  Curve {tag}: {len(nodes[0])} nodes")
  ```
- **Fix**: ensure the surface has 3 or 4 bounding curves. For 4-sided surfaces, opposite edge pairs must have equal node counts. Redesign geometry if needed. Use `setTransfiniteAutomatic()` to let Gmsh detect compatible topology.

## Pattern ID: `GMSH_SIZE_FIELDS_OVERCONSTRAINED`

- **Symptom**: element count explodes, meshing takes extremely long, or `MeshSizeMin` is hit everywhere
- **Root cause**: multiple size fields interact to produce unexpectedly small sizes; or `Mesh.MeshSizeExtendFromBoundary` propagates small boundary sizes into the interior
- **Diagnostic**: set `Background Field` to each field individually and mesh to identify which is causing over-refinement
- **Fix**: disable auto-sizing (`MeshSizeFromPoints = 0; MeshSizeFromCurvature = 0; MeshSizeExtendFromBoundary = 0`), then add fields one at a time. Increase `Mesh.MeshSizeMin` as a safety floor.

## Pattern ID: `GMSH_SYNCHRONIZE_MISSING`

- **Symptom**: `Unknown model entity of dimension X and tag Y`, meshing produces nothing, physical groups are empty, fields reference nonexistent entities
- **Root cause**: geometry was built with `gmsh.model.occ.*` or `gmsh.model.geo.*` but `synchronize()` was never called before meshing/tagging
- **Diagnostic**: if using the API, search for `generate()` or `addPhysicalGroup()` calls not preceded by `synchronize()`
- **Fix**: call `gmsh.model.occ.synchronize()` (or `gmsh.model.geo.synchronize()`) after all geometry construction and before any meshing, physical group definition, or mesh size field setup.

## Pattern ID: `GMSH_BOOLEAN_TAG_INSTABILITY`

- **Symptom**: physical groups defined before boolean operations reference tags that no longer exist; warnings about non-existent entities
- **Root cause**: boolean operations (fuse, cut, fragment) change entity tags. Tags defined before booleans become stale.
- **Diagnostic**: compare entity tags before and after boolean: `print(gmsh.model.getEntities())`
- **Fix**: always perform ALL boolean operations first, then synchronize, then define physical groups. Use `BooleanFragments` to get a map of old→new entities. In Python API:
  ```python
  out_dimtags, out_map = gmsh.model.occ.fragment(objectDimTags, toolDimTags)
  # out_map[i] gives the new dimtags corresponding to input[i]
  ```

## Pattern ID: `GMSH_3D_MESH_FAIL_SURFACE_RECOVERY`

- **Symptom**: `Tetgen/BR: failed to recover boundary`, `Could not recover boundary`, meshing stops at 3D
- **Root cause**: 2D surface mesh has poor quality, self-intersections, or gaps that prevent boundary recovery during 3D Delaunay
- **Diagnostic**: inspect the 2D mesh quality: `gmsh.model.mesh.getElementQualities(...)`, check for very small or degenerate triangles
- **Fix**: improve 2D mesh quality first — increase `Mesh.Smoothing`, refine near problem areas, or use `Mesh.Algorithm = 1` (MeshAdapt) for robustness. Try `-optimize` on the 2D mesh before 3D generation. Remove tiny geometric features.

## Pattern ID: `GMSH_MESH_NEGATIVE_JACOBIAN`

- **Symptom**: `Elements with negative Jacobian`, especially after `setOrder(2)` (high-order)
- **Root cause**: second-order nodes placed on curved geometry create inverted elements
- **Diagnostic**: `gmsh mesh.msh -check` or `gmsh.model.mesh.getElementQualities(tags, "minSJ")`
- **Fix**: optimize high-order mesh: `gmsh.model.mesh.optimize("HighOrder")` or `gmsh.model.mesh.optimize("HighOrderElastic")`. Alternatively, refine the first-order mesh before elevating order. CLI: `gmsh model.geo -3 -order 2 -optimize_ho`

## Pattern ID: `GMSH_PERIODIC_MESH_MISMATCH`

- **Symptom**: `Could not find periodic counterpart`, nodes on periodic boundaries don't match
- **Root cause**: the affine transformation doesn't map the source entity onto the target entity geometrically; or the surfaces have different parameterization
- **Diagnostic**: verify that the transformation actually maps one surface to the other: check bounding boxes before and after transform
- **Fix**: ensure the 4x4 affine matrix is correct. For simple translations, verify the offset vector. For rotation, ensure axis and angle map source to target exactly. Use `BooleanFragments` first if the periodic surfaces aren't geometrically identical.

## Pattern ID: `GMSH_EMBEDDED_ENTITY_IGNORED`

- **Symptom**: embedded point or curve has no effect on the mesh; no node/edge at the expected location
- **Root cause**: embedded entities only work with Delaunay and HXT algorithms; other algorithms ignore them
- **Diagnostic**: check `Mesh.Algorithm` — if set to MeshAdapt (1), Frontal-Delaunay (6), or BAMG (7), embedded entities won't work
- **Fix**: switch to `Mesh.Algorithm = 5` (Delaunay) or `Mesh.Algorithm3D = 1` (Delaunay) / `10` (HXT)

## Pattern ID: `GMSH_OCC_IMPORT_MISSING_FACES`

- **Symptom**: imported STEP/IGES model has gaps, missing surfaces, or non-watertight volumes
- **Root cause**: imported CAD has geometric defects, tolerance mismatches, or degenerate faces
- **Diagnostic**: `gmsh model.step -v 5 -0` to output the model with high verbosity
- **Fix**: try:
  ```python
  gmsh.option.setNumber("Geometry.OCCFixDegenerated", 1)
  gmsh.option.setNumber("Geometry.OCCFixSmallEdges", 1)
  gmsh.option.setNumber("Geometry.OCCFixSmallFaces", 1)
  gmsh.option.setNumber("Geometry.OCCSewFaces", 1)
  gmsh.option.setNumber("Geometry.Tolerance", 1e-3)
  ```
  If still failing, repair the CAD in a dedicated CAD tool before importing.

## Pattern ID: `GMSH_MSH2_PHYSICAL_GROUPS_LOST`

- **Symptom**: physical group names or assignments are lost after export/reimport
- **Root cause**: `Mesh.SaveAll = 1` in MSH2 format discards physical group definitions; or MSH2 `$PhysicalNames` section wasn't written
- **Fix**: for MSH2, don't use `Mesh.SaveAll = 1` if you need physical groups. Prefer MSH4 which natively supports named physical groups. If MSH2 is required by the solver, verify `$PhysicalNames` section is present in the output file.

## Pattern ID: `GMSH_RECOMBINE_POOR_QUALITY`

- **Symptom**: recombined quad mesh has very skewed or inverted elements
- **Root cause**: underlying triangulation was poor quality before recombination
- **Fix**:
  1. Use `Mesh.RecombinationAlgorithm = 1` (Blossom) for better quad quality
  2. Increase smoothing: `Mesh.Smoothing = 100`
  3. Use `Mesh.Algorithm = 8` (Frontal-Delaunay for Quads) which produces right-angle tris better suited for recombination
  4. Consider `Mesh.SubdivisionAlgorithm = 1` for guaranteed all-quad at the cost of doubling element count
