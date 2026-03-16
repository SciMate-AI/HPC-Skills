---
name: hpc-orchestration
description: Coordinate end-to-end HPC execution workflows across scheduler submission, job monitoring, log tracking, self-healing, and post-processing handoff. Use when a task spans Slurm, PBS, LSF, MPI sizing, queue operations, cluster-safe execution, or multi-stage HPC workflow orchestration.
---

# HPC Orchestration

Use this skill as the repository-level execution layer above solver-specific HPC skills.

## Start

1. Read `references/cluster-operations-manual.md` first for any end-to-end cluster workflow.
2. Read `references/lifecycle-manual.md` when coordinating solver skills with orchestration stages.
3. Read `references/scheduler-and-parallelism.md` when choosing scheduler directives or MPI sizing.
4. Read `references/slurm-launch-patterns.md` when the main decision is how to launch work inside a Slurm allocation.
5. Read `references/environment-and-storage-hygiene.md` when environment modules, scratch policy, or filesystem behavior may decide workflow reliability.
6. Read `references/data-transfer-and-staging.md` when files must be synchronized, staged, archived, or verified.
7. Read `references/software-build-and-reproducibility.md` when compilation, package stacks, or rebuildability are in scope.
8. Read `references/interactive-debugging-and-profiling.md` when the task needs live diagnosis, scaling studies, or profiler evidence.
9. Read `references/remote-development-and-notebooks.md` when VS Code Remote SSH, Jupyter, or port forwarding is involved.
10. Read `references/container-workflows.md` when Apptainer or Singularity-style execution is in scope.
11. Read `references/public-protocol.md` when aligning solver skills with the repository lifecycle contract.
12. Read `references/error-pattern-dictionary.md` when scheduler, monitoring, or log-tracking failures occur.

## Additional References

Load these on demand:

- `references/tools-and-scripts.md` for shared execution tool roles
- `references/ecosystem-roadmap.md` for repository-wide coverage goals
- `references/legacy-template.md` when adapting an older solver skill draft into the current format

## Reusable Templates

Use `assets/templates/` when a concrete scheduler scaffold is needed:

- `slurm-basic.sh`
- `slurm-array.sh`
- `slurm-packed-single-node.sh`
- `slurm-apptainer.sh`
- `slurm-perf-report.sh`
- `pbs-basic.sh`
- `lsf-basic.sh`
- `rsync-stage-in.sh`
- `jupyter-lab-compute.sh`
- `ssh-config-compute-proxy.example`

## Shared Scripts

Use `scripts/` for deterministic orchestration tasks:

- `hpc_job_submitter.py`
- `hpc_job_monitor.py`
- `hpc_log_tracker.py`
- `hpc_slurm_deploy.py`

## Guardrails

- Do not run heavy MPI workloads on login nodes.
- Do not separate queue submission from runtime monitoring in a production workflow.
- Do not resubmit unchanged failing jobs when a solver-specific error dictionary exists.
- Do not choose core counts without a scale-based heuristic.
