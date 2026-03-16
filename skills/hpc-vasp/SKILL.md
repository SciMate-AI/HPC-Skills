---
name: hpc-vasp
description: Build, review, debug, and automate VASP first-principles workflows. Use when working with VASP input sets such as INCAR, POSCAR, KPOINTS, and POTCAR; when choosing SCF, relaxation, static, DOS, or band-structure stages; or when fixing convergence, symmetry, cutoff, and k-point issues.
---

# HPC VASP

Treat VASP as a staged workflow built around a coherent four-file input set.

## Start

1. Read `references/input-set-manual.md` before creating or editing a VASP run directory.
2. Read `references/stage-and-parameter-matrix.md` when mapping SCF, relaxation, static, DOS, and band workflows to INCAR and KPOINTS choices.
3. Read `references/pseudopotential-kpoints-and-convergence.md` when choosing POTCAR, k-point density, smearing, and electronic controls.
4. Read `references/cluster-execution-playbook.md` when staging a VASP workflow for scheduler-backed cluster execution.
5. Read `references/error-recovery.md` when VASP parsing, SCF, ionic relaxation, or post-processing setup fails.

## Additional References

Load these on demand:

- `references/poscar-species-and-structure.md` for species ordering, coordinate modes, and cell interpretation
- `references/restarts-spin-and-wavefunction-files.md` for restart logic, spin setup, and charge or wavefunction handoff
- `references/dos-and-band-workflows.md` for static, DOS, and band-structure stage sequencing
- `references/incar-tag-matrix.md` for stage-to-tag and electronic-class-to-smearing tables
- `references/workflow-handoff-matrix.md` for stage artifacts and restart-file handoff tables
- `references/error-pattern-dictionary.md` for structured SCF, ionic, and handoff failure signatures
- `references/cluster-execution-playbook.md` for stage handoff, resource-shape discipline, and restart policy on clusters

## Reusable Templates

Use `assets/templates/` when a concrete starting input is needed, especially:

- `INCAR_relax`
- `INCAR_static`
- `KPOINTS_gamma`
- `INCAR_bands`
- `KPOINTS_mp_6x6x6`
- `POSCAR_si`
- `vasp-standard-slurm.sh`

## Guardrails

- Do not mix POTCAR datasets casually across elements or workflow stages.
- Do not copy INCAR tags from unrelated systems without checking metallic versus insulating behavior.
- Do not run DOS or bands workflows before the geometry and ground-state setup are trustworthy.
- Do not guess VASP tags from Quantum ESPRESSO or other DFT codes.

## Outputs

Summarize:

- workflow stage
- INCAR intent
- KPOINTS strategy
- POTCAR and species assumptions
- expected key outputs and next stage
