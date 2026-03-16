---
name: hpc-su2
description: Build, review, debug, and automate SU2 CFD workflows. Use when working with SU2 configuration files, mesh and marker definitions, compressible or incompressible solver selection, convergence monitoring, multizone workflows, or SU2 execution and post-processing commands.
---

# HPC SU2

Treat SU2 as a configuration-driven CFD stack centered on the `.cfg` file.

## Start

1. Read `references/config-and-workflow.md` before creating or editing a SU2 case.
2. Read `references/marker-and-boundary-matrix.md` when mapping mesh markers to physical boundaries.
3. Read `references/convergence-and-execution.md` when choosing solver settings, execution commands, and convergence controls.
4. Read `references/cluster-execution-playbook.md` when staging a SU2 case for scheduler-backed cluster execution.
5. Read `references/error-recovery.md` when the config, mesh import, or run fails.

## Additional References

Load these on demand:

- `references/solver-and-physics-matrix.md` for solver-family and physics option selection
- `references/output-restart-and-history.md` for `OUTPUT_FILES`, history fields, and restart policy
- `references/time-domain-and-multizone.md` for transient, windowed convergence, and multizone workflows
- `references/cluster-execution-playbook.md` for launch style, restart control, and cluster-side convergence monitoring

## Reusable Templates

Use `assets/templates/` when a concrete config skeleton is needed, especially:

- `incompressible_steady.cfg`
- `compressible_external_aero.cfg`
- `unsteady_windowed.cfg`
- `su2-cfd-slurm.sh`

## Guardrails

- Do not invent config keywords outside documented SU2 options.
- Do not mismatch mesh marker names and config marker sections.
- Do not assume compressible and incompressible setups share the same variable conventions.
- Do not ignore convergence history and residual trends during solver tuning.

## Outputs

Report:

- solver family
- mesh and marker assumptions
- key config sections touched
- convergence and output files expected
