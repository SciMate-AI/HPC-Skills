# Gmsh Mesh Size And Field Control

## Contents

- Global versus local control
- Background fields
- Refinement workflow

## Global versus local control

Start simple:

- one global characteristic length for a first mesh
- then local size control at points, curves, or fields only where the physics requires it

Do not jump to many competing size controls before confirming the baseline topology is correct.

## Background fields

Use fields when:

- refinement depends on distance to a boundary
- refinement depends on a box, ball, threshold, or other region rule
- multiple local rules must combine coherently

Fields are often cleaner than scattering size hints across many geometry entities.

## Refinement workflow

Recommended sequence:

1. create a coarse valid mesh
2. inspect whether key gradients or boundary layers need more resolution
3. add one local size rule or field at a time
4. re-export and verify the element count and tag integrity

Aggressive local refinement can hide topology mistakes by making failure messages noisier.
