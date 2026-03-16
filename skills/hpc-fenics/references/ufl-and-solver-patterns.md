# FEniCS UFL And Solver Patterns

## Contents

- Space selection
- Linear problem pattern
- Nonlinear problem pattern
- Mixed and vector formulations

## Space selection

Choose the function space from the mathematical unknown:

- scalar unknown such as temperature or pressure -> scalar Lagrange space
- vector unknown such as displacement or velocity -> vector space
- saddle-point or coupled systems -> mixed space

Typical constructors:

- classic FEniCS scalar space: `FunctionSpace(mesh, "P", 1)`
- classic FEniCS vector space: `VectorFunctionSpace(mesh, "P", 1)`
- DOLFINx scalar space: `fem.functionspace(domain, ("Lagrange", 1))`

If the PDE is mixed, keep each subfield explicit during boundary-condition and output handling.

## Linear problem pattern

Use this structure for linear PDEs:

```python
u = TrialFunction(V)
v = TestFunction(V)
a = ...
L = ...
u_sol = Function(V)
solve(a == L, u_sol, bcs)
```

This pattern is appropriate when the weak form is affine in the unknown.

## Nonlinear problem pattern

Use this structure for nonlinear PDEs:

```python
u = Function(V)
v = TestFunction(V)
F = ...
solve(F == 0, u, bcs)
```

If the weak form contains nonlinear dependence on the unknown, do not define that unknown as a `TrialFunction`.

## Mixed and vector formulations

Common failure sources:

- using scalar test functions against vector-valued gradients
- applying `dot` where `inner` is the rank-safe operator
- forgetting to split or access subspaces in a mixed formulation

Debug rank and shape deliberately:

- inspect the physical unknown type
- inspect the chosen space
- inspect whether the form returns a scalar integrand on each measure
