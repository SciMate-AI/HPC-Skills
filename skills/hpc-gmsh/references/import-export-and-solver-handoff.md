# Gmsh Import, Export, and Solver Handoff

## Import Paths

### Native `.geo` Scripts

Primary workflow — no import needed. Write geometry directly in `.geo` or Python API.

### STEP / IGES / BREP (CAD Import)

```geo
SetFactory("OpenCASCADE");
Merge "model.step";        // or .iges, .brep, .xao
```

```python
gmsh.model.occ.importShapes("model.step")
gmsh.model.occ.synchronize()
```

After import: inspect entities, define physical groups, mesh.

**Healing**: OCC automatically attempts to heal imported geometry. Set `Geometry.OCCFixDegenerated = 1` and `Geometry.OCCFixSmallEdges = 1` for additional repair.

### STL Import and Remeshing

```python
gmsh.merge("model.stl")
angle = 40  # feature angle in degrees
gmsh.model.mesh.classifySurfaces(angle * 3.14159 / 180, True, True)
gmsh.model.mesh.createGeometry()
gmsh.model.mesh.generate(2)
```

`classifySurfaces` creates discrete surfaces and curves based on dihedral angle. `createGeometry` parametrizes them for remeshing.

### Mesh Import (`.msh`, `.vtk`, `.med`, `.unv`, etc.)

```bash
gmsh existing_mesh.msh              # open in GUI
gmsh existing_mesh.msh -refine -o refined.msh   # refine and re-export
```

```python
gmsh.open("existing_mesh.msh")
```

## Export Formats

### Format Selection

```bash
gmsh model.geo -3 -format msh4 -o mesh.msh       # MSH4.1 (default)
gmsh model.geo -3 -format msh2 -o mesh.msh        # MSH2 (legacy)
gmsh model.geo -3 -format vtk -o mesh.vtk         # VTK
gmsh model.geo -3 -format su2 -o mesh.su2         # SU2
gmsh model.geo -3 -format cgns -o mesh.cgns       # CGNS
gmsh model.geo -3 -format med -o mesh.med          # MED (Salomé/Code_Aster)
gmsh model.geo -3 -format inp -o mesh.inp          # ABAQUS
gmsh model.geo -3 -format stl -o mesh.stl          # STL (surface only)
gmsh model.geo -3 -format unv -o mesh.unv          # Universal (I-deas)
gmsh model.geo -3 -format bdf -o mesh.bdf          # Nastran BDF
gmsh model.geo -3 -format neu -o mesh.neu          # Gambit Neutral
gmsh model.geo -3 -format dat -o mesh.dat          # FLUENT
```

Python API:
```python
gmsh.option.setNumber("Mesh.MshFileVersion", 2.2)   # force MSH2
gmsh.option.setNumber("Mesh.Binary", 1)              # binary output
gmsh.write("mesh.msh")

# Explicit format by extension
gmsh.write("mesh.vtk")
gmsh.write("mesh.su2")
gmsh.write("mesh.med")
```

### Format Comparison

| Format | Physical groups | Binary | High-order | Partitions | Periodic |
| --- | --- | --- | --- | --- | --- |
| MSH4.1 | names + tags | yes | yes | yes (native) | yes |
| MSH2.2 | tags only (names in `$PhysicalNames`) | yes | yes | partial | yes |
| VTK | no | yes | yes | no | no |
| SU2 | marker tags | no | partial | no | no |
| CGNS | BC names | yes | yes | yes | no |
| MED | group names | yes | yes | no | no |
| INP | element/node sets | no | yes | no | no |
| STL | no (surface triangles only) | yes | no | no | no |
| UNV | groups | no | partial | no | no |

## MSH File Format Details

### MSH4.1 Structure

```
$MeshFormat
4.1 file-type data-size
$EndMeshFormat
$Entities                      // optional: geometry entities with bounding boxes
...
$EndEntities
$Nodes                         // node coordinates by entity block
numEntityBlocks numNodes minNodeTag maxNodeTag
entityDim entityTag parametric numNodesInBlock
  nodeTag ...
  x y z ...
$EndNodes
$Elements                      // elements by entity block
numEntityBlocks numElements minElementTag maxElementTag
entityDim entityTag elementType numElementsInBlock
  elementTag nodeTag ...
$EndElements
$PhysicalNames                 // physical group names
numPhysicalNames
dimension tag "name"
...
$EndPhysicalNames
$Periodic                      // periodic node correspondence
...
$EndPeriodic
$NodeData / $ElementData / $ElementNodeData   // post-processing data
...
```

### MSH2.2 Structure (Legacy)

```
$MeshFormat
2.2 file-type data-size
$EndMeshFormat
$PhysicalNames
number-of-names
physical-dimension physical-tag "physical-name"
...
$EndPhysicalNames
$Nodes
number-of-nodes
node-number x-coord y-coord z-coord
...
$EndNodes
$Elements
number-of-elements
elm-number elm-type number-of-tags <tag> ... node-number-list
...
$EndElements
```

Element tags in MSH2: first tag = physical group tag, second tag = elementary entity tag.

### Element Types (Common)

| Type ID | Name | Nodes | Order |
| --- | --- | --- | --- |
| 1 | 2-node line | 2 | 1 |
| 2 | 3-node triangle | 3 | 1 |
| 3 | 4-node quadrangle | 4 | 1 |
| 4 | 4-node tetrahedron | 4 | 1 |
| 5 | 8-node hexahedron | 8 | 1 |
| 6 | 6-node prism | 6 | 1 |
| 7 | 5-node pyramid | 5 | 1 |
| 8 | 3-node line (2nd order) | 3 | 2 |
| 9 | 6-node triangle (2nd order) | 6 | 2 |
| 10 | 9-node quad (2nd order) | 9 | 2 |
| 11 | 10-node tet (2nd order) | 10 | 2 |
| 12 | 27-node hex (2nd order) | 27 | 2 |
| 15 | 1-node point | 1 | 0 |
| 16 | 8-node quad (serendipity 2nd order) | 8 | 2 |
| 17 | 20-node hex (serendipity 2nd order) | 20 | 2 |

### `Mesh.SaveAll` Behavior

| `Mesh.SaveAll` | Physical groups defined | Result |
| --- | --- | --- |
| 0 (default) | yes | only elements in physical groups exported |
| 0 (default) | no | all elements exported |
| 1 | any | all elements exported; MSH2 loses physical group info |

## Downstream Solver Handoff

### FEniCS / DOLFINx

**Recommended**: MSH4.1 with `gmshio` or MSH2 with `meshio`.

```python
# FEniCS X (DOLFINx) using gmshio
from dolfinx.io import gmshio
mesh, cell_tags, facet_tags = gmshio.read_from_msh("mesh.msh", MPI.COMM_WORLD, gdim=3)
```

Requirements:
- Physical groups for cell regions (dim = D) and boundary facets (dim = D-1)
- Both named and tagged — DOLFINx uses tags as MeshTags values

```python
# Gmsh side: ensure both volume and boundary physical groups
gmsh.model.addPhysicalGroup(3, [1], 1, "fluid")
gmsh.model.addPhysicalGroup(2, [inlet_surf], 2, "inlet")
gmsh.model.addPhysicalGroup(2, [outlet_surf], 3, "outlet")
gmsh.model.addPhysicalGroup(2, wall_surfs, 4, "walls")
```

### OpenFOAM

**Option 1**: `gmshToFoam` (converts MSH to OpenFOAM polyMesh)

```bash
gmshToFoam mesh.msh
```

Physical group names become patch names. Only surface (dim=2) groups are used as patches.

**Option 2**: write in Fluent format and use `fluent3DMeshToFoam`

```bash
gmsh model.geo -3 -format dat -o mesh.dat
fluent3DMeshToFoam mesh.dat
```

**Option 3**: direct API conversion via `foamMeshToFluent` or custom scripts.

Checklist:
- All boundary surfaces must be in physical groups
- Volume region should be in a physical group
- Use `Mesh.SaveAll = 1` if `gmshToFoam` complains about missing elements
- 3D only — OpenFOAM expects volume meshes

### Elmer

```bash
ElmerGrid 14 2 mesh.msh                    # MSH → Elmer mesh files
```

Physical group tags map to body IDs and boundary IDs in the `.sif` file.

### Code_Aster / Salomé

Export as MED format:
```bash
gmsh model.geo -3 -format med -o mesh.med
```

Group names are preserved in MED and readable by Code_Aster.

### SU2

```bash
gmsh model.geo -3 -format su2 -o mesh.su2
```

Physical group tags become marker tags in the SU2 config.

### ABAQUS

```bash
gmsh model.geo -3 -format inp -o mesh.inp
```

Physical groups become element sets and node sets.

## Mesh Partitioning for Parallel Solvers

### Partitioning

```bash
gmsh mesh.msh -part 16 -o partitioned.msh
```

```python
gmsh.model.mesh.partition(16)
```

Options:
- `Mesh.MetisAlgorithm`: 1 = Recursive, 2 = K-way
- `Mesh.MetisObjective`: 1 = minimize edge-cut, 2 = minimize communication volume
- `Mesh.PartitionCreateTopology`: create BRep for partition entities
- `Mesh.PartitionCreateGhostCells`: create ghost cells for inter-partition communication
- `Mesh.PartitionCreatePhysicals`: auto-create physical groups per partition
- `Mesh.PartitionSplitMeshFiles`: write one file per partition

### Split Files

```bash
gmsh mesh.msh -part 8 -part_split -o mesh.msh
# creates mesh_1.msh, mesh_2.msh, ..., mesh_8.msh
```

## Conversion Between Formats

```bash
gmsh input.msh -format vtk -o output.vtk         # MSH → VTK
gmsh input.msh -format med -o output.med          # MSH → MED
gmsh input.stl -3 -format msh2 -o output.msh      # STL → remeshed MSH2
gmsh input.msh -convert                            # convert to latest binary
```

Python:
```python
gmsh.open("input.msh")
gmsh.option.setNumber("Mesh.MshFileVersion", 2.2)
gmsh.write("output_v2.msh")
```
