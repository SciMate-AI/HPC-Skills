# Gmsh Error Recovery

## Diagnostic Commands

### CLI Diagnostics

```bash
# High-verbosity parse (geometry issues)
gmsh model.geo -v 5 -0 2>&1 | tee geo_log.txt

# Mesh with verbose output
gmsh model.geo -3 -v 5 2>&1 | tee mesh_log.txt

# Check mesh consistency
gmsh mesh.msh -check 2>&1 | tee check_log.txt

# Parse without meshing (syntax errors)
gmsh model.geo -parse_and_exit -v 5

# Quick info about a mesh file
gmsh mesh.msh -v 3 -parse_and_exit 2>&1 | grep -E "nodes|elements|physical"
```

### Python API Diagnostics

```python
# Capture log
gmsh.logger.start()
gmsh.model.mesh.generate(3)
log = gmsh.logger.get()
for line in log:
    if "Error" in line or "Warning" in line:
        print(line)
gmsh.logger.stop()

# Entity inspection
for dim in range(4):
    entities = gmsh.model.getEntities(dim)
    print(f"Dim {dim}: {len(entities)} entities — tags: {[t for _, t in entities]}")

# Physical group inspection
for dim, tag in gmsh.model.getPhysicalGroups():
    name = gmsh.model.getPhysicalName(dim, tag)
    ents = gmsh.model.getEntitiesForPhysicalGroup(dim, tag)
    print(f"Physical {dim}D tag={tag} name='{name}' entities={ents}")

# Mesh statistics
types = gmsh.model.mesh.getElementTypes()
for t in types:
    name, dim, order, nv, _, _ = gmsh.model.mesh.getElementProperties(t)
    tags, _ = gmsh.model.mesh.getElementsByType(t)
    print(f"  {name} (type {t}, dim {dim}, order {order}): {len(tags)} elements")

# Element quality
for t in types:
    tags, _ = gmsh.model.mesh.getElementsByType(t)
    if len(tags) > 0:
        q = gmsh.model.mesh.getElementQualities(list(tags), "minSICN")
        print(f"  {name}: min quality = {min(q):.4f}, mean = {sum(q)/len(q):.4f}")
```

## Recovery Decision Tree

```
PROBLEM: Geometry construction fails
├─ "Unknown command" → wrong kernel (add SetFactory("OpenCASCADE"))
├─ entities disappear after boolean → use BooleanFragments, inspect out_map
├─ OCC import fails → try healing options, reduce tolerance
└─ reduce to minimal reproducing case

PROBLEM: Meshing fails (1D or 2D)
├─ "Could not mesh curve" → inspect curve geometry, check for degenerate curves
├─ poor 2D mesh quality → try MeshAdapt (algo 1), increase smoothing
├─ 2D crashes → reduce model, check for overlapping surfaces
└─ unexpected refinement → disable MeshSizeFromPoints/Curvature/ExtendFromBoundary

PROBLEM: 3D meshing fails
├─ "Boundary recovery failed" → improve 2D mesh, remove tiny features
├─ very slow 3D → check element count, MeshSizeMin may be too small
├─ HXT fails → fall back to Delaunay (algo 1), or try Frontal (Netgen)
└─ tetrahedralization fails → optimize 2D mesh first, try -optimize before -3

PROBLEM: High-order mesh has negative Jacobians
├─ mild (few elements) → gmsh.model.mesh.optimize("HighOrder")
├─ severe → optimize("HighOrderElastic"), or refine first-order mesh before setOrder
└─ very severe → lower the element order, or fix geometry curvature issues

PROBLEM: Export/solver handoff fails
├─ solver sees 0 elements → check physical groups (see GMSH_MESH_EMPTY_AFTER_EXPORT)
├─ wrong element types → check mesh dimension, recombine settings, element order
├─ MSH version incompatibility → try MSH2 (Mesh.MshFileVersion = 2.2) or MSH4
└─ partition issues → verify partition count, ghost cells, split files
```

## Geometry Failure Recovery

### Boolean operation produces empty result

```python
# Use fragment instead of fuse/cut to get the map
out, out_map = gmsh.model.occ.fragment([(3, 1)], [(3, 2)])
print("Output entities:", out)
print("Map:", out_map)
# If out is empty, the objects don't overlap or are identical
```

### Tiny features causing mesh failure

```python
# Find small edges
for dim, tag in gmsh.model.getEntities(1):
    mass = gmsh.model.occ.getMass(1, tag)
    if mass < 1e-6:
        print(f"Tiny curve {tag}: length = {mass}")

# Remove or merge small entities
gmsh.model.occ.removeAllDuplicates()
gmsh.model.occ.synchronize()
```

### Import healing

```python
gmsh.option.setNumber("Geometry.OCCFixDegenerated", 1)
gmsh.option.setNumber("Geometry.OCCFixSmallEdges", 1)
gmsh.option.setNumber("Geometry.OCCFixSmallFaces", 1)
gmsh.option.setNumber("Geometry.OCCSewFaces", 1)
gmsh.option.setNumber("Geometry.Tolerance", 1e-3)
gmsh.model.occ.importShapes("model.step")
gmsh.model.occ.healShapes()
gmsh.model.occ.synchronize()
```

## Meshing Failure Recovery

### Step 1: Simplify

1. Remove all transfinite/recombine constraints
2. Remove all size fields
3. Set generous `MeshSizeMin`/`MeshSizeMax`
4. Try meshing with default algorithm

### Step 2: Identify Problem Surface/Volume

```python
# Mesh surfaces one at a time to find the failing one
for dim, tag in gmsh.model.getEntities(2):
    try:
        gmsh.model.mesh.generate(2)
        print(f"Surface {tag}: OK")
    except Exception as e:
        print(f"Surface {tag}: FAILED — {e}")
    gmsh.model.mesh.clear()
```

### Step 3: Try Alternative Algorithm

```python
# If Delaunay fails on a surface, try MeshAdapt
gmsh.option.setNumber("Mesh.Algorithm", 1)   # MeshAdapt
gmsh.model.mesh.generate(2)
```

### Step 4: Improve 2D Before 3D

```python
gmsh.model.mesh.generate(2)
gmsh.model.mesh.optimize("", force=True)     # optimize 2D
gmsh.model.mesh.generate(3)                  # now try 3D
```

### Step 5: Optimize After Generation

```python
gmsh.model.mesh.generate(3)
gmsh.model.mesh.optimize("Netgen")
gmsh.model.mesh.optimize("Gmsh")

# Check quality
types = gmsh.model.mesh.getElementTypes()
for t in types:
    tags, _ = gmsh.model.mesh.getElementsByType(t)
    if tags:
        q = gmsh.model.mesh.getElementQualities(list(tags), "minSICN")
        print(f"Min quality: {min(q):.4f}")
```

## Reporting Template

When reporting a Gmsh issue or asking for help, include:

```
1. Gmsh version: [gmsh --version]
2. Kernel: [Built-in / OpenCASCADE]
3. Geometry summary: [N points, M curves, K surfaces, J volumes]
4. Physical groups: [list with dimensions]
5. Mesh dimension: [1D / 2D / 3D]
6. Algorithm: [name and ID]
7. Size controls: [fields, MeshSizeMin/Max, etc.]
8. Structured meshing: [transfinite/recombine/extrusion details]
9. Element order: [1 / 2 / higher]
10. Exact error message: [copy from log]
11. Minimal reproducing script: [.geo or .py]
```
