---
name: hpc-quantum-espresso
description: Build, review, debug, and automate Quantum ESPRESSO workflows. Use when working with `pw.x` input files, pseudopotentials, k-point setup, SCF/relax/bands workflows, plane-wave cutoffs, occupations, or Quantum ESPRESSO execution and convergence issues.
---

# HPC Quantum ESPRESSO

Treat Quantum ESPRESSO as a staged first-principles workflow centered on namelist-based input files.

## Start

1. Read `references/pwx-workflow.md` before creating or editing a `pw.x` input.
2. Read `references/input-and-parameter-matrix.md` when mapping namelists, atomic species, pseudopotentials, and k-points.
3. Read `references/scf-relax-bands-and-convergence.md` when choosing workflow stage and convergence strategy.
4. Read `references/cluster-execution-playbook.md` when staging a Quantum ESPRESSO workflow for scheduler-backed cluster execution.
5. Read `references/error-recovery.md` when SCF, relaxation, or input parsing fails.

## Additional References

Load these on demand:

- `references/pseudopotential-kpoints-and-occupations.md` for pseudo selection, k-point modes, and metallic versus insulating occupation logic
- `references/restarts-and-postprocessing.md` for clean restarts, `prefix`/`outdir`, NSCF, DOS, and bands handoff
- `references/cutoff-and-mixing-matrix.md` for `ecutwfc`, `ecutrho`, mixing, and SCF stabilization choices
- `references/cluster-execution-playbook.md` for stage handoff, `prefix` or `outdir` discipline, and cluster launch choices

## Reusable Templates

Use `assets/templates/` when a concrete starting input is needed, especially:

- `scf_si.in`
- `relax_si.in`
- `bands_si.in`
- `qe-pwx-slurm.sh`

## Guardrails

- Do not mix pseudopotentials, cutoffs, and occupations without checking compatibility.
- Do not treat k-point density as an afterthought.
- Do not use a relaxation or bands workflow when the structure and SCF ground state are not ready.
- Do not guess namelist keys from other DFT codes.

## Outputs

Summarize:

- workflow stage such as SCF, relax, or bands
- pseudopotential and species setup
- k-point strategy
- key convergence controls and expected outputs
