# Gmsh Modeling Kernels And Geometry

## Contents

- GEO versus OpenCASCADE
- Topology-building rules
- Boolean-modeling triggers

## GEO versus OpenCASCADE

Use the built-in GEO kernel when:

- the model is simple and fully scripted
- points, lines, surfaces, and volumes are easy to define directly
- you want explicit low-level control over topology

Use OpenCASCADE when:

- the geometry is CAD-like
- booleans, extrusions, fillets, or solid operations matter
- the model needs more robust constructive-solid geometry behavior

Pick one kernel early. Mid-model switching usually makes topology and tag reasoning harder.

## Topology-building rules

High-confidence sequence:

1. create geometry entities cleanly
2. synchronize when the chosen API path requires it
3. inspect dimensions and boundaries
4. only then define physical groups and mesh controls

Geometry bugs often look like meshing bugs later. Fix topology first.

## Boolean-modeling triggers

Reach for OpenCASCADE booleans when:

- multiple solids must be fused, cut, or fragmented
- shared interfaces should be generated from constructive geometry
- manual point or curve bookkeeping is becoming brittle

Do not overcomplicate a simple rectangle or block with unnecessary boolean logic.
