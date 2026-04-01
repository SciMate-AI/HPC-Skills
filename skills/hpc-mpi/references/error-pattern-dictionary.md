# MPI Error Pattern Dictionary

## Pattern ID: `MPI_WRAPPER_AND_LAUNCHER_MISMATCH`

- Likely symptom: compile succeeds but runtime crashes or hangs strangely
- Root cause: wrapper compiler and launcher came from different MPI stacks
- Primary fix: rebuild or relaunch with one coherent MPI family

## Pattern ID: `MPI_SCHEDULER_GEOMETRY_INCOHERENT`

- Likely symptom: ranks are missing, oversubscribed, or rejected at startup
- Root cause: scheduler resource request does not match launcher rank or thread assumptions
- Primary fix: align node count, total ranks, CPUs per task, and `OMP_NUM_THREADS`

## Pattern ID: `MPI_COLLECTIVE_DEADLOCK`

- Likely symptom: some ranks print progress but the job never completes
- Root cause: ranks do not enter matching communication patterns
- Primary fix: reproduce at small rank count and inspect collective ordering

## Pattern ID: `MPI_RUNTIME_STACK_NOT_LOADED`

- Likely symptom: shared library load failure or launcher command not found in batch
- Root cause: environment activation only happened in the interactive shell
- Primary fix: move module loads and environment activation into the batch script
