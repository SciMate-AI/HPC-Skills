# PETSc KSP And PC Matrix

## Contents

- Operator-class mapping
- Direct versus iterative baselines
- Field split and multigrid triggers

## Operator-class mapping

Choose the first baseline from the operator, not from habit.

| Operator class | First baseline |
| --- | --- |
| symmetric positive definite | `cg` plus an SPD-compatible `PC` |
| general sparse nonsymmetric | `gmres` plus an algebraic or factorization-style `PC` |
| saddle-point or block-coupled system | `fgmres` or another flexible outer solver plus a block-aware `PCFieldSplit` plan |
| moderate-size debugging case | `preonly` plus `lu` if memory and backend availability allow |

## Direct versus iterative baselines

Use direct solves to separate algebraic tuning from formulation defects when:

- the matrix fits memory
- a suitable backend is enabled
- iteration noise is hiding whether the operator is correct

Return to iterative methods only after the baseline is sound.

## Field split and multigrid triggers

Reach for `PCFieldSplit` when:

- the system is naturally block-structured
- different fields need different preconditioners
- monolithic AMG or ILU is not respecting the problem structure

Reach for multigrid when:

- the problem is elliptic or diffusion-dominated
- the layout or `DM` can express a meaningful hierarchy
- iteration counts stay high even after the operator is known correct
