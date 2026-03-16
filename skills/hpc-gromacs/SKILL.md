---
name: hpc-gromacs
description: Build, review, debug, and automate GROMACS molecular simulation workflows. Use when working with GROMACS preprocessing, topology and coordinate files, `.mdp` parameters, energy minimization, equilibration, production MD, analysis commands, or GROMACS runtime errors.
---

# HPC GROMACS

Treat GROMACS as a staged workflow from preprocessing to analysis.

## Start

1. Read `references/workflow-manual.md` before building a run pipeline.
2. Read `references/file-and-parameter-matrix.md` when mapping `.mdp`, topology, structure, and index responsibilities.
3. Read `references/ensembles-and-analysis.md` when choosing minimization, NVT, NPT, production, and standard analysis commands.
4. Read `references/cluster-execution-playbook.md` when staging a GROMACS workflow for scheduler-backed cluster execution.
5. Read `references/error-recovery.md` when `grompp`, `mdrun`, or analysis commands fail.

## Additional References

Load these on demand:

- `references/topology-and-system-building.md` for `pdb2gmx`, box setup, solvation, and ion insertion workflows
- `references/restarts-and-output-control.md` for checkpointing, append behavior, and long-job continuation
- `references/mdp-coupling-and-constraints-matrix.md` for thermostat, barostat, constraints, and timestep compatibility
- `references/cluster-execution-playbook.md` for `grompp` to `mdrun` staging, continuation, and cluster launch choices

## Reusable Templates

Use `assets/templates/` when a concrete starting scaffold is needed, especially:

- `em.mdp`
- `nvt.mdp`
- `npt.mdp`
- `md_prod.mdp`
- `gromacs-mdrun-slurm.sh`

## Guardrails

- Do not skip `grompp` validation and jump straight into `mdrun`.
- Do not mix force fields, water models, and topology assumptions casually.
- Do not copy `.mdp` cutoffs, timesteps, or coupling settings without checking the intended force field and ensemble.
- Do not treat warnings from `grompp` as harmless by default.

## Outputs

Summarize:

- input structure and topology sources
- `.mdp` stage and ensemble
- generated run artifact names such as `.tpr`
- analysis outputs requested or still needed
