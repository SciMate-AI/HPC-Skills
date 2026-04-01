# PETSc External Backend Matrix

## Contents

- Direct solver backends
- Algebraic preconditioner backends
- Matrix-free triggers

## Direct solver backends

| Need | PETSc direction |
| --- | --- |
| debug operator correctness on a moderate problem | `pc_type lu` with an enabled direct backend |
| large distributed sparse direct solve | only if the build explicitly supports the backend and memory budget allows it |
| scale-first production run | prefer iterative plus structured preconditioning unless there is a strong reason not to |

Direct backends are mainly a correctness and baseline tool unless the workload size remains moderate.

## Algebraic preconditioner backends

| Need | PETSc direction |
| --- | --- |
| robust AMG-style preconditioning for sparse elliptic operators | HYPRE-backed `boomeramg` if the build enables it |
| block-structured multiphysics | `fieldsplit` with per-block inner solvers |
| local or incomplete factorization baseline | `ilu` or related local-factorization path when the matrix format and run mode allow it |

## Matrix-free triggers

Use matrix-free or shell operators when:

- matrix assembly is too expensive or impractical
- a credible preconditioning path still exists
- the application can provide stable Jacobian or operator actions

Do not switch to matrix-free just to avoid debugging assembly if the preconditioner story becomes weaker.
