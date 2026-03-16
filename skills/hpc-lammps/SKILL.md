---
name: hpc-lammps
description: Generate, review, debug, and recover LAMMPS molecular dynamics input scripts. Use when working with LAMMPS command ordering, data files, force fields, ensembles, neighbor settings, thermo output, or common runtime errors such as lost atoms and non-numeric pressure.
---

# HPC LAMMPS

Treat LAMMPS input generation as a strict staged workflow.

## Start

1. Read `references/script-structure.md` before editing any `in.*` file.
2. Read `references/units-neighbor-and-timestep.md` when choosing units, timestep scale, and neighbor settings.
3. Read `references/data-forcefield-and-groups.md` when using `read_data`, multiple atom types, or complex assembly workflows.
4. Read `references/forcefield-cookbook.md` when choosing between Lennard-Jones, EAM/MEAM, Tersoff, ReaxFF, or hybrid styles.
5. Read `references/thermostat-and-barostat-matrix.md` when selecting `nve`, `nvt`, `npt`, Langevin, or deforming-box workflows.
6. Read `references/input-deck-templates.md` when assembling a fresh LJ, EAM, or molecule-style input script.
7. Read `references/potentials-and-ensembles.md` when choosing force fields, thermostatting, or barostatting.
8. Read `references/output-and-restarts.md` when designing machine-readable logs, dumps, averaging, or restart behavior.
9. Read `references/cluster-execution-playbook.md` when staging a LAMMPS deck for scheduler-backed cluster execution.
10. Read `references/error-recovery.md` when the log shows instability, missing potentials, or neighbor-list failures.

## Work sequence

1. Fix the unit system first. Everything downstream depends on it.
2. Keep command ordering strict:
   - initialization
   - system definition
   - force fields and neighbor settings
   - minimization, velocity setup, fixes, output, run
3. Decide whether the structure comes from procedural generation or `read_data`. Do not mix both box-building paths.
4. Match `pair_style` and `pair_coeff` syntax to the actual potential family and atom-type mapping.
5. Minimize before aggressive dynamics unless the user explicitly provides a relaxed starting structure.
6. Keep one time-integration fix per atom group unless the combination is explicitly non-overlapping and intended.

## Guardrails

- Do not write `read_data` before `units` and `atom_style`.
- Do not use a timestep copied from another unit system.
- Do not launch NPT on a fragile fresh structure without an equilibration stage.
- Do not ignore neighbor-list settings on hot or highly deforming runs.

## Additional References

Load these on demand:

- `references/minimization-and-box-relax.md` for energy minimization, pressure relaxation, and pre-production setup
- `references/computes-chunks-and-analysis.md` for RDF, MSD, chunk workflows, and averaging outputs
- `references/variables-loops-and-control-flow.md` for script automation, loops, branching, and multi-run control
- `references/units-fix-compute-matrix.md` for unit-system, ensemble-fix, and analysis-command matrices
- `references/cluster-execution-playbook.md` for launch style, output-volume control, and restart handoff on clusters

## Reusable Templates

Use `assets/templates/` when a concrete input-deck scaffold is needed, especially:

- `lj_fluid_minimal.in`
- `eam_metal_minimal.in`
- `lammps-mpi-slurm.sh`

## Outputs

Summarize:

- unit system
- structure source
- force field and atom-type mapping
- ensemble and damping choices
- log-derived failure mode if the script is under repair
