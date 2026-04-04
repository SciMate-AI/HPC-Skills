---
name: hpc-vasp
description: Build, review, debug, and automate VASP first-principles workflows. Use when working with VASP input sets such as INCAR, POSCAR, KPOINTS, and POTCAR; when choosing SCF, relaxation, static, DOS, or band-structure stages; or when fixing convergence, symmetry, cutoff, and k-point issues. Also covers magnetic calculations, spin-orbit coupling, hybrid functionals, surface slabs, DFT+U, van der Waals, phonons, molecular dynamics, NEB, and defect calculations.
---

# HPC VASP

Treat VASP as a staged workflow built around a coherent four-file input set.

## Start

1. Read `references/input-set-manual.md` before creating or editing a VASP run directory.
2. Read `references/stage-and-parameter-matrix.md` for complete INCAR snippets per stage (relax, static, DOS, bands).
3. Read `references/incar-tag-matrix.md` for concrete parameter value tables (ISMEAR, ALGO, ENCUT, mixing, etc.).
4. Read `references/pseudopotential-kpoints-and-convergence.md` for POTCAR variant selection, k-point density, and convergence testing.
5. Read `references/cluster-execution-playbook.md` when staging a VASP workflow for scheduler-backed cluster execution.
6. Read `references/error-recovery.md` when any VASP error occurs (includes decision tree and diagnostic commands).

## Scenario Recipes

Load the relevant recipe when the task involves:

- `references/magnetic-and-soc-recipes.md` — spin-polarized calculations, MAGMOM setup, antiferromagnetic ordering, spin-orbit coupling, magnetic anisotropy
- `references/hybrid-functional-recipes.md` — HSE06, PBE0, band structure with hybrids, AEXX tuning
- `references/surface-and-slab-recipes.md` — slab construction, selective dynamics, dipole correction, adsorption energy, work function
- `references/dftu-and-advanced-xc.md` — DFT+U for transition metal oxides, van der Waals corrections (DFT-D3, vdW-DF), SCAN/r2SCAN meta-GGA
- `references/phonon-and-md-recipes.md` — phonon finite differences, DFPT, Phonopy interface, ab initio molecular dynamics (NVT/NVE/NPT), elastic constants
- `references/neb-and-transition-state-recipes.md` — NEB setup, climbing image, VTST tools, transition state verification
- `references/defect-calculation-recipes.md` — vacancy/interstitial/substitutional defects, charged defects, finite-size corrections, formation energy
- `references/parallel-and-performance.md` — KPAR, NCORE, LREAL, ALGO tuning, GPU acceleration, benchmarking

## Additional References

Load these on demand:

- `references/poscar-species-and-structure.md` for species ordering, coordinate modes, and cell interpretation
- `references/restarts-spin-and-wavefunction-files.md` for restart logic (ISTART/ICHARG), spin setup, and stage handoff patterns
- `references/dos-and-band-workflows.md` for DOS and band-structure stage sequencing
- `references/workflow-handoff-matrix.md` for stage artifacts and restart-file handoff tables
- `references/error-pattern-dictionary.md` for structured error signatures with real OUTCAR snippets and fix sequences

## Reusable Templates

Use `assets/templates/` when a concrete starting input is needed:

**Standard workflow:**
- `INCAR_relax.txt` — geometry relaxation with inline comments
- `INCAR_static.txt` — static SCF with DOS output
- `INCAR_bands.txt` — band structure (non-SCF)
- `KPOINTS_gamma.txt` — Gamma-only k-points
- `KPOINTS_mp_6x6x6.txt` — Monkhorst-Pack 6x6x6
- `POSCAR_si.txt` — silicon conventional cell
- `vasp-standard-slurm.sh` — SLURM submission script

**Advanced scenarios:**
- `INCAR_magnetic_relax.txt` — spin-polarized relaxation with robust mixing
- `INCAR_hse06.txt` — HSE06 hybrid functional static
- `INCAR_slab_relax.txt` — surface/slab with dipole correction
- `INCAR_dftu.txt` — DFT+U for transition metal oxide
- `INCAR_phonopy_single_point.txt` — Phonopy finite-displacement single-point
- `INCAR_aimd_nvt.txt` — NVT molecular dynamics (Nose-Hoover)
- `INCAR_neb.txt` — NEB transition state search

## Guardrails

- Do not mix POTCAR datasets casually across elements or workflow stages.
- Do not copy INCAR tags from unrelated systems without checking metallic versus insulating behavior.
- Do not run DOS or bands workflows before the geometry and ground-state setup are trustworthy.
- Do not guess VASP tags from Quantum ESPRESSO or other DFT codes.
- Do not use ISIF=3 for surface/slab calculations (vacuum will collapse).
- Do not use ISMEAR=-5 for relaxation (forces are wrong with tetrahedron method).
- Do not use ICHARG=11 for DFT+U or hybrid band structures (use zero-weight k-points method).
- Do not set both NPAR and NCORE simultaneously.

## Outputs

Summarize:

- workflow stage and physics (bulk/surface/defect, magnetic ordering, functional)
- INCAR intent with key parameter values
- KPOINTS strategy and density
- POTCAR variant and species assumptions
- expected key outputs and next stage
- convergence status and any warnings
