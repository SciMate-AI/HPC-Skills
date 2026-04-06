# IGA Example Recipes

## Source Focus

- `dynaexamples.com/iga`
- `dynaexamples.com/iga/tensile-test`
- `dynaexamples.com/iga/tensile-test/copy_of_reduced-input`

## Use This Reference For

- deciding whether IGA is the right formulation instead of shell or solid finite elements
- understanding how LS-DYNA IGA examples structure trimmed NURBS geometry and boundary conditions
- safely reusing IGA-specific cards from the tensile-test example

## Starter Deck Mapping

IGA is currently a source-first branch in this skill.

- start from the upstream `Tensile Test` example itself
- borrow project organization from `assets/templates/model-include-tree.txt` only after the IGA model runs
- use `assets/templates/implicit-static-outline.k` only for high-level loading and output staging, not as a direct keyword starter

## Why Source-First Matters

The `Reduced Input IGA Model` page exposes a very specific family of IGA keywords, including:

- `*IGA_POINT_UVW`
- `*SET_IGA_POINT_UVW`
- `*IGA_1D_BREP`
- `*IGA_1D_NURBS_UVW`
- `*IGA_EDGE_UVW`
- `*IGA_EDGE_XYZ`
- `*IGA_2D_NURBS_XYZ`
- `*IGA_FACE_XYZ`

This is too solver-specific to replace safely with a generic local starter without a validated geometry pipeline.

## Tensile Test

Applicable problem:

- flat-specimen tensile test using trimmed NURBS shells
- first LS-DYNA IGA learning case
- understanding how to apply boundary conditions on IGA shells

Key solver family:

- IGA trimmed NURBS shells with elasto-plastic material and element deletion

The branch overview explicitly states:

- IGA uses spline basis functions for geometry and solution field
- it can yield easier CAD-driven model generation
- it can provide a larger explicit time step

Copy these controls:

- trimmed-NURBS shell topology layout
- boundary-condition application style on IGA shells
- specimen-style tension loading and deletion observability

Do not copy blindly:

- the exact spline patch layout
- the specimen dimensions
- element deletion settings unless fracture is part of the target problem
- assume IGA is automatically better if the source geometry is not NURBS-based

Starter:

- start from the upstream `Tensile Test` example
- use `assets/templates/implicit-static-outline.k` only as a guide for load stepping and outputs if the IGA solve is quasi-static

## Practical Migration Rule

Use IGA when:

- CAD fidelity and smoothness matter
- shell-like geometry fits trimmed NURBS patches
- a higher explicit time step or smoother geometry representation is valuable

Do not force IGA when:

- the model is already well-served by conventional shell or solid meshes
- trimming and patch construction would dominate project risk

