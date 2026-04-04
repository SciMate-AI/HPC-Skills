# Gmsh Modeling Kernels and Geometry

## Kernel Comparison Matrix

| Feature | Built-in GEO | OpenCASCADE (OCC) |
| --- | --- | --- |
| **Bottom-up construction** | yes (primary mode) | yes |
| **Top-down CSG booleans** | no | yes (fuse, cut, intersect, fragment) |
| **Extrusions** | translate, rotate (mesh layers) | translate, rotate, pipe, thrusections |
| **Fillets / chamfers** | no | yes |
| **STEP/IGES import** | no | yes (native OCC reader) |
| **BRep export** | `.geo_unrolled` | `.brep`, `.xao` |
| **Hybrid discrete entities** | yes (discrete on boundary of GEO) | no (OCC does not support discrete boundary entities) |
| **Tag stability after booleans** | n/a | tags change — always use `BooleanFragments` + physical groups |
| **Performance on simple geometry** | faster parse | slightly heavier |

### When to use each

**Built-in GEO kernel** — choose when:
- fully scripted simple geometry (rectangles, blocks, channels)
- explicit point/curve/surface/volume definition
- low-level control over every entity tag
- hybrid models with discrete (STL) entities on boundary
- extruded meshes with explicit layer control

**OpenCASCADE** — choose when:
- booleans: fuse, cut, intersect, fragment
- CAD-style solids, fillets, chamfers, pipes, lofts (ThruSections)
- importing STEP, IGES, BREP files
- constructive solid geometry workflows
- complex geometry with many intersecting parts

**Rule**: pick one kernel at file creation time. Mixing kernels in the same model is unsupported.

## Kernel Selection Syntax

`.geo`:
```geo
SetFactory("OpenCASCADE");   // must appear before any geometry command
// or
SetFactory("Built-in");      // default if omitted
```

Python API: kernel is implicit in function namespace:
```python
gmsh.model.occ.addBox(...)          # OpenCASCADE
gmsh.model.geo.addPoint(...)        # Built-in GEO
```

## BRep and Topology Model

Gmsh uses a Boundary Representation (BRep):
- **Volume** bounded by **Surfaces**
- **Surface** bounded by **Curves** (via Curve Loops)
- **Curve** bounded by two **Points**
- **Embedded** entities: points/curves can be embedded in surfaces; points/curves/surfaces can be embedded in volumes

Every entity has a `(dimension, tag)` pair. Tags must be strictly positive and unique within each dimension.

## Geometry Commands — Built-in GEO Kernel

### Points

```geo
Point(tag) = {x, y, z, meshSize};
```

`meshSize` is optional; omit or set to 0 to use global sizing.

### Curves

```geo
Line(tag) = {startPoint, endPoint};
Circle(tag) = {startPoint, centerPoint, endPoint};    // arc ≤ Pi
Ellipse(tag) = {startPoint, centerPoint, majorPoint, endPoint};
BSpline(tag) = {point_list};
Spline(tag) = {point_list};                            // Catmull-Rom
Bezier(tag) = {point_list};
```

### Curve Loops and Surfaces

```geo
Curve Loop(tag) = {curve1, -curve2, curve3, curve4};   // sign = orientation
Plane Surface(tag) = {outerLoop, <hole1, hole2, ...>};
Surface Filling(tag) = {boundaryLoop};
BSpline Surface(tag) = {boundaryLoop};
```

### Volumes

```geo
Surface Loop(tag) = {surf1, surf2, ...};               // closed shell
Volume(tag) = {outerSurfaceLoop, <hole1, hole2, ...>};
```

### Extrusions (GEO)

```geo
// Linear extrusion — returns list: [0]=top entity, [1]=volume, [2..]=lateral surfaces
Extrude {dx, dy, dz} { Surface{1}; Layers{N}; Recombine; }

// Rotation extrusion
Extrude {{ax, ay, az}, {px, py, pz}, angle} { Surface{1}; Layers{N}; }

// With mesh layers (structured extrusion)
Extrude {0, 0, 1} { Surface{1}; Layers{ {5, 10}, {0.3, 1.0} }; Recombine; }
// This creates 5 layers to 30% height, then 10 layers to 100% height
```

The `Layers` command controls structured meshing in the extrusion direction. `Recombine` converts tris to quads on the extruded surface, producing hexahedra/prisms in 3D.

### Transformations (GEO)

```geo
Translate {dx, dy, dz} { Point{1}; Curve{2}; Surface{3}; }
Rotate {{ax, ay, az}, {px, py, pz}, angle} { Volume{1}; }
Dilate {{cx, cy, cz}, factor} { Volume{1}; }
Dilate {{cx, cy, cz}, {fx, fy, fz}} { Volume{1}; }    // anisotropic
Symmetry {a, b, c, d} { Volume{1}; }                   // plane ax+by+cz+d=0
```

`Duplicata` creates a copy:
```geo
new_entities[] = Translate {1, 0, 0} { Duplicata { Volume{1}; } };
```

### Coherence

```geo
Coherence;          // remove duplicate entities (GEO kernel)
```

Automatic when `Geometry.AutoCoherence = 1` (default). Not needed with OCC (handled by BooleanFragments).

## Geometry Commands — OpenCASCADE Kernel

### Primitives

```geo
SetFactory("OpenCASCADE");
Rectangle(tag) = {x, y, z, dx, dy, <roundedRadius>};
Disk(tag) = {xc, yc, zc, rx, <ry>};
Box(tag) = {x, y, z, dx, dy, dz};
Sphere(tag) = {xc, yc, zc, r, <angle1, angle2, angle3>};
Cylinder(tag) = {x, y, z, dx, dy, dz, r, <angle>};
Cone(tag) = {x, y, z, dx, dy, dz, r1, r2, <angle>};
Torus(tag) = {xc, yc, zc, r1, r2, <angle>};
Wedge(tag) = {x, y, z, dx, dy, dz, <ltx>};
```

### Boolean Operations

```geo
BooleanUnion { Volume{1}; Delete; }{ Volume{2}; Delete; }
BooleanDifference { Volume{1}; Delete; }{ Volume{2}; Delete; }
BooleanIntersection { Volume{1}; Delete; }{ Volume{2}; Delete; }
BooleanFragments { Volume{1}; Delete; }{ Volume{2}; Delete; }
```

**`BooleanFragments` is the most important**: it computes all intersections and creates shared interfaces. Use it when multiple volumes must share conformal mesh interfaces.

`Delete;` removes the input objects after the operation. Omit `Delete` to keep originals.

### Advanced OCC Operations

```geo
// ThruSections (loft between closed curve loops)
ThruSections(tag) = {loop1, loop2, loop3};
Ruled ThruSections(tag) = {loop1, loop2, loop3};

// Pipe extrusion along a wire
Wire(tag) = {curve_list};
Extrude { Surface{1}; } Using Wire {wire_tag}

// Fillet
Fillet{volume_tag}{edge_list}{radius_list}

// Chamfer
Chamfer{volume_tag}{edge_list}{surface_list}{distance_list}
```

### Curvature-Based Sizing (OCC)

```geo
Mesh.MeshSizeFromCurvature = 20;     // 20 elements per 2*Pi radians
Mesh.MeshSizeMin = 0.001;
Mesh.MeshSizeMax = 0.5;
```

## CAD Import

```geo
SetFactory("OpenCASCADE");
Merge "model.step";    // or .iges, .brep, .xao
```

After import, OCC entities are created. Define physical groups on the imported geometry, then mesh.

```python
gmsh.model.occ.importShapes("model.step")
gmsh.model.occ.synchronize()
# inspect entities
print(gmsh.model.getEntities(3))  # all volumes
```

## STL / Discrete Model Import and Remeshing

```python
gmsh.merge("part.stl")
# Classify surfaces by angle threshold
angle = 40  # degrees
gmsh.model.mesh.classifySurfaces(angle * 3.14159 / 180, True, True)
gmsh.model.mesh.createGeometry()
# Now the STL has parametrized surfaces and can be remeshed
gmsh.model.mesh.generate(2)
```

For hybrid models (discrete terrain + CAD underground), use the built-in GEO kernel — OCC does not support discrete entities on its boundary.

## Synchronization Rules

- **Built-in GEO**: call `gmsh.model.geo.synchronize()` or use `Coherence;` in `.geo`
- **OpenCASCADE**: call `gmsh.model.occ.synchronize()` before:
  - defining physical groups
  - setting mesh size fields
  - setting transfinite constraints
  - generating the mesh
- Synchronization transfers the CAD model to Gmsh's internal representation. Without it, entities are invisible to the mesher.

## Embedded Entities

Force mesh conformity at interior points/curves/surfaces:

```geo
Point{5} In Surface{1};           // embed point 5 in surface 1
Curve{3} In Surface{1};           // embed curve 3 in surface 1
Point{5} In Volume{1};            // embed point 5 in volume 1
Surface{2} In Volume{1};          // embed surface 2 in volume 1
```

Python API:
```python
gmsh.model.mesh.embed(0, [5], 2, 1)   # embed point 5 in surface 1
gmsh.model.mesh.embed(1, [3], 2, 1)   # embed curve 3 in surface 1
```

Embedded entities only work with Delaunay and HXT algorithms.

## Compound Entities (Cross-Patch Meshing)

Compound entities allow meshing across multiple surfaces as if they were one:

```geo
Compound Surface {1, 2, 3};       // mesh surfaces 1,2,3 as one compound
Compound Curve {4, 5};            // mesh curves 4,5 as one compound
```

Python API:
```python
gmsh.model.mesh.setCompound(2, [1, 2, 3])
gmsh.model.mesh.setCompound(1, [4, 5])
```

Useful when imported CAD has too many small patches that produce poor mesh quality at patch boundaries.
