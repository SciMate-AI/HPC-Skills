# PETSc Parallel And Runtime Debugging

## Assembly discipline

Many PETSc failures that look like solver trouble are really layout or assembly trouble.

Check these first:

- ownership ranges are consistent across vectors and matrices
- off-process entries are inserted through supported assembly paths
- matrix and vector assembly is completed before solve
- boundary conditions, nullspaces, and constraints are applied in the same distributed layout used at runtime

## Monitoring discipline

During repair, enable enough monitoring to answer:

- did setup complete
- which object is actually solving
- how many iterations ran
- why the solve stopped
- whether the residual norm trend is plausible

Do not jump to preconditioner changes until those answers are visible.

## Common failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| solver diverges immediately | malformed operator, wrong boundary conditions, or broken initial guess | validate assembly and problem scaling before retuning `KSP` or `SNES` |
| options appear ignored | wrong object or wrong options prefix | inspect the configured object path and prefix handling |
| parallel run behaves differently from serial | distributed assembly or ownership bug | compare layouts, assembly sequence, and rank-local contributions |
| external preconditioner option is rejected | backend not enabled in the PETSc build | verify configure-time package support |

## Escalation order

1. fix assembly and layout correctness
2. use a robust baseline solve
3. inspect convergence reasons
4. only then optimize for scalability
