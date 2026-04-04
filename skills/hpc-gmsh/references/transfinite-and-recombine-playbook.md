# Gmsh Transfinite, Recombine, and Structured Meshing Playbook

## Transfinite Meshing

Transfinite (mapped) meshing enforces structured node placement on curves, surfaces, and volumes.

### TransfiniteCurve

Set the number of nodes on a curve:

```geo
Transfinite Curve {1, 2, 3, 4} = 20;                        // 20 nodes, uniform
Transfinite Curve {1} = 20 Using Progression 1.1;            // geometric grading
Transfinite Curve {2} = 20 Using Bump 0.1;                   // refined at both ends
```

Python API:
```python
gmsh.model.mesh.setTransfiniteCurve(1, 20)                          # uniform
gmsh.model.mesh.setTransfiniteCurve(1, 20, "Progression", 1.1)      # geometric
gmsh.model.mesh.setTransfiniteCurve(1, 20, "Bump", 0.1)             # bump
```

**Progression**: ratio between consecutive segment lengths. `> 1` refines toward the start, `< 1` refines toward the end (or use negative curve orientation).

**Bump**: refines toward both ends of the curve. Value controls the amount of refinement.

### TransfiniteSurface

Requires the surface to be bounded by 3 or 4 curves with compatible transfinite node counts.

```geo
Transfinite Surface {1};                         // auto-detect corners
Transfinite Surface {1} = {p1, p2, p3, p4};     // explicit corner points
// corners listed in order: two opposite edges must have the same node count
```

Python API:
```python
gmsh.model.mesh.setTransfiniteSurface(1)
gmsh.model.mesh.setTransfiniteSurface(1, "Left", [p1, p2, p3, p4])
```

Arrangement types: `"Left"`, `"Right"`, `"AlternateLeft"`, `"AlternateRight"` — control diagonal direction in the mapped mesh.

**Compatibility rule**: for a 4-sided surface, opposite edges must have the same number of transfinite nodes. For a 3-sided surface (degenerate quad), one "edge" is a single point.

### TransfiniteVolume

Requires the volume to be bounded by 5 or 6 transfinite surfaces:
- 6 surfaces → hexahedra (like a topological cube)
- 5 surfaces → prisms (like a topological triangular prism)

```geo
Transfinite Volume {1};
Transfinite Volume {1} = {p1, p2, p3, p4, p5, p6, p7, p8};   // 8 corner points for hex
```

Python API:
```python
gmsh.model.mesh.setTransfiniteVolume(1)
gmsh.model.mesh.setTransfiniteVolume(1, [p1, p2, p3, p4, p5, p6, p7, p8])
```

### Automatic Transfinite

Gmsh can automatically detect transfinite-compatible topologies:

```python
gmsh.model.mesh.setTransfiniteAutomatic()
```

```geo
Mesh.TransfiniteAutomatic = 1;
```

Uses `Mesh.MeshSizeMin` / `Mesh.MeshSizeMax` to determine node counts.

## Recombine

Recombination converts triangles into quads (2D) or activates hex/prism generation in structured 3D.

### Surface Recombination

```geo
Recombine Surface {1};
Recombine Surface {1} = 45;    // angle threshold (default 45°)
```

Python API:
```python
gmsh.model.mesh.setRecombine(2, 1)
```

### Global Recombination

```geo
Mesh.RecombineAll = 1;                     // recombine all surfaces
Mesh.RecombinationAlgorithm = 0;           // 0=simple, 1=blossom, 2=simple full-quad, 3=blossom full-quad
```

Blossom (1) is generally recommended for better quad quality.

### Smoothing After Recombination

```geo
Mesh.Smoothing = 100;      // Laplacian smoothing passes
```

```python
gmsh.model.mesh.setSmoothing(2, surface_tag, 100)
```

Smoothing is especially important after recombination to improve quad element quality.

## Structured Extrusion

Extrusions with `Layers` produce structured meshes in the extrusion direction:

```geo
// Simple uniform extrusion: 10 layers over height 0.5
Extrude {0, 0, 0.5} { Surface{1}; Layers{10}; Recombine; }

// Graded extrusion: 5 layers for first 30%, 15 layers for remaining 70%
Extrude {0, 0, 1} { Surface{1}; Layers{ {5, 15}, {0.3, 1.0} }; Recombine; }

// Rotation extrusion with layers
Extrude {{0, 1, 0}, {0, 0, 0}, Pi/2} { Surface{1}; Layers{20}; Recombine; }
```

With `Recombine`:
- 2D tri surface → hex in extrusion direction
- 2D quad surface (from transfinite + recombine) → pure hex

Without `Recombine`:
- 2D tri surface → prisms in extrusion direction

## Periodic Meshes

Force the mesh on one entity to match another via an affine transformation.

### `.geo` Syntax

```geo
// Make curve 2 periodic with curve 1 via translation
Periodic Curve {2} = {1} Translate {1, 0, 0};

// Make surface 6 periodic with surface 5 via translation
Periodic Surface {6} = {5} Translate {0, 0, 1};

// With rotation
Periodic Surface {6} = {5} Rotate {{0, 0, 1}, {0, 0, 0}, Pi/2};

// With explicit affine matrix (4x4 row-major)
Periodic Surface {6} = {5} Affine {1, 0, 0, 1,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1};
```

### Python API

```python
# Translation: affine transform as 4x4 row-major matrix
# T = [1, 0, 0, tx, 0, 1, 0, ty, 0, 0, 1, tz, 0, 0, 0, 1]
gmsh.model.mesh.setPeriodic(2, [6], [5],
    [1, 0, 0, 1.0,    # translate x by 1.0
     0, 1, 0, 0,
     0, 0, 1, 0,
     0, 0, 0, 1])

gmsh.model.mesh.setPeriodic(1, [2], [1],
    [1, 0, 0, 0,
     0, 1, 0, 1.0,    # translate y by 1.0
     0, 0, 1, 0,
     0, 0, 0, 1])
```

## High-Order Structured Meshes

```geo
Mesh 3;
Mesh.ElementOrder = 2;     // second order
// or equivalently: gmsh model.geo -3 -order 2
```

```python
gmsh.model.mesh.generate(3)
gmsh.model.mesh.setOrder(2)
gmsh.model.mesh.optimize("HighOrder")
```

## Complete Structured Hex Workflow Example

```geo
SetFactory("OpenCASCADE");

// Create box
Box(1) = {0, 0, 0, 1, 0.5, 0.2};

// Transfinite on all curves
Transfinite Curve {:} = 20;       // all curves, 20 nodes

// Transfinite on all surfaces
Transfinite Surface {:};
Recombine Surface {:};

// Transfinite volume
Transfinite Volume {1};

Mesh 3;
Save "hex_box.msh";
```

Python API equivalent:

```python
import gmsh
gmsh.initialize()
gmsh.model.add("hex_box")

gmsh.model.occ.addBox(0, 0, 0, 1, 0.5, 0.2)
gmsh.model.occ.synchronize()

for c in gmsh.model.getEntities(1):
    gmsh.model.mesh.setTransfiniteCurve(c[1], 20)
for s in gmsh.model.getEntities(2):
    gmsh.model.mesh.setTransfiniteSurface(s[1])
    gmsh.model.mesh.setRecombine(s[0], s[1])
gmsh.model.mesh.setTransfiniteVolume(1)

gmsh.model.mesh.generate(3)
gmsh.write("hex_box.msh")
gmsh.finalize()
```

## Subdivision for All-Quad/All-Hex

As a post-processing alternative to structured meshing:

```geo
Mesh.SubdivisionAlgorithm = 1;   // split tris→quads, tets→hexes
Mesh.SubdivisionAlgorithm = 2;   // barycentric hex subdivision
```

This doubles the node count but guarantees all-quad/all-hex from any unstructured mesh.

## Guardrails

- Do not assign transfinite constraints to curves/surfaces with incompatible topology (wrong number of bounding curves, mismatched node counts on opposite edges)
- Do not expect recombine to work well on poor-quality triangulations — improve the underlying mesh first
- Do not mix transfinite and unstructured on surfaces that share edges (the transfinite constraint propagates)
- If structured meshing is essential, design the geometry around it from the start — retrofit is fragile
- Always inspect element types after meshing: `gmsh.model.mesh.getElementTypes()` in the API, or check the `.msh` output
- Smoothing (50–100 passes) after recombination significantly improves quad quality
