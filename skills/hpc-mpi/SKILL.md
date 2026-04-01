---
name: hpc-mpi
description: Build, review, debug, and launch MPI-based applications across Open MPI, MPICH-family, Intel MPI, MVAPICH2, and scheduler-integrated runtimes. Use when working with `mpirun` or `mpiexec` or `srun`, wrapper compilers such as `mpicc`, rank or thread geometry, process binding, PMI or PMIx integration, or MPI build and runtime failures.
---

# HPC MPI

Treat MPI as a three-layer surface: implementation choice, build or wrapper semantics, and launcher behavior inside the target scheduler.

## Start

1. Read `references/mpi-implementation-matrix.md` before choosing or repairing an MPI stack.
2. Read `references/launcher-semantics.md` when deciding between `srun`, `mpirun`, `mpiexec`, Hydra, or a site wrapper.
3. Read `references/wrapper-compilers-and-build.md` when compiling with `mpicc` or `mpicxx` or `mpifort`, linking dependencies, or mixing MPI and non-MPI toolchains.
4. Read `references/rank-thread-binding-matrix.md` when selecting MPI rank counts, OpenMP threads, affinity, or NUMA placement.
5. Read `references/pmi-pmix-and-environment-propagation.md` when PMI or PMIx integration, environment forwarding, or batch-shell drift is in doubt.
6. Read `references/scheduler-integration-playbook.md` when launching under Slurm, PBS, or LSF.
7. Read `references/runtime-debugging-and-observability.md` when ranks hang, crash, oversubscribe, or report inconsistent environment state.
8. Read `references/error-pattern-dictionary.md` when an MPI build or runtime failure needs a fast pattern match.

## Work sequence

1. Identify the active MPI family first:
   - Open MPI
   - MPICH or Hydra-derived stack
   - Intel MPI
   - MVAPICH2
   - site-specific wrapper around one of those families
2. Keep compiler wrappers and runtime launcher from the same stack.
3. Decide whether the scheduler should launch ranks directly or whether the MPI launcher should do it.
4. Make rank count, CPUs per rank, `OMP_NUM_THREADS`, and binding policy mutually consistent.
5. Reproduce failures on the smallest rank count that still shows the issue before scaling back out.

## Guardrails

- Do not mix `mpicc` from one MPI stack with `mpirun` from another.
- Do not assume `mpirun` and `srun` are interchangeable on a managed cluster.
- Do not tune binding or transport variables before confirming the rank geometry is coherent.
- Do not debug collectives or hangs at production scale first when a two-rank or four-rank reproduction is possible.

## Additional References

Load these on demand:

- `references/mpi-implementation-matrix.md` for family selection and compatibility boundaries
- `references/launcher-semantics.md` for launcher-specific expectations and scheduler handoff
- `references/wrapper-compilers-and-build.md` for compiler-wrapper usage and link hygiene
- `references/rank-thread-binding-matrix.md` for affinity and hybrid MPI plus OpenMP choices
- `references/pmi-pmix-and-environment-propagation.md` for scheduler handoff, PMI or PMIx expectations, and batch-shell environment propagation
- `references/scheduler-integration-playbook.md` for Slurm or PBS or LSF integration detail
- `references/runtime-debugging-and-observability.md` for hang triage, rank-local logging, and environment inspection
- `references/error-pattern-dictionary.md` for common MPI failure signatures

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than rebuilding the MPI workflow from scratch, especially:

- `mpi_hello_world.c`
- `mpi_compile_example.sh`
- `mpi_hello_slurm.sh`
- `mpi_hybrid_slurm.sh`

## Outputs

Summarize:

- active MPI family or the ambiguity that still needs to be resolved
- compile and launcher path chosen
- rank or thread or binding geometry
- scheduler integration assumptions
- the exact build or runtime failure class if the workflow is being repaired
