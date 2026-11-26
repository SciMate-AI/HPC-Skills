# scimate

<!-- yarkr:badges:start -->
[![Indexed on Yarkr](https://api.yarkr.com/functions/v1/api/api/v1/badges/repos/SciMate-AI/HPC-Skills/version.svg)](https://yarkr.com/arks/scimate-ai/hpc-skills)
<!-- yarkr:badges:end -->

Portable agent skills for High Performance Computing workflows across OpenFOAM, SU2, LS-DYNA, FEniCS, CalculiX, ElmerFEM, PETSc, hypre, Trilinos, LAMMPS, GROMACS, Quantum ESPRESSO, VASP, Gaussian, ParaView, and Gmsh, plus MPI, GPU, Spack, reproducible toolchains, and cluster orchestration.

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

<!-- yarkr:install:start -->
## Install with Yarkr

This repo is indexed on [Yarkr](https://yarkr.com/arks/scimate-ai/hpc-skills) as the ark [scimate-ai/hpc-skills](https://yarkr.com/arks/scimate-ai/hpc-skills), so its skills install into Claude Code, Codex, Cursor and other agent harnesses with one command.

### CLI

Install the whole ark, which Yarkr keeps equal to this repo:

```bash
npx yarkr-cli sync scimate-ai/hpc-skills
```

Or add individual skills:

```bash
npx yarkr-cli add skill:scimate-ai/hpc-skills/hpc-calculix
npx yarkr-cli add skill:scimate-ai/hpc-skills/hpc-elmerfem
npx yarkr-cli add skill:scimate-ai/hpc-skills/hpc-fenics
```

No Node.js? `curl -fsSL https://yarkr.com/install.sh | sh` (macOS, Linux) or `irm https://yarkr.com/install.ps1 | iex` (Windows PowerShell) installs `yarkr` as a standalone binary; then type `yarkr` in place of `npx yarkr-cli`.

### MCP

Connect your agent to the ark over MCP:

```bash
npx yarkr-cli mcp add scimate-ai/hpc-skills
```

Or point any MCP client at `https://api.yarkr.com/functions/v1/api/mcp/o/scimate-ai/hpc-skills`.
<!-- yarkr:install:end -->

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
- `hpc-ls-dyna`
- `hpc-quantum-espresso`
- `hpc-vasp`
- `hpc-gaussian`
- `hpc-calculix`
- `hpc-elmerfem`
- `hpc-paraview`
- `hpc-orchestration`

## New skill spotlight

- `hpc-ls-dyna` adds a production-grade LS-DYNA skill with progressive references for explicit and implicit structural workflows, contact and preload strategy, thermal and welding workflows, SPH, ALE/S-ALE, ICFD, EM, NVH, and source-first advanced branches such as DEM, CESE, IGA, and EFG.
- The skill also includes starter decks plus minimal project skeletons under `skills/hpc-ls-dyna/assets/templates/` and `skills/hpc-ls-dyna/assets/templates/examples/`, so users can start from either a single-file scaffold or a multi-file include-tree layout.

See [skills-index.md](skills-index.md) for category-based navigation, template inventory, and skill selection guidance.

## Lifecycle Coverage

Repository-level scheduler, monitoring, transfer, remote-development, profiling, and workflow-lifecycle support now lives in [skills/hpc-orchestration/SKILL.md](skills/hpc-orchestration/SKILL.md), so cluster operations are part of the same canonical `skills/` surface as solver-specific packages.
