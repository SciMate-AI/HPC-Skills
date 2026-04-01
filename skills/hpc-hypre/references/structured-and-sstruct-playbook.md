# hypre Structured And SStruct Playbook

## Structured path

Use `Struct` when the unknown layout is naturally expressed by a regular grid and stencil semantics matter.

Good fit:

- finite-difference or stencil-heavy operators on regular grids
- geometry-driven indexing that is simpler than generic sparse assembly

## Semi-structured path

Use `SStruct` when the model is mostly structured but:

- carries multiple variables
- needs more than one structured part
- benefits from hybrid structured organization

## Guardrails

- do not convert an unstructured FEM or graph-based operator into `Struct` just to chase AMG performance
- do not choose `SStruct` unless the application really benefits from the extra abstraction

The more complex interface is not automatically the better one.
