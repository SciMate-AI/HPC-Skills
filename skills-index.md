# Skills Index

Repository-level catalog for the portable HPC skill collection.

## Canonical Rule

Use `skills/` as the only maintained distribution surface.

- `skills/<name>/` is canonical
- maintained skills should share one shape:
  - `SKILL.md`
  - `agents/openai.yaml`
  - `references/`
  - `assets/templates/` when useful
  - optional `scripts/` for executable shared tooling

## HPC Lifecycle

| Skill | Focus | Entry |
| --- | --- | --- |
| HPC Foundations | foundational HPC concepts, schedulers, Linux, storage, containers, and cluster basics | [skills/hpc-foundations/SKILL.md](skills/hpc-foundations/SKILL.md) |
| HPC MPI | MPI families, launcher semantics, wrapper compilers, PMI or PMIx, binding, scheduler handoff | [skills/hpc-mpi/SKILL.md](skills/hpc-mpi/SKILL.md) |
| HPC Toolchains | compiler families, CMake, ABI hygiene, modules, Spack, reproducible build stacks | [skills/hpc-toolchains/SKILL.md](skills/hpc-toolchains/SKILL.md) |
| HPC Spack | specs, variants, compilers, externals, environments, concretization, binary reuse | [skills/hpc-spack/SKILL.md](skills/hpc-spack/SKILL.md) |
| HPC Orchestration | scheduler submission, queue monitoring, log tracking, lifecycle control | [skills/hpc-orchestration/SKILL.md](skills/hpc-orchestration/SKILL.md) |

## GPU And Acceleration

| Skill | Focus | Entry |
| --- | --- | --- |
| GPU Stack | CUDA, `nvcc`, GPU-aware MPI, rank-to-GPU mapping, Slurm GPU launch, memory and streams | [skills/hpc-gpu-stack/SKILL.md](skills/hpc-gpu-stack/SKILL.md) |

## Meshing And Geometry

| Skill | Focus | Entry |
| --- | --- | --- |
| Gmsh | `.geo`, Python API, OpenCASCADE, physical groups, size fields, export and solver handoff | [skills/hpc-gmsh/SKILL.md](skills/hpc-gmsh/SKILL.md) |

## How To Use

1. Pick the software family.
2. Open the skill's `SKILL.md`.
3. Read only the referenced `references/*.md` files needed for the task.
4. Reuse `assets/templates/` when a concrete scaffold is faster than regenerating from scratch.

## CFD

| Skill | Focus | Entry |
| --- | --- | --- |
| OpenFOAM | open-source CFD cases, dictionaries, turbulence, multiphase, monitoring | [skills/hpc-openfoam/SKILL.md](skills/hpc-openfoam/SKILL.md) |
| SU2 | config-driven CFD, markers, compressible/incompressible setups, convergence control | [skills/hpc-su2/SKILL.md](skills/hpc-su2/SKILL.md) |

## FEM And Multiphysics

| Skill | Focus | Entry |
| --- | --- | --- |
| FEniCS | UFL, DOLFINx, PDE scripts, PETSc, mixed methods | [skills/hpc-fenics/SKILL.md](skills/hpc-fenics/SKILL.md) |
| CalculiX | Abaqus-style `.inp` decks, static/frequency/thermal workflows | [skills/hpc-calculix/SKILL.md](skills/hpc-calculix/SKILL.md) |
| ElmerFEM | `.sif` workflows, mesh-ID mapping, coupled solvers, transient control | [skills/hpc-elmerfem/SKILL.md](skills/hpc-elmerfem/SKILL.md) |

## Linear Algebra And Solver Libraries

| Skill | Focus | Entry |
| --- | --- | --- |
| PETSc | `Vec` or `Mat`, `KSP`, `PC`, `SNES`, `TS`, options database, MPI assembly | [skills/hpc-petsc/SKILL.md](skills/hpc-petsc/SKILL.md) |
| hypre | `IJ` or `Struct` or `SStruct`, `BoomerAMG`, Krylov solvers, PETSc-backed integration | [skills/hpc-hypre/SKILL.md](skills/hpc-hypre/SKILL.md) |
| Trilinos | `Tpetra`, `Belos`, `Ifpack2`, `MueLu`, `Amesos2`, CMake and type-instantiation discipline | [skills/hpc-trilinos/SKILL.md](skills/hpc-trilinos/SKILL.md) |

## Molecular Simulation

| Skill | Focus | Entry |
| --- | --- | --- |
| LAMMPS | MD input decks, force fields, ensembles, chunks, control flow | [skills/hpc-lammps/SKILL.md](skills/hpc-lammps/SKILL.md) |
| GROMACS | biomolecular MD staging, topology building, `.mdp` design, continuation | [skills/hpc-gromacs/SKILL.md](skills/hpc-gromacs/SKILL.md) |

## Electronic Structure

| Skill | Focus | Entry |
| --- | --- | --- |
| Quantum ESPRESSO | `pw.x` workflows, pseudopotentials, k-points, SCF/relax/bands | [skills/hpc-quantum-espresso/SKILL.md](skills/hpc-quantum-espresso/SKILL.md) |
| VASP | INCAR/POSCAR/KPOINTS/POTCAR workflows, relax/static/DOS/bands | [skills/hpc-vasp/SKILL.md](skills/hpc-vasp/SKILL.md) |
| Gaussian | Gaussian input decks, Link 0 directives, route sections, checkpoint and restart workflows | [skills/hpc-gaussian/SKILL.md](skills/hpc-gaussian/SKILL.md) |

## Visualization And Post-processing

| Skill | Focus | Entry |
| --- | --- | --- |
| ParaView | readers, filters, state files, screenshots, `pvpython` or `pvbatch`, remote `pvserver` workflows | [skills/hpc-paraview/SKILL.md](skills/hpc-paraview/SKILL.md) |

## Skill Selection Shortcuts

Use this quick map when the user asks for:

- Open-source CFD dictionaries and patch logic -> `hpc-openfoam`
- SU2 `.cfg` and marker debugging -> `hpc-su2`
- PDE weak forms, UFL, or DOLFINx -> `hpc-fenics`
- PETSc `KSP` or `SNES` or `TS`, options database tuning, or MPI assembly debugging -> `hpc-petsc`
- hypre `BoomerAMG`, `IJ` matrices, or PETSc-backed hypre preconditioning -> `hpc-hypre`
- Trilinos package selection, `Tpetra`, `Belos`, `Ifpack2`, or `MueLu` tuning -> `hpc-trilinos`
- Abaqus-like `.inp` decks -> `hpc-calculix`
- Elmer `.sif` blocks and body or boundary IDs -> `hpc-elmerfem`
- Classical or coarse-grained MD input scripts -> `hpc-lammps`
- Biomolecular MD staging and `.mdp` tuning -> `hpc-gromacs`
- cluster submission, queue monitoring, or runtime log tracking -> `hpc-orchestration`
- cluster transfers, remote development, notebooks, or profiling -> `hpc-orchestration`
- general HPC concepts, schedulers, Linux cluster usage, containers, or storage basics -> `hpc-foundations`
- Open MPI or MPICH or Intel MPI or MVAPICH2 launch behavior, `mpirun` versus `srun`, or `mpicc` wrapper issues -> `hpc-mpi`
- GCC or Clang or oneAPI selection, CMake or `find_package`, ABI or link failures, modules, or Spack environments -> `hpc-toolchains`
- Spack specs or variants or environments or concretization or external packages -> `hpc-spack`
- CUDA or `nvcc` or GPU-aware MPI or `CUDA_VISIBLE_DEVICES` or Slurm GPU mapping -> `hpc-gpu-stack`
- Gmsh `.geo` or Python API or physical groups or transfinite meshing or `.msh` export -> `hpc-gmsh`
- Quantum ESPRESSO `pw.x` inputs -> `hpc-quantum-espresso`
- VASP four-file input sets -> `hpc-vasp`
- Gaussian route sections, checkpoints, or quantum-chemistry restarts -> `hpc-gaussian`
- ParaView state files, `pvbatch`, screenshots, or remote visualization -> `hpc-paraview`

## Template Inventory

High-value templates currently included:

- OpenFOAM: minimal `simpleFoam` and `interFoam` skeletons
- HPC MPI: minimal MPI hello world, compile script, and pure or hybrid Slurm launch templates
- HPC Toolchains: minimal MPI-enabled CMake smoke project, GCC or OpenMPI configure script, build-smoke Slurm script, and Spack environment example
- HPC Spack: minimal environment, compiler and external-package config examples, and install/build workflow templates
- GPU Stack: minimal CUDA vector-add kernel, NVCC build script, and single- or multi-rank GPU Slurm launch templates
- Gmsh: minimal `.geo`, Python OpenCASCADE example, and batch or Slurm meshing scripts
- FEniCS: DOLFINx Poisson and transient diffusion scripts
- PETSc: minimal C and `petsc4py` KSP solve skeletons plus build and Slurm run templates
- hypre: minimal `IJ` plus `PCG` plus `BoomerAMG` solve skeleton plus build and Slurm run templates
- Trilinos: minimal `Tpetra` plus `Belos` plus `Ifpack2` skeleton, `Stratimikos` parameter XML, and build or Slurm run templates
- LAMMPS: LJ and EAM minimal decks
- GROMACS: EM, NVT, NPT, and production `.mdp`
- SU2: steady incompressible, compressible external aero, and unsteady windowed `.cfg`
- Quantum ESPRESSO: SCF, relax, and bands inputs for Si
- VASP: relax, static, bands INCARs plus KPOINTS and POSCAR examples
- Gaussian: single-point and opt-freq `.gjf` inputs plus a Slurm launcher
- CalculiX: static, frequency, thermal, and beam `.inp`
- ElmerFEM: steady heat, transient heat, elasticity, and Stokes `.sif`
- ParaView: `pvpython` screenshot, `pvbatch` extract, and `pvserver` or `pvbatch` Slurm templates
- HPC Orchestration: full cluster operations manual plus Slurm, PBS, and LSF batch skeletons, Slurm arrays, packed single-node subjobs, Apptainer and profiling templates, Jupyter and SSH examples, transfer scaffolds, plus shared execution scripts
