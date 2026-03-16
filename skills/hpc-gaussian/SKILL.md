---
name: hpc-gaussian
description: Build, review, debug, and automate Gaussian quantum chemistry workflows. Use when working with Gaussian input files, Link 0 directives, route sections, charge and multiplicity, basis sets, SCF or optimization or frequency jobs, checkpoint handoff, or Gaussian execution and restart issues.
---

# HPC Gaussian

Treat Gaussian as a staged quantum-chemistry workflow built around a valid input deck and explicit checkpoint policy.

## Start

1. Read `references/workflow-manual.md` before creating or editing a Gaussian input file.
2. Read `references/input-and-link0-matrix.md` when mapping Link 0 directives, route keywords, title, charge, multiplicity, and geometry blocks.
3. Read `references/geometry-charge-spin.md` when the structure, charge, multiplicity, or fragment logic is uncertain.
4. Read `references/method-basis-and-jobtype.md` when choosing the method, basis set, and job type.
5. Read `references/scf-opt-freq-and-solvation.md` when choosing SCF, optimization, frequency, or solvent settings.
6. Read `references/checkpoint-restart-and-artifacts.md` when designing checkpoint, restart, formatted-checkpoint, or cube workflows.
7. Read `references/cluster-execution-playbook.md` when staging a Gaussian workflow for scheduler-backed cluster execution.
8. Read `references/error-recovery.md` when parsing, SCF, optimization, frequency, or restart behavior fails.

## Additional References

Load these on demand:

- `references/error-pattern-dictionary.md` for structured SCF, geometry, and restart failure signatures

## Reusable Templates

Use `assets/templates/` when a concrete starting input is needed, especially:

- `sp_water.gjf`
- `opt_freq_water.gjf`
- `gaussian-g16-slurm.sh`

## Guardrails

- Do not invent Gaussian keywords or Link 0 directives.
- Do not treat charge and multiplicity as cosmetic metadata.
- Do not run restart-sensitive workflows without an explicit checkpoint policy.
- Do not copy route sections from unrelated systems without checking method, basis, and job intent.

## Outputs

Summarize:

- job type
- method and basis selection
- charge and multiplicity
- checkpoint or restart policy
- expected key outputs and next stage
