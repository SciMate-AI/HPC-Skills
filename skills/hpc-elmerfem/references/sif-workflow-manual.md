# ElmerFEM SIF Workflow Manual

## Contents

- Core artifact model
- SIF block structure
- Standard run pipeline

## Core artifact model

Treat an Elmer run as:

- mesh directory
- `.sif` input file
- solver output and result files

The `.sif` is the main declarative contract for the solve.

## SIF block structure

High-value block families include:

- `Header`
- `Simulation`
- `Constants`
- `Body`
- `Material`
- `Equation`
- `Solver`
- `Boundary Condition`
- `Initial Condition`

Keep IDs and references consistent across blocks. That is the main linking surface in Elmer.

## Standard run pipeline

Practical sequence:

1. prepare or convert mesh
2. inspect body and boundary IDs
3. write `.sif`
4. run `ElmerSolver`
5. inspect logs and output files
