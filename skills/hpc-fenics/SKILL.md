---
name: hpc-fenics
description: Build, review, and debug FEniCS or DOLFINx PDE scripts for finite-element workflows. Use when translating PDEs into UFL, selecting function spaces, applying boundary conditions, choosing between classic FEniCS and DOLFINx, or fixing FEM runtime errors.
---

# HPC FEniCS

Treat FEniCS as a family with two main stacks: classic FEniCS and DOLFINx.

## Start

1. Read `references/runtime-selection.md` first.
2. Read `references/dolfinx-boundary-workflow.md` when targeting DOLFINx boundary conditions.
3. Read `references/ufl-and-solver-patterns.md` when translating PDEs, choosing spaces, or building forms.
4. Read `references/pde-template-cookbook.md` when mapping common PDE classes to known formulation patterns.
5. Read `references/time-dependent-and-nonlinear-patterns.md` when building transient or nonlinear solvers.
6. Read `references/implementation-skeletons.md` when you need a concrete script shape for classic FEniCS or DOLFINx.
7. Read `references/petsc-solver-playbook.md` when choosing linear, nonlinear, or block solver settings.
8. Read `references/mixed-problems-and-output.md` when working with mixed spaces, XDMF, or post-processing.
9. Read `references/cluster-execution-playbook.md` when staging a FEniCS or DOLFINx script for scheduler-backed cluster execution.
10. Read `references/boundary-io-and-errors.md` when repairing runtime failures or resolving IO issues.

## Work sequence

1. Choose one stack and stay consistent:
   - classic FEniCS: `fenics` or `dolfin`
   - modern stack: `dolfinx`
2. Translate the PDE into the correct weak form before writing code.
3. Match unknown type and space:
   - scalar field -> scalar space
   - vector field -> vector space
   - mixed formulation -> mixed space with explicit subspace handling
4. For linear problems, use `TrialFunction` and `TestFunction`.
5. For nonlinear problems, use a `Function` for the unknown and solve a residual form.
6. Write outputs in a format the expected post-processor can open, usually XDMF for mesh-coupled fields.

## Guardrails

- Do not mix classic FEniCS imports with DOLFINx APIs in one script.
- Do not use `TrialFunction` for a nonlinear unknown.
- Do not guess a boundary condition if the PDE is under-constrained; say what is missing.
- Do not ignore shape and rank mismatches in UFL expressions.

## Additional References

Load these on demand:

- `references/gmsh-meshtags-and-refinement.md` for imported meshes, physical groups, markers, and refinement transfer
- `references/io-visualization-and-writers.md` for XDMF, VTK, VTX, and visualization-safe output
- `references/parallel-and-mpi-caveats.md` for ownership, boundary marking, and parallel consistency
- `references/space-boundary-output-matrix.md` for function-space, boundary-condition, and writer-selection matrices
- `references/cluster-execution-playbook.md` for MPI launch, environment pinning, and cluster-side IO planning

## Reusable Templates

Use `assets/templates/` when a concrete script scaffold is needed, especially:

- `poisson_dolfinx.py`
- `transient_diffusion_dolfinx.py`
- `fenics-dolfinx-slurm.sh`

## Outputs

Report:

- chosen stack and version family if known
- PDE form and space selection
- boundary conditions applied
- expected output files
- the exact failure class if the script is being repaired
