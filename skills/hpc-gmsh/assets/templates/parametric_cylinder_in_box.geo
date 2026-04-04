// Gmsh .geo: parametric cylinder-in-box with distance-based refinement.
// Useful as starting point for external flow (e.g., flow past a cylinder).

SetFactory("OpenCASCADE");

// ── Parameters ──
DefineConstant[
  R = {0.5, Name "Geometry/Cylinder radius"},
  Lx = {20, Name "Geometry/Domain length (x)"},
  Ly = {10, Name "Geometry/Domain width (y)"},
  Lz = {2, Name "Geometry/Domain depth (z)"},
  cx = {5, Name "Geometry/Cylinder center x"},
  cy = {5, Name "Geometry/Cylinder center y"},
  lc_near = {0.02, Name "Mesh/Near-cylinder size"},
  lc_far = {1.0, Name "Mesh/Far-field size"},
  refine_dist = {3, Name "Mesh/Refinement distance"}
];

// ── Geometry ──
Box(1) = {0, 0, 0, Lx, Ly, Lz};
Cylinder(2) = {cx, cy, 0, 0, 0, Lz, R};
BooleanDifference(3) = { Volume{1}; Delete; }{ Volume{2}; Delete; };

// ── Physical groups ──
// Identify boundaries by bounding box or position (adjust after inspecting)
Physical Volume("fluid", 1) = {3};

// After BooleanDifference, inspect surfaces:
surfs[] = Boundary{ Volume{3}; };
// For a generic setup, tag all surfaces; refine manually after inspection:
Physical Surface("walls", 2) = {surfs[]};

// ── Mesh size fields ──
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;
Mesh.MeshSizeExtendFromBoundary = 0;

// Distance from cylinder surface curves
Field[1] = Distance;
Field[1].SurfacesList = {surfs[]};  // will refine near all surfaces
Field[1].Sampling = 100;

// Map distance to size
Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = lc_near;
Field[2].SizeMax = lc_far;
Field[2].DistMin = 0;
Field[2].DistMax = refine_dist;

Background Field = 2;

// ── Mesh ──
Mesh.Algorithm3D = 10;  // HXT (parallel)
General.NumThreads = 4;
Mesh 3;
Save "cylinder_in_box.msh";
