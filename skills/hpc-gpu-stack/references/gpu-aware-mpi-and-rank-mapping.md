# GPU-Aware MPI And Rank Mapping

## Contents

- Execution models
- Rank-to-GPU rules
- GPU-aware MPI triggers

## Execution models

Common GPU layouts:

| Layout | Typical use |
| --- | --- |
| one process driving one GPU | single-GPU or workstation debugging |
| one MPI rank per GPU | most common distributed GPU baseline |
| hybrid MPI plus threads | when CPU-side work and GPU count both matter |

Start from one rank per GPU unless the application clearly documents a different model.

## Rank-to-GPU rules

Keep mapping explicit.

Useful order of precedence:

1. scheduler-provided GPU allocation and device visibility
2. rank-local environment such as local-rank variables
3. application-side device selection

Do not assume rank 0 always owns GPU 0 in a managed launch. Use the visible-device list and the launcher-provided local-rank context.

## GPU-aware MPI triggers

Use CUDA-aware MPI assumptions only when:

- the active MPI stack explicitly supports it
- the application actually exchanges device-resident buffers
- the site packaging documents that the runtime path is GPU-aware

If that support is unclear, reduce to host-staged buffers first. A correct host-staged baseline is more valuable than guessing that GPU-aware MPI is active.
