# FEniCS Cluster Execution Playbook

## Purpose

Use this reference when a FEniCS or DOLFINx script is moving from local development into scheduled cluster execution.

## Pairing rule

Use this together with `hpc-orchestration`.

- this file owns FEniCS-specific launch, IO, and solver-stack concerns
- `hpc-orchestration` owns scheduler, storage, transfer, and remote-development scaffolds

## Preflight

Before a production submission:

1. confirm whether the script targets classic FEniCS or DOLFINx
2. confirm the Python environment, module stack, or container is explicit
3. confirm imported meshes and sidecar files resolve from the actual run directory
4. run one small representative case with the intended launcher
5. confirm output writers land on writable storage

Do not use a large allocation to discover a missing Python package or mesh file.

## Launch strategy

Portable starting point:

- serial or threaded script: `srun -n 1 python script.py`
- MPI DOLFINx path: `srun -n <ranks> python script.py`
- hybrid layouts only when the PETSc and math-library stack is known to benefit

Keep rank count, `OMP_NUM_THREADS`, and PETSc options aligned. Do not let Python, BLAS, and MPI oversubscribe the same cores.

## Solver-stack checks

High-value checks before scaling out:

- PETSc backend is the one you expect
- mesh partitioning works under MPI
- output format is safe in parallel
- solver tolerances and preconditioners are explicit for large runs

For weak scaling or memory-bound problems, algebra choices often matter more than raw rank count.

## Logs worth watching

High-value checks:

- import and environment failures before the solve starts
- PETSc option or preconditioner errors
- divergence in nonlinear solves
- parallel IO or XDMF write failures
- silent oversubscription leading to poor throughput

## Storage and output

Recommended habits:

- keep meshes and durable outputs on project storage
- use scratch for heavy transient outputs
- avoid excessive per-step field dumps unless the post-processing plan requires them

Large FEM workflows often fail operationally because output cadence and memory growth were not planned.

## Restart and continuation

If the workflow supports continuation:

- keep checkpoint or restart artifacts in a dedicated subdirectory
- document which time or nonlinear state each checkpoint represents
- keep the exact solver and mesh configuration that produced the checkpoint

Do not assume changing the function space or mesh is restart-compatible.

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| batch job fails before solving | wrong environment or missing module | make the Python and PETSc stack explicit in the job script |
| MPI run is slower than serial | oversubscription or poor partitioning | reduce ranks and align thread settings |
| parallel output fails | writer choice or path is not parallel-safe | switch to a safer writer strategy and verify output paths |
| nonlinear solve behaves differently on cluster | backend or option drift | capture PETSc options and solver stack explicitly |
