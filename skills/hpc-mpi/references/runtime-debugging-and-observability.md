# MPI Runtime Debugging And Observability

## Small-rank reproduction

If an MPI job hangs or crashes:

1. reduce to the smallest rank count that still reproduces the issue
2. capture rank-local stdout or stderr if the workflow permits it
3. confirm whether the failure is collective, rank-local, or launcher-wide

Large-rank failures are expensive to inspect and often hide the first failing rank.

## First checks

- confirm the active `mpirun` or `mpiexec` or `srun` path
- confirm wrapper compilers and runtime launchers come from the same module set
- confirm `OMP_NUM_THREADS` and CPUs per task are coherent
- confirm no unexpected oversubscription is happening

## Common runtime signals

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| only rank 0 prints then everything stalls | collective mismatch or a deadlocked rank | reduce rank count and add rank-local logging around collectives |
| launcher rejects rank count | scheduler and launcher geometry mismatch | align `--ntasks` or launcher `-n` assumptions |
| runtime loader cannot find MPI libraries | wrong module set at launch time | load the same MPI stack used at build time |
| job is slower at more ranks | communication or binding overhead dominates | reduce ranks or rebalance ranks versus threads |
