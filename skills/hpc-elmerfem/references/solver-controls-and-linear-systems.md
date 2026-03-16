# ElmerFEM Solver Controls And Linear Systems

## Contents

- steady and nonlinear tolerances
- direct versus iterative logic
- representative solver keys

## Steady and nonlinear tolerances

The Elmer manuals and examples use solver blocks to control:

- steady-state convergence tolerance
- nonlinear-system convergence tolerance
- nonlinear iteration limits

Treat these as solver-specific controls, not global magic numbers.

## Direct versus iterative logic

Representative Elmer solver settings include:

- `Linear System Solver = Direct`
- `Linear System Solver = Iterative`
- direct-method and iterative-method choices
- convergence tolerance and preconditioning controls

Use direct methods for robust early debugging on moderate problems, then move to iterative methods when scale and sparsity require it.

## Representative solver keys

Common high-value keys in examples and manuals:

- `Exec Solver`
- `Variable`
- `Procedure`
- `Linear System Solver`
- `Linear System Iterative Method`
- `Linear System Direct Method`
- `Linear System Convergence Tolerance`

If the solver block is failing, inspect method-family consistency before tuning all tolerances.
