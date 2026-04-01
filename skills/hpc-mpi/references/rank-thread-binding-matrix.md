# MPI Rank Thread And Binding Matrix

## Contents

- Pure MPI baselines
- Hybrid MPI plus OpenMP
- Binding guardrails

## Pure MPI baselines

| Situation | First baseline |
| --- | --- |
| CPU-only solver with little threading | one thread per rank and explicit MPI rank count |
| memory-heavy sparse linear algebra | size from memory first, then raise rank count |
| communication-heavy small case | avoid excessive ranks per node until scaling data justifies it |

## Hybrid MPI plus OpenMP

| Goal | Practical direction |
| --- | --- |
| use threaded kernels inside each rank | set `OMP_NUM_THREADS` to match CPUs per task |
| keep MPI and threading geometry aligned | make scheduler CPUs per task equal the thread count |
| reduce oversubscription risk | keep library thread variables consistent with OpenMP settings |

## Binding guardrails

Binding and affinity matter when:

- MPI and OpenMP are mixed
- NUMA boundaries matter
- performance changes sharply with rank placement

Portable rules:

- start from a simple, explicit rank and thread layout
- avoid hidden oversubscription
- change one of rank count, thread count, or binding policy at a time when tuning

Do not use binding tweaks to compensate for a broken launcher or inconsistent resource request.
