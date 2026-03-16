# FEniCS Runtime Selection

## Contents

- Choose the stack
- Keep imports coherent
- Environment notes

## Choose the stack

Decide up front whether the target is:

- classic FEniCS using `from fenics import *` or `from dolfin import *`
- DOLFINx using `from dolfinx import fem, io, mesh` plus `mpi4py` and often `petsc4py`

Do not switch mid-script.

Use classic FEniCS when:

- the environment already ships `fenics`
- the user wants older tutorial compatibility
- the script relies on APIs such as `FunctionSpace`, `DirichletBC`, and direct `solve(a == L, ...)`

Use DOLFINx when:

- the environment is current and MPI/PETSc aware
- the user wants current APIs and active ecosystem support
- the workflow already depends on `dolfinx`, `basix`, and PETSc objects

## Keep imports coherent

Classic pattern:

```python
from fenics import *
```

Modern DOLFINx pattern:

```python
from mpi4py import MPI
from dolfinx import fem, io, mesh
from petsc4py import PETSc
```

If a script mixes those two styles, stop and normalize it before debugging the PDE itself.

## Environment notes

DOLFINx documentation and workshops target Linux-first workflows and commonly recommend WSL on Windows. If the user is on Windows and the runtime is missing, prefer WSL or a containerized environment instead of inventing unsupported install steps.
