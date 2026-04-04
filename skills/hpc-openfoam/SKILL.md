---
name: hpc-openfoam
description: Generate, review, debug, and recover OpenFOAM case files for CFD workflows. Use when working with OpenFOAM dictionaries, case structure, turbulence fields, boundary conditions, decomposition, numerics, or OpenFOAM runtime errors. Also covers RANS/LES turbulence setup, wall functions, y+ targeting, conjugate heat transfer, compressible flows, VOF multiphase, mesh quality, and scheme tuning.
---

# HPC OpenFOAM

Follow a progressive loading workflow.

## Start

1. Read `references/case-setup.md` before creating or editing any OpenFOAM case.
2. Read `references/solver-selection.md` when selecting a solver family or pressure convention.
3. Read `references/boundary-condition-playbook.md` for concrete BC syntax (fixedValue, inletOutlet, wall functions, etc.).
4. Read `references/turbulence-bc-recipes.md` for turbulence model setup, inlet value estimation, and wall function selection with y+ guidance.
5. Read `references/numerics-and-schemes-guide.md` for fvSchemes and fvSolution tuning with scheme selection tables.
6. Read `references/case-recipes.md` for complete case configurations (internal flow, external aero, VOF, PIMPLE, buoyant).
7. Read `references/function-object-recipes.md` for probes, forces, yPlus monitoring.
8. Read `references/validation-parallel-and-observability.md` for validation, post-processing, and parallel execution.
9. Read `references/cluster-execution-playbook.md` for scheduler-backed cluster execution.
10. Read `references/error-recovery.md` for diagnostic commands, decision tree, and fix sequences.

## Scenario Recipes

Load the relevant recipe when the task involves:

- `references/numerics-and-schemes-guide.md` — fvSchemes convection/gradient/time schemes, fvSolution solver settings, relaxation factors, SIMPLE/PISO/PIMPLE algorithm controls, progressive scheme upgrade strategy
- `references/heat-transfer-and-compressible-cases.md` — thermophysicalProperties (Boussinesq, ideal gas, Sutherland), buoyant solvers, conjugate heat transfer (chtMultiRegionFoam), solid properties, fluid-solid coupling BCs
- `references/multiphase-vof-recipes.md` — interFoam setup, alpha transport, MULES settings, maxAlphaCo, phase initialization (setFields), VOF boundary conditions
- `references/mesh-quality-and-generation-guide.md` — checkMesh thresholds and interpretation, blockMesh grading, snappyHexMesh workflow, y+ targeted layer meshing

## Work Sequence

1. Classify the case first: steady or transient, incompressible or compressible, single-phase or multiphase, laminar or turbulent.
2. Generate the minimum consistent file set across `0/`, `constant/`, and `system/`. Do not edit one layer in isolation if it changes the required fields elsewhere.
3. Match solver family and fields:
   - `simpleFoam` or `foamRun -solver incompressibleFluid`: steady incompressible; expect `U`, `p`, and turbulence fields if `RAS`.
   - `pimpleFoam` or `foamRun -solver incompressibleFluid` with transient/PIMPLE settings: transient incompressible; review timestep control and outer correctors.
   - `interFoam` or `foamRun -solver incompressibleVoF`: multiphase; control both `maxCo` and `maxAlphaCo`.
   - `buoyantSimpleFoam` / `buoyantPimpleFoam`: heat transfer; add `T`, `p_rgh`, `alphat`, `thermophysicalProperties`, `g`.
   - `chtMultiRegionFoam`: conjugate heat transfer; multi-region setup with fluid and solid.
4. Validate mesh and numerics before a long run:
   - run `blockMesh` or the mesh generator
   - run `checkMesh` — non-orthogonality > 70° needs correctors, > 85° needs remeshing
   - start with conservative schemes (upwind), upgrade to linearUpwind after stability
5. Keep parallel settings aligned:
   - make `numberOfSubdomains` match the intended MPI rank count
   - prefer `scotch` for complex geometries unless the user requests a manual layout
6. Resolve executable compatibility before launch:
   - if `simpleFoam`/`pimpleFoam`/`interFoam` exists, it is valid to run directly
   - otherwise prefer `foamRun -solver <moduleName>` and verify the module loads

## Additional References

Load these on demand:

- `references/mesh-and-blockmeshdict-manual.md` for mesh generation, vertex ordering, and mesh-quality workflow
- `references/turbulence-and-numerics.md` for turbulence model matching and decomposition choices
- `references/fvsolution-and-residual-control.md` for algorithm loops, solver blocks, and case termination logic
- `references/field-and-dictionary-matrix.md` for solver-to-field and file-to-parameter matrices

## Guardrails

- Do not invent dictionary keys, patch types, or solver names.
- Do not use turbulence fields that do not match the chosen model family.
- Do not keep aggressive second-order convection schemes during first-pass stabilization on a fragile case.
- Do not treat `checkMesh` warnings as optional if the log is already diverging.
- Do not use `p` when the solver expects `p_rgh` (buoyant/VOF), or vice versa.
- Do not use `ISMEAR=-5` equivalent (tetrahedron) — this is a VASP concept, not OpenFOAM.
- Do not use `linear` (central differencing) for alpha convection in VOF — it is unbounded.
- Do not set relaxation factors to 1.0 in steady-state SIMPLE without SIMPLEC (`consistent yes`).

## Reusable Templates

Use `assets/templates/` when a concrete case skeleton is needed:

- `simplefoam-minimal/` — minimal steady incompressible case with inline comments explaining scheme and solver choices, plus turbulence upgrade instructions
- `interfoam-minimal/` — multiphase checklist placeholder (not a self-contained runnable case)
- `openfoam-parallel-slurm.sh` — minimal scheduled parallel run scaffold

## Outputs

Produce a short case summary that states:

- solver and physics family
- required fields and dictionaries touched
- turbulence model, wall treatment, and estimated inlet turbulence values
- validation commands run or still needed
- stability risks and the next recovery step if the case is failing
