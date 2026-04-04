# Gmsh Algorithm Selection Guide

## 2D Meshing Algorithms

All 2D algorithms start from a Delaunay triangulation of the 1D boundary mesh, then refine.

| Algorithm ID | Name | CLI `-algo` | `Mesh.Algorithm` | Best for |
| --- | --- | --- | --- | --- |
| 1 | MeshAdapt | `meshadapt` | 1 | complex curved surfaces; most robust fallback |
| 2 | Automatic | `auto` | 2 | default — uses Delaunay on planes, MeshAdapt on curved |
| 5 | Delaunay | `del2d` | 5 | large planar meshes; fastest; handles complex size fields well |
| 6 | Frontal-Delaunay | `front2d` | 6 | high element quality on moderate models |
| 7 | BAMG | — | 7 | anisotropic triangulations |
| 8 | Frontal-Delaunay for Quads | `delquad` | 8 | right-angle tris suitable for recombination into quads |
| 9 | Packing of Parallelograms | `quadqs` | 9 | experimental quad-dominant |
| 11 | Quasi-Structured Quad | — | 11 | experimental quad |

### Selection decision tree

```
Is the surface planar?
├─ yes → Delaunay (5) for speed; Frontal-Delaunay (6) if quality matters
└─ no (curved) → MeshAdapt (1) for robustness; Frontal-Delaunay (6) if quality matters

Need quads?
├─ yes, structured topology → Transfinite + Recombine
└─ yes, unstructured → Frontal-Delaunay for Quads (8) + Recombine, or QuadQS (9)

Need anisotropic mesh?
└─ BAMG (7)
```

**Automatic fallback**: when Delaunay or Frontal-Delaunay fail on a surface, MeshAdapt is triggered automatically.

## 3D Meshing Algorithms

| Algorithm ID | Name | CLI `-algo` | `Mesh.Algorithm3D` | Best for |
| --- | --- | --- | --- | --- |
| 1 | Delaunay | `del3d` | 1 | most robust; supports embedded entities and general size fields |
| 4 | Frontal (Netgen) | `front3d` | 4 | alternative tet mesher |
| 7 | MMG3D | `mmg3d` | 7 | anisotropic tet adaptation |
| 10 | HXT | `hxt` | 10 | parallel high-performance Delaunay; supports size fields |

### Selection decision tree

```
Default → Delaunay (1)
Need parallel speed on large volumes → HXT (10)
Need anisotropic adaptation → MMG3D (7)
Need Netgen-style advancing front → Frontal (4)

Hybrid meshes (pyramids from quad boundary faces) → only Delaunay (1)
Embedded entities (points/curves in volumes) → only Delaunay (1) or HXT (10)
General mesh size fields → only Delaunay (1) or HXT (10)
```

## Parallel Meshing

Gmsh parallelizes meshing when compiled with OpenMP support.

| Dimension | Parallelism model | Control |
| --- | --- | --- |
| 1D | coarse-grained: multiple curves meshed simultaneously | `Mesh.MaxNumThreads1D` |
| 2D | coarse-grained: multiple surfaces meshed simultaneously | `Mesh.MaxNumThreads2D` |
| 3D (HXT) | fine-grained: single volume meshed in parallel | `Mesh.MaxNumThreads3D` |

Set thread count:

```bash
# CLI
gmsh model.geo -3 -nt 8

# .geo script
General.NumThreads = 8;
Mesh.MaxNumThreads1D = 8;
Mesh.MaxNumThreads2D = 8;
Mesh.MaxNumThreads3D = 8;

# Python API
gmsh.option.setNumber("General.NumThreads", 8)
```

## Mesh Optimization

After generation, improve element quality:

| Option | CLI flag | Effect |
| --- | --- | --- |
| `Mesh.Optimize` | `-optimize` | optimize tets (Gmsh built-in) |
| `Mesh.OptimizeNetgen` | `-optimize_netgen` | optimize tets (Netgen) |
| `Mesh.OptimizeThreshold` | `-optimize_threshold` | only optimize elements below quality threshold |
| `Mesh.HighOrderOptimize` | `-optimize_ho` | untangle/smooth high-order elements |
| `Mesh.Smoothing` | `-smooth N` | N passes of Laplacian smoothing |

```bash
# Typical production workflow: mesh, optimize, smooth
gmsh model.geo -3 -optimize_netgen -smooth 3 -o model.msh
```

Python API:

```python
gmsh.model.mesh.generate(3)
gmsh.model.mesh.optimize("Netgen")       # or "Gmsh", "HighOrder", "HighOrderElastic", etc.
gmsh.model.mesh.setOrder(2)              # set element order before HO optimization
gmsh.model.mesh.optimize("HighOrder")
```

## Subdivision for Full Quad/Hex

`Mesh.SubdivisionAlgorithm`:
- `0` — none (default)
- `1` — all quads / all hexes (splits each tri into 3 quads, each tet into 4 hexes)
- `2` — all hexes (barycentric)

```geo
Mesh.SubdivisionAlgorithm = 1;
```

This is a post-processing step; it does not replace structured meshing but can convert an all-tri/tet mesh into all-quad/hex.

## Element Order

```bash
gmsh model.geo -3 -order 2 -o model.msh     # second-order elements
```

```python
gmsh.model.mesh.generate(3)
gmsh.model.mesh.setOrder(2)
```

High-order optimization should always follow `setOrder`:

```python
gmsh.model.mesh.setOrder(2)
gmsh.model.mesh.optimize("HighOrder")
```

CLI combined:

```bash
gmsh model.geo -3 -order 2 -optimize_ho -o model.msh
```
