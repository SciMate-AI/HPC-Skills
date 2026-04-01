# PMI PMIx And Environment Propagation

## PMI versus PMIx

MPI launch often depends on a process-management interface layer between the scheduler and the MPI runtime.

Common reality:

- Slurm-integrated launches may expect PMI or PMIx support
- different MPI implementations package that support differently
- a launch failure can come from the handoff layer even when the application binary is correct

Do not assume one cluster's PMI or PMIx behavior transfers unchanged to another.

## Environment propagation

Check these first when batch behavior differs from an interactive shell:

- the MPI module is loaded inside the batch script
- compiler or runtime library paths are set inside the batch script
- `OMP_NUM_THREADS` and related thread variables are exported in the job step environment
- container or module activation happens before the launcher runs

## Repair sequence

1. identify whether the site expects scheduler-native launch or MPI-native launch
2. confirm the active MPI stack supports the scheduler handoff in use
3. confirm all critical environment setup happens inside the batch script
4. reduce to a small-rank launch before changing low-level transport tuning
