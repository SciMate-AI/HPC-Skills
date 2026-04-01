# MPI Launcher Semantics

## Contents

- Native scheduler launch
- MPI-native launch
- Decision rules

## Native scheduler launch

Use the scheduler's native launcher when:

- Slurm or another scheduler is responsible for rank placement
- the site documentation recommends direct scheduler integration
- accounting and step tracking should stay inside the scheduler

Portable example direction:

- Slurm: `srun`

## MPI-native launch

Use `mpirun` or `mpiexec` when:

- the site or application guide explicitly requires it
- the process manager is part of the MPI stack and is the expected control plane
- the scheduler family does not provide a stronger native integration path

Examples of implementation-dependent behaviors:

- Open MPI often uses `mpirun`
- MPICH-family stacks commonly expose `mpiexec`
- Hydra-managed environments may attach specific semantics to `mpiexec`

## Decision rules

Use this order:

1. site-recommended launcher
2. scheduler-native launcher if the MPI stack is integrated cleanly
3. implementation-native launcher if the site expects it

Do not treat launcher syntax as cosmetic. It determines rank placement, environment propagation, and sometimes PMI or PMIx behavior.
