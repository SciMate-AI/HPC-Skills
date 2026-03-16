---
name: hpc-openfoam
description: Generate, review, debug, and recover OpenFOAM case files for CFD workflows. Use when working with OpenFOAM dictionaries, case structure, turbulence fields, boundary conditions, decomposition, numerics, or OpenFOAM runtime errors.
---

# HPC OpenFOAM

Follow a progressive loading workflow.

## Start

1. Read `references/case-setup.md` before creating or editing any OpenFOAM case.
2. Read `references/solver-selection.md` when selecting a solver family or pressure convention.
3. Read `references/boundary-condition-playbook.md` when mapping physical boundaries to field files.
4. Read `references/turbulence-bc-recipes.md` when selecting turbulence models, wall treatment, or near-wall fields.
5. Read `references/turbulence-and-numerics.md` when choosing schemes, algorithm controls, turbulence models, or decomposition.
6. Read `references/case-recipes.md` when assembling a canonical internal-flow, external-aero, or free-surface case.
7. Read `references/function-object-recipes.md` when instrumenting a case with forces, probes, or solver diagnostics.
8. Read `references/validation-parallel-and-observability.md` when validating, instrumenting, or post-processing a case.
9. Read `references/cluster-execution-playbook.md` when staging an OpenFOAM case for scheduler-backed cluster execution.
10. Read `references/error-recovery.md` when a log contains crashes, divergence, or bounded-field warnings.

## Work sequence

1. Classify the case first: steady or transient, incompressible or compressible, single-phase or multiphase, laminar or turbulent.
2. Generate the minimum consistent file set across `0/`, `constant/`, and `system/`. Do not edit one layer in isolation if it changes the required fields elsewhere.
3. Match solver family and fields:
   - `simpleFoam`: steady incompressible RANS; expect `U`, `p`, and turbulence fields if `RAS`.
   - `pimpleFoam`: transient incompressible; review timestep control and outer correctors.
   - `interFoam`: multiphase; control both `maxCo` and `maxAlphaCo`.
4. Validate mesh and numerics before a long run:
   - run `blockMesh` or the mesh generator
   - run `checkMesh`
   - refuse to keep orthogonal-only schemes on poor-quality meshes
5. Keep parallel settings aligned:
   - make `numberOfSubdomains` match the intended MPI rank count
   - prefer `scotch` for complex geometries unless the user requests a manual layout

## Guardrails

- Do not invent dictionary keys, patch types, or solver names.
- Do not use turbulence fields that do not match the chosen model family.
- Do not keep aggressive second-order convection schemes during first-pass stabilization on a fragile case.
- Do not treat `checkMesh` warnings as optional if the log is already diverging.

## Additional References

Load these on demand:

- `references/mesh-and-blockmeshdict-manual.md` for mesh generation, vertex ordering, and mesh-quality workflow
- `references/heat-transfer-and-compressible-cases.md` for thermophysical, buoyant, and compressible setups
- `references/fvsolution-and-residual-control.md` for algorithm loops, solver blocks, and case termination logic
- `references/field-and-dictionary-matrix.md` for solver-to-field and file-to-parameter matrices
- `references/cluster-execution-playbook.md` for decomposition, solver launch, reconstruction, and restart sequencing on clusters

## Reusable Templates

Use `assets/templates/` when a concrete case skeleton is needed, especially:

- `simplefoam-minimal/` for a minimal steady incompressible case
- `interfoam-minimal/` for a minimal two-phase transient case
- `openfoam-parallel-slurm.sh` for a minimal scheduled parallel run scaffold

## Outputs

Produce a short case summary that states:

- solver and physics family
- required fields and dictionaries touched
- validation commands run or still needed
- stability risks and the next recovery step if the case is failing
