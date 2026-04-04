# Gmsh Mesh Size and Field Control

## Size Determination Hierarchy

Gmsh computes the local mesh size as the **minimum** of:

1. model bounding box size (baseline)
2. sizes specified at geometrical points (if `Mesh.MeshSizeFromPoints = 1`, default)
3. curvature-based sizes (if `Mesh.MeshSizeFromCurvature > 0`, value = elements per 2*Pi rad)
4. background mesh size fields (combined via Min/Max/etc.)
5. per-entity mesh size constraints

The result is then:
- clamped to `[Mesh.MeshSizeMin, Mesh.MeshSizeMax]`
- multiplied by `Mesh.MeshSizeFactor`

Boundary sizes propagate inward if `Mesh.MeshSizeExtendFromBoundary = 1` (default).

### When to disable automatic sizing

When size fields fully control the mesh, disable other sources to prevent unexpected refinement:

```geo
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;
Mesh.MeshSizeExtendFromBoundary = 0;
```

## CLI Size Control

```bash
gmsh model.geo -3 -clmin 0.01 -clmax 1.0 -clscale 0.5 -clcurv 20 -o mesh.msh
```

| Flag | Option | Effect |
| --- | --- | --- |
| `-clmin` | `Mesh.MeshSizeMin` | global minimum element size |
| `-clmax` | `Mesh.MeshSizeMax` | global maximum element size |
| `-clscale` | `Mesh.MeshSizeFactor` | multiply all sizes by factor |
| `-clcurv N` | `Mesh.MeshSizeFromCurvature` | N elements per 2*Pi radians |
| `-clextend` | `Mesh.MeshSizeExtendFromBoundary` | propagate boundary sizes |
| `-bgm file` | — | load background mesh from file |

## Mesh Size Fields Reference

Fields are defined in `.geo` scripts or the Python API. Multiple fields combine via `Min`, `Max`, or `MinAniso`.

### Distance

Compute distance to points, curves, or surfaces. Curves/surfaces are sampled at `Sampling` points per dimension.

```geo
Field[1] = Distance;
Field[1].CurvesList = {1, 2, 3};
Field[1].Sampling = 100;
```

```python
gmsh.model.mesh.field.add("Distance", 1)
gmsh.model.mesh.field.setNumbers(1, "CurvesList", [1, 2, 3])
gmsh.model.mesh.field.setNumber(1, "Sampling", 100)
```

### Threshold

Map a distance field to mesh size: `SizeMin` inside `DistMin`, `SizeMax` outside `DistMax`, interpolated between.

```geo
Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = 0.01;
Field[2].SizeMax = 0.5;
Field[2].DistMin = 0.05;
Field[2].DistMax = 1.0;
Field[2].Sigmoid = 0;         // 1 = sigmoid interpolation, 0 = linear
Field[2].StopAtDistMax = 0;   // 1 = do not impose size beyond DistMax
```

### Box

`VIn` inside a box, `VOut` outside. Optional `Thickness` for transition layer.

```geo
Field[3] = Box;
Field[3].VIn = 0.05;  Field[3].VOut = 0.5;
Field[3].XMin = -1; Field[3].XMax = 1;
Field[3].YMin = -0.5; Field[3].YMax = 0.5;
Field[3].ZMin = -0.5; Field[3].ZMax = 0.5;
Field[3].Thickness = 0.3;
```

### Ball

`VIn` inside a sphere, `VOut` outside. Optional `Thickness` for transition.

```geo
Field[4] = Ball;
Field[4].VIn = 0.02;  Field[4].VOut = 0.5;
Field[4].XCenter = 0; Field[4].YCenter = 0; Field[4].ZCenter = 0;
Field[4].Radius = 0.3;
Field[4].Thickness = 0.1;
```

### Cylinder

`VIn` inside a cylinder, `VOut` outside. Axis defined by center point and direction vector.

```geo
Field[5] = Cylinder;
Field[5].VIn = 0.02;  Field[5].VOut = 0.5;
Field[5].XCenter = 0; Field[5].YCenter = 0; Field[5].ZCenter = 0;
Field[5].XAxis = 1; Field[5].YAxis = 0; Field[5].ZAxis = 0;
Field[5].Radius = 0.1;
```

### BoundaryLayer

2D boundary layer mesh near curves. Critical for CFD wall-resolved meshes.

```geo
Field[6] = BoundaryLayer;
Field[6].CurvesList = {1, 2};
Field[6].Size = 0.001;            // first layer height
Field[6].Ratio = 1.2;             // geometric growth ratio
Field[6].Thickness = 0.05;        // total BL thickness
Field[6].Quads = 1;               // 1 = quad elements in BL
Field[6].FanPointsList = {3, 4};  // fan at sharp corners
```

Parameters:
- `Size` — first layer normal distance
- `Ratio` — growth ratio (typically 1.1–1.3)
- `Thickness` — maximum total BL thickness
- `NbLayers` — layer count when using BetaLaw
- `BetaLaw` / `Beta` — use Beta Law instead of geometric progression
- `Quads` — 1 for quad elements in BL (recommended for CFD)
- `FanPointsList` — sharp corners where fan is needed
- `FanPointsSizesList` — elements per fan
- `SizesList` — per-point override of `Size`
- `SizeFar` — mesh size far from BL curves
- `PointsList` — points where BL terminates
- `ExcludedSurfacesList` — surfaces to skip

**BoundaryLayer must be set as the background field:**

```geo
BoundaryLayer Field = 6;
```

### MathEval

Arbitrary mathematical expression using `x`, `y`, `z` and other fields `F0`, `F1`, ...

```geo
Field[7] = MathEval;
Field[7].F = "0.01 + 0.1 * Sqrt(x*x + y*y)";
```

### Constant

`VIn` inside specified entities and their boundary, `VOut` outside.

```geo
Field[8] = Constant;
Field[8].SurfacesList = {1, 2};
Field[8].VIn = 0.05;
Field[8].VOut = 0.5;
Field[8].IncludeBoundary = 1;
```

### Extend

Extend boundary mesh sizes into surfaces/volumes via weighted harmonic mean with growth ratio.

```geo
Field[9] = Extend;
Field[9].SurfacesList = {1};
Field[9].Ratio = 1.2;
Field[9].SizeMax = 1.0;
```

### Frustum

Interpolate sizes inside a tapered cylinder between two endpoints with inner/outer radii.

```geo
Field[10] = Frustum;
Field[10].X1 = 0; Field[10].Y1 = 0; Field[10].Z1 = 0;
Field[10].X2 = 1; Field[10].Y2 = 0; Field[10].Z2 = 0;
Field[10].InnerR1 = 0; Field[10].InnerR2 = 0;
Field[10].OuterR1 = 0.5; Field[10].OuterR2 = 0.3;
Field[10].InnerV1 = 0.01; Field[10].InnerV2 = 0.01;
Field[10].OuterV1 = 0.5; Field[10].OuterV2 = 0.5;
```

### AutomaticMeshSizeField

Automatic sizing with curvature adaptation and thin-layer detection.

```geo
Field[11] = AutomaticMeshSizeField;
Field[11].nPointsPerCircle = 20;
Field[11].nPointsPerGap = 3;
Field[11].hMin = 0.001;
Field[11].hMax = 1.0;
Field[11].hBulk = 0.5;
Field[11].gradation = 1.1;
Field[11].smoothing = 1;
```

### PostView

Use a scalar post-processing view as background size field (for adaptive remeshing workflows).

```geo
Merge "background.pos";
Field[12] = PostView;
Field[12].ViewIndex = 0;
```

### Combining Fields

```geo
Field[20] = Min;
Field[20].FieldsList = {2, 3, 4};
Background Field = 20;
```

```python
gmsh.model.mesh.field.add("Min", 20)
gmsh.model.mesh.field.setNumbers(20, "FieldsList", [2, 3, 4])
gmsh.model.mesh.field.setAsBackgroundMesh(20)
```

Other combinators: `Max`, `MinAniso`, `IntersectAniso`.

## Size Callback (API only)

```python
def my_size_callback(dim, tag, x, y, z, lc):
    return min(lc, 0.01 + 0.1 * abs(y))

gmsh.model.mesh.setSizeCallback(my_size_callback)
gmsh.model.mesh.generate(3)
```

## Practical Workflow

1. Start with coarse uniform mesh: `Mesh.MeshSizeMin = Mesh.MeshSizeMax = lc_coarse`
2. Verify topology is correct
3. Add one field at a time (Distance + Threshold for wall refinement, Box for region refinement)
4. Combine with `Min` field and set as background
5. Disable automatic sizing sources if fields are authoritative
6. Re-export and verify element count and tag integrity after each refinement change
