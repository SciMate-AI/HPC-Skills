# OpenFOAM Mesh Quality and Generation Guide

Concrete checkMesh thresholds, snappyHexMesh tips, and mesh troubleshooting.

## checkMesh Quality Thresholds

### Default OpenFOAM Thresholds

| Metric | Default threshold | What it means |
| --- | --- | --- |
| Max non-orthogonality | 70° | Angle between face normal and cell-center vector |
| Max skewness | 4 | Deviation from ideal face/cell center alignment |
| Max aspect ratio | 1000 | Ratio of longest to shortest cell edge |
| Min cell volume | > 0 | Negative volume = invalid mesh |
| Face flatness | — | Reported with `-allGeometry` flag |

### Practical Quality Guidelines

| Metric | Good | Acceptable | Problematic | Likely diverge |
| --- | --- | --- | --- | --- |
| Non-orthogonality | < 65° | 65–75° | 75–85° | > 85° |
| Skewness | < 2 | 2–4 | 4–10 | > 10 |
| Aspect ratio | < 100 | 100–500 | 500–1000 | > 1000 (non-BL) |
| Volume ratio (neighbor cells) | < 2 | 2–5 | 5–10 | > 10 |

### Running checkMesh

```bash
checkMesh                              # basic check
checkMesh -allGeometry -allTopology    # comprehensive check
checkMesh -latestTime                  # check mesh at latest time (useful for dynamic mesh)
checkMesh -writeAllFields              # write quality fields for visualization
```

### Interpreting checkMesh Output

```
Mesh stats
    points:           12345
    faces:            34567
    cells:            10000
    ...
Checking geometry...
    Overall domain bounding box (-1 -1 0) (10 2 1)
    ...
    Max non-orthogonality = 72.3456 average: 8.12345
    ***Number of severely non-orthogonal (> 70) faces: 42
    ***Number of non-orthogonal faces (> 85): 3        ← these will cause problems
    Mesh non-orthogonality Max: 72.3456 average: 8.12345
    Max skewness = 2.34 OK.
    Max aspect ratio = 45.6 OK.

Mesh OK.      ← even "OK" doesn't mean good quality for your numerics
```

### Compensating for Poor Mesh Quality

| Quality issue | Numerical compensation | Cost |
| --- | --- | --- |
| Non-orthogonality 70–80° | `nNonOrthogonalCorrectors 1;` | ~30% more per step |
| Non-orthogonality 80–85° | `nNonOrthogonalCorrectors 2;` + limited snGrad | ~60% more |
| High skewness | `cellLimited` gradient; `upwind` convection | Accuracy loss |
| High aspect ratio in bulk | `cellLimited Gauss linear 1` | Minor |

## blockMesh Best Practices

### Vertex Ordering (Right-Hand Rule)

```
    7----------6
   /|         /|
  4----------5 |        Vertex numbering follows right-hand rule:
  | |        | |        - Bottom face: 0-1-2-3 (counter-clockwise from outside)
  | 3--------|-2        - Top face: 4-5-6-7 (counter-clockwise from outside)
  |/         |/
  0----------1
```

### Grading for Boundary Layers

```c++
blocks
(
    hex (0 1 2 3 4 5 6 7) (100 50 1)
    simpleGrading
    (
        1                   // x: uniform
        (
            (0.2 0.3 4)     // bottom 20% of cells, 30% of total cells, expansion ratio 4
            (0.6 0.4 1)     // middle 60%, 40% of cells, uniform
            (0.2 0.3 0.25)  // top 20%, 30% of cells, expansion ratio 0.25 (=1/4)
        )
        1                   // z: uniform (2D)
    )
);
```

Grading format: `(fraction_of_length fraction_of_cells expansion_ratio)`

### Patch Definition

```c++
boundary
(
    inlet
    {
        type patch;
        faces ( (0 4 7 3) );
    }
    outlet
    {
        type patch;
        faces ( (1 2 6 5) );
    }
    walls
    {
        type wall;
        faces ( (0 1 5 4) (3 7 6 2) );
    }
    frontAndBack
    {
        type empty;
        faces ( (0 3 2 1) (4 5 6 7) );
    }
);
```

## snappyHexMesh Workflow

### Overview

```bash
1. blockMesh              # create background hex mesh
2. surfaceFeatureExtract   # extract edges from STL
3. snappyHexMesh -overwrite   # snap/refine around geometry
4. checkMesh              # verify quality
```

### Key snappyHexMeshDict Sections

**castellatedMeshControls** (refinement):
```c++
castellatedMeshControls
{
    maxLocalCells       1000000;
    maxGlobalCells      5000000;
    minRefinementCells  10;
    nCellsBetweenLevels 3;       // cells between refinement levels (smoothing)
    resolveFeatureAngle 30;
    locationInMesh      (0.1 0.1 0.1);   // point INSIDE the flow domain
    
    refinementSurfaces
    {
        body
        {
            level (2 3);         // min and max refinement levels
        }
    }
    refinementRegions
    {
        wake
        {
            mode    inside;
            levels  ((1 2));     // refine 2 levels inside wake region
        }
    }
}
```

**snapControls:**
```c++
snapControls
{
    nSmoothPatch    3;
    tolerance       2.0;
    nSolveIter      100;
    nRelaxIter      5;
    nFeatureSnapIter 10;
}
```

**addLayersControls** (boundary layers):
```c++
addLayersControls
{
    relativeSizes   true;
    layers
    {
        body
        {
            nSurfaceLayers  5;           // number of layers
        }
    }
    expansionRatio  1.2;                 // growth ratio between layers
    firstLayerThickness 0.3;             // relative to cell size
    minThickness    0.1;
    featureAngle    60;                  // angle above which layers are not added
    nGrow           0;
    nSmoothSurfaceNormals 1;
    nSmoothThickness 10;
    nRelaxIter      5;
    maxFaceThicknessRatio 0.5;
    maxThicknessToMedialRatio 0.3;
    minMedianAxisAngle 90;
    nBufferCellsNoExtrude 0;
    nLayerIter      50;
}
```

## y+ Targeted Layer Meshing

To achieve target y+:

```
First layer height: y = y+ * nu / u_tau

where:
  u_tau = sqrt(tau_w / rho)
  tau_w = 0.5 * C_f * rho * U^2
  C_f = 0.058 * Re_L^(-0.2)     (turbulent flat plate)
```

Quick calculation for air at 20°C (nu = 1.5e-5 m^2/s), U = 30 m/s, L = 1 m:
```
Re_L = 30 * 1 / 1.5e-5 = 2e6
C_f  = 0.058 * (2e6)^(-0.2) = 0.00335
u_tau = sqrt(0.5 * 0.00335 * 30^2) = 1.23 m/s

For y+ = 1:  y = 1 * 1.5e-5 / 1.23 = 1.22e-5 m = 0.012 mm
For y+ = 30: y = 30 * 1.5e-5 / 1.23 = 3.66e-4 m = 0.37 mm
```

## Common Mesh Pitfalls

1. **Negative cell volumes**: Mesh is invalid. Usually from bad STL geometry or snappy failure. Must fix before running solver.
2. **checkMesh says OK but solver diverges**: Quality below solver threshold (not checkMesh threshold). Tighten numerics or remesh.
3. **Boundary layers not added**: Feature angle too small, or mesh too coarse at surface. Increase `featureAngle` or refine surface mesh.
4. **locationInMesh inside solid**: snappyHexMesh inverts the mesh. Place point clearly inside the flow domain.
5. **Cell count explodes**: Too many refinement levels or regions. Start with fewer levels and add selectively.
