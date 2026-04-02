# scimate

Portable agent skills for High Performance Computing workflows across OpenFOAM, SU2, FEniCS, CalculiX, ElmerFEM, PETSc, hypre, Trilinos, LAMMPS, GROMACS, Quantum ESPRESSO, VASP, Gaussian, ParaView, and Gmsh, plus MPI, GPU, Spack, reproducible toolchains, and cluster orchestration.

## Repository

- GitHub: <https://github.com/SciMate-AI/HPC-Skills>

## Canonical layout

- `skills/` is the portable distribution surface.
- Each skill lives in `skills/<skill-name>/`.
- Each skill keeps trigger metadata in `SKILL.md` and detailed knowledge in `references/`.
- `agents/openai.yaml` is included where it helps Codex-style UIs, but the skill content stays tool-neutral.
- `skills-index.md` is the repository-level catalog and navigation entry point.

Canonical maintained skill shape:

- `SKILL.md`
- `agents/openai.yaml`
- `references/`
- `assets/templates/` when a reusable scaffold is worth keeping
- optional `scripts/` when deterministic shared tooling belongs inside the skill

## Compatibility target

This repository is structured so the same skill folders can be reused by:

- Codex and other AGENTS-aware tools that read `SKILL.md`
- Claude Code plugin-style or imported skill collections that expect `skills/<name>/SKILL.md`
- Other CLI agents that can load a skill folder and progressively read references

## Install patterns

Use the normalized folders in `skills/`.

- Codex-style install: copy or sync `skills/<skill-name>/` into `$HOME/.codex/skills/`
- Claude Code personal or project install: copy or sync `skills/<skill-name>/` into `$HOME/.claude/skills/` or `.claude/skills/`
- Claude Code plugin-style install: keep the repository layout and expose `skills/<skill-name>/` from the plugin

## Current skills

- `hpc-openfoam`
- `hpc-foundations`
- `hpc-mpi`
- `hpc-toolchains`
- `hpc-spack`
- `hpc-gpu-stack`
- `hpc-gmsh`
- `hpc-fenics`
- `hpc-petsc`
- `hpc-hypre`
- `hpc-trilinos`
- `hpc-lammps`
- `hpc-gromacs`
- `hpc-su2`
- `hpc-quantum-espresso`
- `hpc-vasp`
- `hpc-gaussian`
- `hpc-calculix`
- `hpc-elmerfem`
- `hpc-paraview`
- `hpc-orchestration`

See [skills-index.md](skills-index.md) for category-based navigation, template inventory, and skill selection guidance.

## Lifecycle Coverage

Repository-level scheduler, monitoring, transfer, remote-development, profiling, and workflow-lifecycle support now lives in [skills/hpc-orchestration/SKILL.md](skills/hpc-orchestration/SKILL.md), so cluster operations are part of the same canonical `skills/` surface as solver-specific packages.
