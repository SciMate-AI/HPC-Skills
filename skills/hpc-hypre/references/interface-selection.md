# hypre Interface Selection

## Contents

- `IJ`
- `Struct`
- `SStruct`
- Solver-family fit

## `IJ`

Use `IJ` for general sparse matrices assembled row by row.

This is the right default when:

- the discretization is unstructured
- the application already owns a CSR-like sparse matrix assembly path
- the host code thinks in global row ownership instead of geometric stencils

`IJ` is the usual integration path for external applications and for PETSc-mediated usage.

## `Struct`

Use `Struct` when the problem really is a structured-grid problem with regular stencil semantics and geometry-aware indexing.

Do not force a fundamentally unstructured discretization into `Struct` just because the mesh is logically rectangular in one preprocessing stage.

## `SStruct`

Use `SStruct` when the problem is mostly structured but needs more flexibility, such as multiple variables or mixed structured and semi-structured layout concerns.

Choose it only when the application truly benefits from that hybrid abstraction.

## Solver-family fit

After choosing the matrix interface, select the solve path:

| Problem class | First baseline |
| --- | --- |
| SPD-like elliptic operator | `PCG` with `BoomerAMG` |
| general nonsymmetric operator | `GMRES` or `FlexGMRES` with `BoomerAMG` preconditioning |
| debugging a moderate system with a host-side direct path available | reduce to the host code's direct baseline first, then return to hypre |

The interface decision comes before parameter tuning.
