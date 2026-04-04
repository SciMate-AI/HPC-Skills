# Gmsh Boundary Layer and Refinement Recipes

## 2D Boundary Layer (BoundaryLayer Field)

The `BoundaryLayer` field creates structured prismatic layers near specified curves. This is the primary mechanism for CFD-quality near-wall meshes in 2D Gmsh models.

### Basic Setup

```geo
SetFactory("OpenCASCADE");
Rectangle(1) = {0, 0, 0, 2, 0.5};

Physical Surface("fluid") = {1};
Physical Curve("inlet") = {4};
Physical Curve("outlet") = {2};
Physical Curve("walls") = {1, 3};

// Boundary layer on walls
Field[1] = BoundaryLayer;
Field[1].CurvesList = {1, 3};         // wall curves
Field[1].Size = 0.0005;               // first layer height
Field[1].Ratio = 1.2;                 // growth ratio
Field[1].Thickness = 0.02;            // max BL thickness
Field[1].Quads = 1;                   // quad elements in BL
Field[1].FanPointsList = {};           // fan at sharp corners (if any)

BoundaryLayer Field = 1;

Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;
Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeMax = 0.05;
Mesh 2;
```

### First Layer Height Estimation (y+ targeting)

For wall-resolved RANS (y+ ~ 1):

```
y_first = y_plus * mu / (rho * u_tau)
u_tau = sqrt(tau_w / rho)
tau_w ~ 0.5 * Cf * rho * U_inf^2
Cf ~ 0.058 * Re_L^(-0.2)     (turbulent flat plate)
```

Practical estimates:

| Flow | Re_L | y+ = 1 first layer | Typical ratio | Layers |
| --- | --- | --- | --- | --- |
| Low-speed channel | 1e4 | ~1e-3 L | 1.15–1.2 | 15–25 |
| External aero | 1e6 | ~1e-5 L | 1.2–1.3 | 20–40 |
| High-Re turbomachinery | 1e7 | ~1e-6 L | 1.1–1.2 | 30–50 |

### Fan at Sharp Corners

Trailing edges, leading edges, and interior corners need mesh fans to avoid highly skewed elements:

```geo
Field[1].FanPointsList = {3, 4};           // corner points
Field[1].FanPointsSizesList = {10, 10};    // elements per fan
```

### BL Termination

Control where the BL ends using `PointsList`:

```geo
Field[1].PointsList = {1, 2};   // BL terminates at these points
```

### Excluding Surfaces

Prevent BL construction on specific surfaces:

```geo
Field[1].ExcludedSurfacesList = {2};
```

### BetaLaw Grading

Instead of geometric progression, use a Beta Law for smoother grading:

```geo
Field[1].BetaLaw = 1;
Field[1].Beta = 1.01;
Field[1].NbLayers = 20;
```

## Distance + Threshold Refinement

The most common unstructured refinement pattern: refine near specific geometry entities.

### Near-Wall Refinement

```geo
// Step 1: compute distance to wall curves
Field[1] = Distance;
Field[1].CurvesList = {1, 3};
Field[1].Sampling = 200;

// Step 2: map distance to size
Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = 0.005;    // size at the wall
Field[2].SizeMax = 0.1;      // size far from wall
Field[2].DistMin = 0.0;      // distance where SizeMin applies
Field[2].DistMax = 0.2;      // distance where SizeMax applies

Background Field = 2;
```

### Refinement Around a Point (Wake Region)

```geo
Field[3] = Distance;
Field[3].PointsList = {10};     // point in wake

Field[4] = Threshold;
Field[4].InField = 3;
Field[4].SizeMin = 0.01;
Field[4].SizeMax = 0.2;
Field[4].DistMin = 0;
Field[4].DistMax = 0.5;
```

### Combining Multiple Refinement Zones

```geo
Field[5] = Min;
Field[5].FieldsList = {2, 4};    // take minimum of wall and wake refinement
Background Field = 5;
```

## Box Refinement

Refine inside a rectangular region (e.g., around an object of interest):

```geo
Field[6] = Box;
Field[6].VIn = 0.01;
Field[6].VOut = 0.2;
Field[6].XMin = -0.5; Field[6].XMax = 1.5;
Field[6].YMin = -0.3; Field[6].YMax = 0.3;
Field[6].ZMin = -0.3; Field[6].ZMax = 0.3;
Field[6].Thickness = 0.2;      // smooth transition
```

## Cylinder Refinement

Refine inside a cylindrical region (e.g., around a pipe or wake):

```geo
Field[7] = Cylinder;
Field[7].VIn = 0.01;
Field[7].VOut = 0.2;
Field[7].XCenter = 0; Field[7].YCenter = 0; Field[7].ZCenter = 0;
Field[7].XAxis = 1; Field[7].YAxis = 0; Field[7].ZAxis = 0;
Field[7].Radius = 0.2;
```

## Ball Refinement

Refine inside a spherical region:

```geo
Field[8] = Ball;
Field[8].VIn = 0.005;
Field[8].VOut = 0.2;
Field[8].XCenter = 0; Field[8].YCenter = 0; Field[8].ZCenter = 0;
Field[8].Radius = 0.3;
Field[8].Thickness = 0.1;
```

## MathEval for Custom Sizing

When sizing depends on an arbitrary function:

```geo
Field[9] = MathEval;
Field[9].F = "0.001 + 0.05 * (x*x + y*y)";   // refine near origin
```

```geo
Field[10] = MathEval;
Field[10].F = "0.005 + 0.1 * Abs(y)";          // refine near y=0 plane
```

## Automatic Size Field

Use when you want Gmsh to determine sizes from geometry curvature and thin-layer gaps:

```geo
Field[11] = AutomaticMeshSizeField;
Field[11].nPointsPerCircle = 20;     // curvature adaptation
Field[11].nPointsPerGap = 3;         // thin-layer detection
Field[11].hMin = 0.0005;
Field[11].hMax = 0.5;
Field[11].hBulk = -1;                // -1 = auto
Field[11].gradation = 1.1;           // size growth rate
Field[11].smoothing = 1;
Background Field = 11;
```

## Complete 2D CFD Refinement Recipe

Airfoil with BL, wake refinement, and far-field sizing:

```geo
SetFactory("OpenCASCADE");
// ... assume airfoil geometry with:
//   curve 1 = airfoil surface
//   point 5 = trailing edge
//   farfield boundary curves 10-13

// Boundary layer on airfoil
Field[1] = BoundaryLayer;
Field[1].CurvesList = {1};
Field[1].Size = 0.0001;
Field[1].Ratio = 1.15;
Field[1].Thickness = 0.01;
Field[1].Quads = 1;
Field[1].FanPointsList = {5};       // TE fan
Field[1].FanPointsSizesList = {15};
BoundaryLayer Field = 1;

// Wake refinement
Field[2] = Distance;
Field[2].PointsList = {5};
Field[2].Sampling = 200;

Field[3] = Threshold;
Field[3].InField = 2;
Field[3].SizeMin = 0.002;
Field[3].SizeMax = 0.1;
Field[3].DistMin = 0;
Field[3].DistMax = 1.0;

// Box around airfoil
Field[4] = Box;
Field[4].VIn = 0.005;
Field[4].VOut = 1e22;
Field[4].XMin = -0.5; Field[4].XMax = 2.0;
Field[4].YMin = -0.5; Field[4].YMax = 0.5;
Field[4].ZMin = -1; Field[4].ZMax = 1;
Field[4].Thickness = 0.5;

// Combine
Field[5] = Min;
Field[5].FieldsList = {3, 4};
Background Field = 5;

Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;
Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeMax = 0.5;
Mesh.Algorithm = 6;    // Frontal-Delaunay

Mesh 2;
Save "airfoil.msh";
```

## 3D Boundary Layer Considerations

Gmsh's `BoundaryLayer` field is primarily for 2D meshes. For 3D boundary layers:

1. **Extrusion approach**: create a 2D mesh with BL on the surface, then extrude with `Layers` to create structured hex/prism layers near walls
2. **External tools**: use snappyHexMesh (OpenFOAM), cfMesh, or other dedicated 3D BL tools, then import
3. **Distance + Threshold**: unstructured refinement near walls (not true BL, but adequate for wall-function approaches)
4. **AutomaticMeshSizeField with nPointsPerGap**: detects thin layers and adapts

For wall-resolved 3D RANS, structured BL layers are usually essential and Gmsh alone may not be the best tool — consider coupling with OpenFOAM's snappyHexMesh for the BL and using Gmsh for the far-field.
