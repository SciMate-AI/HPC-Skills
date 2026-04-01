# MPI Implementation Matrix

## Contents

- Major family traits
- Selection rules
- Compatibility guardrails

## Major family traits

| MPI family | Typical strengths | Typical caution |
| --- | --- | --- |
| Open MPI | broad ecosystem support, common on clusters and workstations, flexible runtime tooling | launcher and PMIx behavior must align with the scheduler and site packaging |
| MPICH | conservative baseline semantics, common upstream reference behavior | launcher expectations differ when Hydra is the process manager |
| Intel MPI | strong fit on Intel-focused clusters and vendor-managed environments | environment variables, launcher mode, and fabric assumptions can differ from Open MPI habits |
| MVAPICH2 | performance-oriented deployments on RDMA-heavy systems | site tuning and fabric choices matter more than workstation defaults |

## Selection rules

Choose the MPI family from the deployment reality first:

1. use the site-provided MPI stack when running on a managed cluster unless there is a strong reason not to
2. keep compiler wrapper, linked MPI libraries, and runtime launcher from the same stack
3. if an application was already built against one MPI family, do not swap launchers casually at runtime

## Compatibility guardrails

Treat these combinations as high risk unless the site explicitly documents them:

- `mpicc` from one stack plus `mpirun` from another
- application linked to one MPI family but launched through a different scheduler-integrated MPI plugin
- container image carrying one MPI runtime while the host launch path assumes another

The safe baseline is one coherent MPI stack from compile through launch.
