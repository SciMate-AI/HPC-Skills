# MPI Scheduler Integration Playbook

## Slurm

Preferred first question:

- does the site expect `srun` to launch the MPI job directly

If yes:

- keep rank count in `--ntasks`
- keep thread count in `--cpus-per-task`
- export `OMP_NUM_THREADS` explicitly for hybrid runs

If the site instead expects `mpirun` or `mpiexec` inside the allocation:

- align the launcher rank count to scheduler-provided task counts
- keep launcher choice consistent with the loaded MPI family

## PBS And LSF

For PBS or LSF:

- prefer the site-recommended launcher
- make node count and total rank count explicit
- do not assume Slurm-style PMI behavior exists

## Handoff rules

When moving from compile to scheduler launch:

1. confirm the same MPI stack is still loaded
2. confirm environment variables are set inside the batch script, not only in the login shell
3. confirm rank count and host placement assumptions come from the allocation, not from a stale workstation script
