---
name: hpc-gpu-stack
description: Build, review, debug, and launch CUDA- and GPU-accelerated HPC workflows. Use when working with `nvcc`, host-compiler compatibility, CUDA-aware MPI, rank-to-GPU mapping, `CUDA_VISIBLE_DEVICES`, Slurm GPU scheduling, GPU memory or stream behavior, or CUDA build and runtime failures.
---

# HPC GPU Stack

Treat GPU execution as one coherent stack: CUDA toolchain, host compiler, launcher, scheduler mapping, and device visibility must agree before kernel tuning matters.

## Start

1. Read `references/cuda-and-host-compiler-matrix.md` before choosing `nvcc`, host compiler, or a CUDA build baseline.
2. Read `references/gpu-aware-mpi-and-rank-mapping.md` when the workflow spans MPI ranks, one-rank-per-GPU layouts, or CUDA-aware MPI.
3. Read `references/device-visibility-and-scheduler-integration.md` when Slurm, `CUDA_VISIBLE_DEVICES`, MIG, or scheduler-provided GPU allocation is involved.
4. Read `references/memory-streams-and-overlap-playbook.md` when debugging device memory pressure, pinned-memory transfers, streams, or overlap assumptions.
5. Read `references/build-and-launch-workflow.md` when turning a CUDA code path into a reproducible compile-and-run workflow.
6. Read `references/runtime-debugging-and-profiling.md` when kernels fail at runtime, ranks see the wrong device, or performance is unexpectedly poor.
7. Read `references/error-recovery.md` when configure, compile, launch, or runtime CUDA behavior fails.
8. Read `references/error-pattern-dictionary.md` when a GPU failure needs a fast pattern match.

## Work sequence

1. Confirm the execution model first:
   - single GPU
   - one MPI rank per GPU
   - hybrid MPI plus threads with explicit rank-to-GPU placement
2. Keep CUDA toolkit, host compiler, and MPI stack mutually compatible.
3. Let the scheduler expose the intended GPU allocation before forcing manual device selection.
4. Get a minimal kernel and launch baseline working before tuning streams, overlap, or transport variables.
5. Reproduce failures on one node and the smallest GPU count that still shows the issue before scaling out.

## Guardrails

- Do not assume `nvcc` accepts any host compiler visible in `PATH`.
- Do not mix rank-to-GPU mapping logic from Open MPI, MPICH-family, and Slurm without checking which environment variables are actually set.
- Do not tune streams or overlap to compensate for a broken device-mapping or memory-capacity issue.
- Do not debug multi-node GPU failures before a single-node baseline is trustworthy.

## Additional References

Load these on demand:

- `references/cuda-and-host-compiler-matrix.md` for compiler-compatibility and build-baseline decisions
- `references/gpu-aware-mpi-and-rank-mapping.md` for CUDA-aware MPI and rank placement rules
- `references/device-visibility-and-scheduler-integration.md` for scheduler-exposed GPU visibility and Slurm integration
- `references/memory-streams-and-overlap-playbook.md` for memory hierarchy, streams, and transfer overlap
- `references/build-and-launch-workflow.md` for reproducible build and launch sequencing
- `references/runtime-debugging-and-profiling.md` for runtime inspection and performance triage
- `references/error-pattern-dictionary.md` for common GPU failure signatures

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than rebuilding the GPU workflow from scratch, especially:

- `cuda_vector_add_minimal.cu`
- `nvcc_build_example.sh`
- `cuda_single_gpu_slurm.sh`
- `cuda_mpi_gpu_slurm.sh`

## Outputs

Summarize:

- CUDA toolkit and host-compiler path chosen
- rank-to-GPU mapping or single-GPU launch path
- scheduler or visibility assumptions
- memory and stream model if relevant
- the exact build or runtime failure class if the workflow is being repaired
