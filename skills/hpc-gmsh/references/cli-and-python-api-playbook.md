# Gmsh CLI and Python API Playbook

## `.geo` versus Python API

| Criterion | `.geo` script | Python API |
| --- | --- | --- |
| Best for | compact geometry, quick prototyping, batch CLI | parametric generation, loops, external data, programmatic inspection |
| Execution | `gmsh model.geo -3` | `python script.py` |
| Dependencies | none (standalone Gmsh app) | Python + `gmsh` package (`pip install gmsh`) |
| Variables | public scope only, no arguments to macros | full Python scope, functions, classes |
| Performance | parser overhead on very large models | native calls, better for large parametric sweeps |
| Debugging | `Printf`, `Warning`, `Error` commands | `gmsh.logger.get()`, Python debugger |

**Rule**: start with `.geo` for simple cases. Move to the API when the model logic needs programmability (loops over parameters, reading external data, conditional geometry).

## Complete CLI Reference

### Meshing

```bash
gmsh model.geo -1                  # mesh 1D (curves) and exit
gmsh model.geo -2                  # mesh 1D + 2D and exit
gmsh model.geo -3                  # mesh 1D + 2D + 3D and exit
gmsh model.geo -3 -o mesh.msh     # specify output file
gmsh model.geo -3 -format msh2    # force MSH2 output format
gmsh model.geo -3 -format msh4    # force MSH4 (default)
gmsh model.geo -3 -bin            # binary output
gmsh model.geo -3 -save_all       # save all elements (even without physical groups)
```

### Output Formats

`-format`: `auto`, `msh1`, `msh2`, `msh22`, `msh3`, `msh4`, `msh40`, `msh41`, `msh`, `unv`, `vtk`, `wrl`, `mail`, `stl`, `p3d`, `mesh`, `bdf`, `cgns`, `med`, `diff`, `ir3`, `inp`, `ply2`, `celum`, `su2`, `x3d`, `dat`, `neu`, `m`, `key`, `off`, `rad`, `obj`

### Algorithm Selection

```bash
gmsh model.geo -2 -algo front2d          # 2D Frontal-Delaunay
gmsh model.geo -3 -algo del3d            # 3D Delaunay (default)
gmsh model.geo -3 -algo hxt              # 3D parallel HXT
gmsh model.geo -2 -algo delquad          # 2D Frontal-Delaunay for Quads
```

Available: `auto`, `meshadapt`, `del2d`, `front2d`, `delquad`, `quadqs`, `initial2d`, `del3d`, `front3d`, `mmg3d`, `hxt`, `initial3d`

### Mesh Size Control

```bash
-clmin 0.01                   # Mesh.MeshSizeMin
-clmax 1.0                    # Mesh.MeshSizeMax
-clscale 0.5                  # Mesh.MeshSizeFactor (multiplier)
-clcurv 20                    # Mesh.MeshSizeFromCurvature (elements per 2*Pi)
-clextend 1                   # Mesh.MeshSizeExtendFromBoundary
-bgm background.pos           # load background mesh size field
```

### Optimization

```bash
-optimize                     # optimize tets (Gmsh built-in)
-optimize_netgen              # optimize tets (Netgen)
-optimize_threshold 0.3       # only optimize elements below quality threshold
-optimize_ho                  # optimize high-order elements
-smooth 5                     # 5 passes of Laplacian smoothing
```

### Element Order

```bash
-order 2                      # second-order elements
-ho_min 0.1                   # high-order optimization min threshold
-ho_max 2.0                   # high-order optimization max threshold
```

### Partitioning

```bash
-part 8                       # partition into 8 parts (Metis)
-part_split                   # write one file per partition
-part_topo                    # create partition topology (BRep)
-part_ghosts                  # create ghost cells
-part_physicals               # create physical groups for partitions
-part_weight tet 1 hex 4      # weight elements during partitioning
```

### Parallelism

```bash
-nt 8                         # set number of threads (OpenMP)
```

### Geometry

```bash
-0                            # output model (geometry), then exit
-tol 1e-8                     # set geometrical tolerance
-match                        # match geometries and meshes
```

### Post-processing / Other

```bash
-refine                       # uniform mesh refinement, then exit
-barycentric_refine           # barycentric refinement, then exit
-check                        # perform mesh consistency checks
-save_parametric              # save nodes with parametric coordinates
-save_topology                # save model topology
-v 5                          # verbosity level (0=silent, 99=debug)
-nopopup                      # no dialog popups in scripts
-parse_and_exit               # parse input file, then exit (no meshing)
-string "Mesh 3;"             # parse command string at startup
-setnumber Mesh.Algorithm 6   # set option from CLI
-setstring name value         # set string option from CLI
-convert files                # convert to latest binary format
-log logfile.txt              # log all messages to file
```

### Typical Production Commands

```bash
# Batch mesh with quality optimization
gmsh model.geo -3 -algo hxt -nt 8 -optimize_netgen -smooth 3 -o mesh.msh -bin

# Quick coarse mesh for debugging
gmsh model.geo -3 -clscale 5.0 -o coarse.msh

# Second-order with HO optimization
gmsh model.geo -3 -order 2 -optimize_ho -o mesh_p2.msh

# Partition for parallel solver
gmsh mesh.msh -part 16 -part_split -o partitioned.msh

# Mesh with curvature adaptation
gmsh model.geo -3 -clcurv 20 -clmin 0.001 -clmax 0.5 -o mesh.msh

# STL to volume mesh
gmsh model.stl -3 -o mesh.msh
```

## Python API Patterns

### Minimal Skeleton

```python
import gmsh

gmsh.initialize()
gmsh.model.add("mymodel")

# ... geometry and meshing ...

gmsh.finalize()
```

### Geometry with OpenCASCADE

```python
# Primitives
box = gmsh.model.occ.addBox(0, 0, 0, 1, 0.5, 0.25)
sphere = gmsh.model.occ.addSphere(0.5, 0.25, 0.125, 0.15)
cyl = gmsh.model.occ.addCylinder(0, 0, 0, 1, 0, 0, 0.1)
cone = gmsh.model.occ.addCone(0, 0, 0, 0, 0, 1, 0.3, 0.1)
disk = gmsh.model.occ.addDisk(0, 0, 0, 0.5, 0.3)
rect = gmsh.model.occ.addRectangle(0, 0, 0, 1, 0.5)
torus = gmsh.model.occ.addTorus(0, 0, 0, 1.0, 0.2)

# Boolean operations — return (dimTags, map)
out, _ = gmsh.model.occ.fuse([(3, box)], [(3, sphere)])
out, _ = gmsh.model.occ.cut([(3, box)], [(3, sphere)])
out, _ = gmsh.model.occ.intersect([(3, box)], [(3, sphere)])
out, _ = gmsh.model.occ.fragment([(3, box)], [(3, sphere)])

# Transformations
gmsh.model.occ.translate([(3, box)], 1, 0, 0)
gmsh.model.occ.rotate([(3, box)], 0, 0, 0, 0, 0, 1, 3.14159/4)
gmsh.model.occ.dilate([(3, box)], 0, 0, 0, 2, 2, 2)
gmsh.model.occ.mirror([(3, box)], 1, 0, 0, 0)
copy = gmsh.model.occ.copy([(3, box)])

# Extrusions
gmsh.model.occ.extrude([(2, surf_tag)], 0, 0, 1)        # linear extrude
gmsh.model.occ.revolve([(2, surf_tag)], 0, 0, 0,         # revolve
                        0, 1, 0, 3.14159)
gmsh.model.occ.addPipe([(2, surf_tag)], wire_tag)        # pipe along wire
gmsh.model.occ.addThruSections([loop1, loop2, loop3])    # loft

# Fillets and chamfers
gmsh.model.occ.fillet([vol_tag], [edge_tags], [0.1])
gmsh.model.occ.chamfer([vol_tag], [edge_tags], [face_tags], [0.05])

# MUST synchronize before meshing or physical group creation
gmsh.model.occ.synchronize()
```

### Geometry with Built-in GEO Kernel

```python
p1 = gmsh.model.geo.addPoint(0, 0, 0, 0.1)    # x, y, z, meshSize
p2 = gmsh.model.geo.addPoint(1, 0, 0, 0.1)
p3 = gmsh.model.geo.addPoint(1, 1, 0, 0.1)
p4 = gmsh.model.geo.addPoint(0, 1, 0, 0.1)

l1 = gmsh.model.geo.addLine(p1, p2)
l2 = gmsh.model.geo.addLine(p2, p3)
l3 = gmsh.model.geo.addLine(p3, p4)
l4 = gmsh.model.geo.addLine(p4, p1)

cl = gmsh.model.geo.addCurveLoop([l1, l2, l3, l4])
s = gmsh.model.geo.addPlaneSurface([cl])

gmsh.model.geo.synchronize()
```

### Physical Groups

```python
# After synchronize()
gmsh.model.addPhysicalGroup(2, [surf_tag], tag=1, name="fluid")
gmsh.model.addPhysicalGroup(1, [curve1, curve2], tag=2, name="inlet")
gmsh.model.addPhysicalGroup(1, [curve3], tag=3, name="outlet")
gmsh.model.addPhysicalGroup(1, [curve4, curve5], tag=4, name="walls")
gmsh.model.addPhysicalGroup(3, [vol_tag], tag=5, name="volume")

# Query boundary of an entity
boundary = gmsh.model.getBoundary([(3, vol_tag)], oriented=False)
```

### Mesh Generation and Export

```python
gmsh.model.mesh.generate(3)                 # generate up to dim 3
gmsh.model.mesh.setOrder(2)                 # second order
gmsh.model.mesh.optimize("Netgen")          # optimize tets
gmsh.model.mesh.optimize("HighOrder")       # optimize HO elements
gmsh.write("output.msh")                    # write mesh

# Force MSH2 format
gmsh.option.setNumber("Mesh.MshFileVersion", 2.2)
gmsh.write("output.msh")

# Force MSH4 binary
gmsh.option.setNumber("Mesh.Binary", 1)
gmsh.write("output.msh")
```

### Mesh Size Fields (API)

```python
gmsh.model.mesh.field.add("Distance", 1)
gmsh.model.mesh.field.setNumbers(1, "CurvesList", [1, 2])
gmsh.model.mesh.field.setNumber(1, "Sampling", 100)

gmsh.model.mesh.field.add("Threshold", 2)
gmsh.model.mesh.field.setNumber(2, "InField", 1)
gmsh.model.mesh.field.setNumber(2, "SizeMin", 0.01)
gmsh.model.mesh.field.setNumber(2, "SizeMax", 0.5)
gmsh.model.mesh.field.setNumber(2, "DistMin", 0.05)
gmsh.model.mesh.field.setNumber(2, "DistMax", 1.0)

gmsh.model.mesh.field.add("Min", 3)
gmsh.model.mesh.field.setNumbers(3, "FieldsList", [2])
gmsh.model.mesh.field.setAsBackgroundMesh(3)
```

### Mesh Inspection

```python
# Get all entities
entities = gmsh.model.getEntities()

# Get nodes
node_tags, coords, params = gmsh.model.mesh.getNodes(dim, tag)

# Get elements
elem_types, elem_tags, node_tags = gmsh.model.mesh.getElements(dim, tag)

# Element properties
name, dim, order, num_nodes, _, _ = gmsh.model.mesh.getElementProperties(elem_type)

# Quality
gmsh.model.mesh.getElementQualities(elem_tags, "minSICN")  # SICN, SIGE, gamma, etc.
```

### CAD Import

```python
gmsh.model.occ.importShapes("model.step")
gmsh.model.occ.importShapes("model.iges")
gmsh.model.occ.importShapes("model.brep")
gmsh.model.occ.synchronize()

# STL import (discrete)
gmsh.merge("model.stl")
# reclassify for remeshing
angle = 40  # degrees
forceParametrizablePatches = True
gmsh.model.mesh.classifySurfaces(angle * 3.14159 / 180, True, forceParametrizablePatches)
gmsh.model.mesh.createGeometry()
gmsh.model.mesh.generate(2)  # or 3 if volume meshing needed
```

### Partitioning

```python
gmsh.model.mesh.generate(3)
gmsh.model.mesh.partition(8)                           # 8 partitions
gmsh.option.setNumber("Mesh.PartitionSplitMeshFiles", 1)  # one file per partition
gmsh.write("mesh.msh")
```

### Periodic Meshes

```python
# Make surface 2 periodic with surface 1 via translation [1, 0, 0]
gmsh.model.mesh.setPeriodic(2, [2], [1], [1, 0, 0, 1,
                                         0, 1, 0, 0,
                                         0, 0, 1, 0,
                                         0, 0, 0, 1])
```

### Embedded Entities

```python
# Embed a point inside a surface (forces mesh node there)
gmsh.model.mesh.embed(0, [point_tag], 2, surface_tag)

# Embed a curve inside a volume
gmsh.model.mesh.embed(1, [curve_tag], 3, volume_tag)
```

### Logging

```python
gmsh.logger.start()
# ... operations ...
log = gmsh.logger.get()
for line in log:
    print(line)
gmsh.logger.stop()
```

## `.geo` Scripting Quick Reference

### Kernel Selection

```geo
SetFactory("OpenCASCADE");   // or SetFactory("Built-in");
```

### Geometry Primitives (OCC)

```geo
Rectangle(1) = {x, y, z, dx, dy};
Disk(1) = {xc, yc, zc, rx, ry};
Box(1) = {x, y, z, dx, dy, dz};
Sphere(1) = {xc, yc, zc, r};
Cylinder(1) = {x, y, z, dx, dy, dz, r};
Cone(1) = {x, y, z, dx, dy, dz, r1, r2};
Torus(1) = {xc, yc, zc, r1, r2};
```

### Booleans (OCC)

```geo
BooleanUnion { Volume{1}; Delete; }{ Volume{2}; Delete; }
BooleanDifference { Volume{1}; Delete; }{ Volume{2}; Delete; }
BooleanIntersection { Volume{1}; Delete; }{ Volume{2}; Delete; }
BooleanFragments { Volume{1}; Delete; }{ Volume{2}; Delete; }
```

### Transformations

```geo
Translate {dx, dy, dz} { Volume{1}; }
Rotate {{ax, ay, az}, {px, py, pz}, angle} { Volume{1}; }
Dilate {{cx, cy, cz}, factor} { Volume{1}; }
Symmetry {a, b, c, d} { Volume{1}; }   // plane ax+by+cz+d=0
```

### Physical Groups

```geo
Physical Surface("inlet", 1) = {4};
Physical Surface("outlet", 2) = {2};
Physical Surface("walls", 3) = {1, 3, 5, 6};
Physical Volume("fluid", 4) = {1};
```

### Loops and Macros

```geo
For i In {1:10}
  x~{i} = i * 0.1;
EndFor

Macro MyMacro
  // body
Return
Call MyMacro;
```

### Meshing Commands in `.geo`

```geo
Mesh 2;                    // generate 2D mesh
Mesh 3;                    // generate 3D mesh
Mesh.Algorithm = 6;        // Frontal-Delaunay
Mesh.Algorithm3D = 10;     // HXT
Save "output.msh";
```
