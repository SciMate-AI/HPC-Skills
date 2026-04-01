# PETSc DM And Discretization Playbook

## When To Use DM

Bring `DM` into the design when:

- mesh topology or field layout drives assembly
- multigrid or hierarchy support should follow the discretization
- block fields or staggered layouts need a first-class representation

## Common choices

| Need | PETSc direction |
| --- | --- |
| regular structured grids | `DMDA` |
| unstructured meshes and topology-aware discretization | `DMPlex` |
| multiple coupled fields on a managed layout | `DMComposite` or field-aware `DM` setup |

## Practical rules

- tie ownership and ghosting rules to the chosen `DM`
- keep nullspace handling attached to the operator or discretization setup
- if a hierarchy exists, make it explicit instead of approximating it with unrelated solver options

Using `DM` early usually simplifies later multigrid and field-split work.
