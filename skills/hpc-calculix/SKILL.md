---
name: hpc-calculix
description: Build, review, debug, and automate CalculiX finite-element workflows. Use when working with CalculiX `.inp` decks, Abaqus-style keywords, materials, steps, contacts, boundary conditions, static or frequency analyses, or CalculiX solve and post-processing issues.
---

# HPC CalculiX

Treat CalculiX as an input-deck-driven FEM workflow centered on `.inp` keywords.

## Start

1. Read `references/input-deck-manual.md` before creating or editing a `.inp` file.
2. Read `references/keyword-and-step-matrix.md` when mapping materials, sections, loads, and analysis steps.
3. Read `references/mesh-boundary-and-output.md` when working with nodes, elements, sets, boundary conditions, and result output.
4. Read `references/cluster-execution-playbook.md` when staging a CalculiX deck for scheduler-backed cluster execution.
5. Read `references/error-recovery.md` when parsing, solving, or post-processing fails.

## Additional References

Load these on demand:

- `references/time-control-and-amplitudes.md` for step time, amplitude logic, and incremental loading behavior
- `references/result-files-and-postprocessing.md` for `.dat`, `.frd`, and eigenmode artifacts
- `references/thermal-and-coupled-procedures.md` for heat transfer and coupled analysis patterns
- `references/step-load-output-matrix.md` for procedure-to-load-to-output compatibility tables
- `references/element-section-material-matrix.md` for element, section, and material assignment lookup tables
- `references/error-pattern-dictionary.md` for structured parse, singularity, and procedure-mismatch failure signatures
- `references/cluster-execution-playbook.md` for launch style, result-artifact planning, and cluster-side deck execution

## Reusable Templates

Use `assets/templates/` when a concrete `.inp` scaffold is needed, especially:

- `static_minimal.inp`
- `frequency_minimal.inp`
- `thermal_minimal.inp`
- `beam_static.inp`
- `calculix-ccx-slurm.sh`

## Guardrails

- Do not invent Abaqus-style keywords that CalculiX does not support.
- Do not mix node or element set names inconsistently across sections and steps.
- Do not define loads and boundary conditions without checking the active step type.
- Do not skip material and section coherence when the deck fails later in the solve.

## Outputs

Summarize:

- analysis type
- materials and sections
- sets and boundary assumptions
- step sequence
- expected result files
