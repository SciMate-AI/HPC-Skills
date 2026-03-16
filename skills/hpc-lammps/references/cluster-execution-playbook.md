# LAMMPS Cluster Execution Playbook

## Purpose

Use this reference when a LAMMPS input deck is moving into scheduled cluster execution.

## Pairing rule

Use this together with `hpc-orchestration`.

- this file owns LAMMPS-specific launch and restart concerns
- `hpc-orchestration` owns scheduler, transfer, environment, and monitoring scaffolds

## Preflight

Before a production submission:

1. confirm the potential files named in `pair_coeff` are present in the run directory or module path
2. confirm the data file path if `read_data` is used
3. run a short validation step with the intended executable
4. confirm dump and restart output paths land on writable storage
5. confirm the rank count is reasonable for the model size and force-field cost

## Execution modes

Common patterns:

- CPU MPI run: `srun lmp -in in.case`
- hybrid MPI and OpenMP: set `OMP_NUM_THREADS` explicitly and align `--cpus-per-task`
- GPU-enabled build: request GPUs explicitly and confirm the package-enabled executable matches the script assumptions

Do not switch between CPU-only and GPU-enabled binaries casually on the same input without checking package compatibility.

## Rank-count guidance

Use problem scale as the starting point:

- simple short-range models tolerate more ranks
- expensive many-body or reactive models usually need fewer atoms per rank
- benchmark one short run before scaling out

The right rank count depends on:

- atom count
- force-field family
- neighbor rebuild frequency
- communication overhead

## Logs worth watching

High-value checks:

- `Lost atoms`
- `Non-numeric pressure`
- neighbor-list overflow or dangerous builds
- PPPM or k-space warnings
- unstable thermo quantities during the first few thousand steps

## Storage and output

Recommended habits:

- keep dump frequency under control
- write restart files on a cadence tied to wall time and recovery needs
- keep large dumps on scratch during production and stage out only what is needed

Many LAMMPS jobs fail operationally because output volume is larger than expected, not because the input syntax is wrong.

## Restart and continuation

Prefer explicit continuation planning:

- decide whether the workflow restarts from `read_restart` or regenerates state from data plus commands
- keep restart files versioned by step or timestamp
- document which thermodynamic state the restart corresponds to

Do not overwrite the last known good restart file blindly.

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| job starts but exits before dynamics | missing potential or data file | validate file presence in the actual run directory |
| run is much slower on more ranks | communication overhead dominates | reduce rank count or benchmark a different rank-thread balance |
| production job fills storage | dump or restart cadence too aggressive | reduce output frequency and keep heavy data on scratch |
| restart resumes with the wrong state | ambiguous restart-file handling | make restart naming and handoff explicit |
