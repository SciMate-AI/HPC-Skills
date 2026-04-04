# Gmsh Physical Groups and Entity Tagging

## Why Physical Groups Matter

**Physical groups are the primary mechanism for communicating boundary and region semantics to downstream solvers.** Most solvers ignore raw entity tags; they only see physical group tags and names.

Critical behavior: **if any physical group is defined, Gmsh only exports elements belonging to at least one physical group.** Elements not in any physical group are silently dropped. Use `Mesh.SaveAll = 1` or `-save_all` to override.

## Tagging Rules

### Dimension–meaning mapping

| Physical group dimension | Typical meaning |
| --- | --- |
| 0 | point markers, probes |
| 1 | boundary curves (2D), edge constraints |
| 2 | boundary surfaces (3D), 2D domain regions |
| 3 | volume regions, material zones |

### Naming convention

Name groups with solver-facing semantics, not geometry-building names:
- Good: `"inlet"`, `"outlet"`, `"walls"`, `"fluid"`, `"solid"`
- Bad: `"rectangle_top"`, `"surface_after_boolean"`

### Tag assignment

Tags must be strictly positive integers, unique within each dimension.

## `.geo` Syntax

```geo
Physical Point("probe", 1) = {5};
Physical Curve("inlet", 2) = {4};
Physical Curve("outlet", 3) = {2};
Physical Curve("walls", 4) = {1, 3};
Physical Surface("fluid", 5) = {1};
Physical Volume("solid", 6) = {1};
```

Tag can be omitted (auto-assigned):
```geo
Physical Surface("fluid") = {1};
```

Retrieve all entities in a physical group:
```geo
curves_in_walls[] = Physical Curve{4};
```

## Python API

```python
# Add physical group: addPhysicalGroup(dim, tags, tag=-1, name="")
gmsh.model.addPhysicalGroup(2, [1, 2], tag=1, name="fluid")
gmsh.model.addPhysicalGroup(1, [3, 4], tag=2, name="inlet")
gmsh.model.addPhysicalGroup(3, [1], tag=3, name="volume")

# Set/change name
gmsh.model.setPhysicalName(2, 1, "fluid")

# Query
groups = gmsh.model.getPhysicalGroups()           # all (dim, tag) pairs
name = gmsh.model.getPhysicalName(2, 1)           # get name
entities = gmsh.model.getEntitiesForPhysicalGroup(2, 1)  # entity tags in group
phys = gmsh.model.getPhysicalGroupsForEntity(2, 3)      # groups containing entity
```

## Stability After Booleans

Raw entity tags **change** after boolean operations. Physical groups defined before booleans may reference stale tags.

**Safe workflow**:
1. Perform all boolean operations
2. Call `synchronize()`
3. Inspect topology: `gmsh.model.getEntities()`, `gmsh.model.getBoundary()`
4. Define physical groups on the final stable entities
5. Generate mesh and export

### Using `getBoundary` to find surfaces

```python
# Get all boundary surfaces of volume 1
boundary = gmsh.model.getBoundary([(3, 1)], oriented=False, recursive=False)
# boundary is a list of (dim, tag) pairs

# Filter by bounding box or position
for dim, tag in boundary:
    com = gmsh.model.occ.getCenterOfMass(dim, tag)
    if abs(com[0]) < 1e-6:  # surface at x=0
        inlet_tags.append(tag)
```

### Using `getEntitiesInBoundingBox`

```python
# Find surfaces near x=0 plane
eps = 0.01
surfs = gmsh.model.getEntitiesInBoundingBox(-eps, -1e10, -1e10, eps, 1e10, 1e10, 2)
```

## Export Behavior

| Scenario | Exported elements |
| --- | --- |
| No physical groups defined | all elements (all entities) |
| Any physical group defined | only elements in physical groups |
| `Mesh.SaveAll = 1` | all elements regardless of physical groups |

This is format-dependent. MSH2 with `SaveAll` discards physical group definitions entirely.

### Verifying export contents

```python
# After write, re-read and check
gmsh.clear()
gmsh.open("mesh.msh")
groups = gmsh.model.getPhysicalGroups()
for dim, tag in groups:
    name = gmsh.model.getPhysicalName(dim, tag)
    entities = gmsh.model.getEntitiesForPhysicalGroup(dim, tag)
    print(f"Physical {dim}D '{name}' (tag={tag}): entities {entities}")
```

CLI check:
```bash
gmsh mesh.msh -v 3 -parse_and_exit 2>&1 | grep "Physical"
```

## Downstream Solver Requirements

| Solver | Required physical groups | Notes |
| --- | --- | --- |
| FEniCS / DOLFINx | cell markers (dim=D), facet markers (dim=D-1) | uses `meshio` or `gmshio` to read; names become MeshTags |
| OpenFOAM | surface groups (dim=2 for 3D) matching patch names | convert with `gmshToFoam` or custom script |
| Elmer | body (volume) and boundary (surface) groups | tag numbers map to `.sif` body/boundary IDs |
| Code_Aster | group names in `.med` format | export as MED: `gmsh mesh.msh -format med -o mesh.med` |
| ABAQUS | element sets and node sets | export as INP: `gmsh mesh.msh -format inp -o mesh.inp` |
| SU2 | marker tags | export as SU2: `gmsh mesh.msh -format su2 -o mesh.su2` |
| Custom / general | check what the reader expects | MSH4 stores names; MSH2 stores numeric tags |
