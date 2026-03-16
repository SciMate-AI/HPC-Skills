# FEniCS Implementation Skeletons

## Contents

- Classic linear skeleton
- DOLFINx linear skeleton
- DOLFINx transient skeleton
- Usage rules

## Classic linear skeleton

Use this when the environment is classic FEniCS and the PDE is linear:

```python
from fenics import *

mesh = UnitSquareMesh(32, 32)
V = FunctionSpace(mesh, "P", 1)
u = TrialFunction(V)
v = TestFunction(V)
f = Constant(1.0)

def boundary(x, on_boundary):
    return on_boundary

bc = DirichletBC(V, Constant(0.0), boundary)
a = inner(grad(u), grad(v)) * dx
L = f * v * dx
u_sol = Function(V)
solve(a == L, u_sol, bc)
```

Use this as a structural template, then replace mesh, source, and boundary logic.

## DOLFINx linear skeleton

Use this when the environment is DOLFINx and the PDE is linear:

```python
from mpi4py import MPI
from dolfinx import fem, io, mesh
import ufl

domain = mesh.create_unit_square(MPI.COMM_WORLD, 32, 32)
V = fem.functionspace(domain, ("Lagrange", 1))
u = ufl.TrialFunction(V)
v = ufl.TestFunction(V)
f = fem.Constant(domain, 1.0)
```

Then add:

- boundary facet identification
- dof location
- `fem.dirichletbc`
- a `LinearProblem` or assembled PETSc solve path

## DOLFINx transient skeleton

Use this structure for time-dependent solves:

```python
t = 0.0
dt = 1.0e-2
u_n = fem.Function(V)
u = fem.Function(V)

while t < T:
    # build residual or linear system with u_n
    # solve for u
    # write output if needed
    u_n.x.array[:] = u.x.array
    t += dt
```

Treat this as the minimum state-carrying pattern. The exact solve path depends on whether the problem is linear, nonlinear, or mixed.

## Usage rules

- use skeletons for structure, not as drop-in physical models
- normalize imports before adding PDE details
- if the PDE is nonlinear, replace the linear `TrialFunction` pattern with a residual-based `Function` pattern
- if the problem is mixed, promote the skeleton to mixed spaces before adding boundary conditions
