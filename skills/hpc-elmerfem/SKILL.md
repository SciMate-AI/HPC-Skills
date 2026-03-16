---
name: hpc-elmerfem
description: Build, review, debug, and automate ElmerFEM workflows. Use when working with Elmer `.sif` solver input files, mesh directories, equation and material blocks, multiphysics coupling, boundary conditions, transient controls, or ElmerSolver execution and output issues.
---

# HPC ElmerFEM

Treat ElmerFEM as a solver-input workflow centered on the `.sif` file plus a mesh directory.

## Start

1. Read `references/sif-workflow-manual.md` before creating or editing a `.sif`.
2. Read `references/block-and-equation-matrix.md` when mapping simulation, body, material, equation, solver, and boundary blocks.
3. Read `references/mesh-boundary-and-output.md` when working with mesh directories, body IDs, boundary IDs, and result files.
4. Read `references/cluster-execution-playbook.md` when staging an ElmerFEM workflow for scheduler-backed cluster execution.
5. Read `references/error-recovery.md` when ElmerSolver parsing, coupling, or solve behavior fails.

## Additional References

Load these on demand:

- `references/solver-controls-and-linear-systems.md` for direct versus iterative settings and nonlinear or steady tolerances
- `references/transient-and-timestep-control.md` for transient simulation blocks and timestep policies
- `references/elmergrid-and-mesh-conversion.md` for mesh conversion and ElmerGrid workflows
- `references/simulation-body-solver-matrix.md` for block-responsibility and ID-mapping lookup tables
- `references/physics-output-matrix.md` for physics-to-solver-to-output selection tables
- `references/error-pattern-dictionary.md` for structured parse, ID-mapping, and solver-family failure signatures
- `references/cluster-execution-playbook.md` for mesh-directory staging, launch style, and cluster-side continuation planning

## Reusable Templates

Use `assets/templates/` when a concrete `.sif` scaffold is needed, especially:

- `heat_steady.sif`
- `elasticity_static.sif`
- `heat_transient.sif`
- `stokes_minimal.sif`
- `elmerfem-solver-slurm.sh`

## Guardrails

- Do not invent SIF keys outside documented Elmer syntax.
- Do not mismatch Body, Material, Equation, and Boundary Condition IDs.
- Do not reuse a solver block blindly across unrelated physics.
- Do not treat mesh boundary IDs as self-explanatory; map them explicitly.

## Outputs

Summarize:

- physics family
- mesh directory assumptions
- core solver and equation blocks
- body and boundary mapping
- expected result files
