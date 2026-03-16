# Gaussian Cluster Execution Playbook

## Purpose

Use this reference when a Gaussian workflow is moving from input preparation into scheduled cluster execution.

## Pairing rule

Use this together with `hpc-orchestration`.

- this file owns Gaussian-specific launch, scratch, checkpoint, and Linda concerns
- `hpc-orchestration` owns scheduler, transfer, storage-tier, and monitoring scaffolds

## Preflight

Before production submission:

1. confirm the input deck parses structurally
2. confirm `%Chk` and any `%OldChk` paths are intentional
3. confirm `GAUSS_SCRDIR` or the cluster scratch path is writable
4. confirm whether the job is shared-memory only or Linda-enabled
5. benchmark one representative shape before scaling out

Do not use a large allocation to discover a broken scratch path.

## Launch strategy

Portable starting point:

- single-node shared-memory job: use `%NProcShared` aligned to the scheduler CPU allocation
- multi-node network-parallel job: use `%LindaWorkers` only when the cluster install supports Linda and the site policy allows it

Keep Link 0 directives and scheduler allocation consistent. If the batch job gives 16 CPUs, `%NProcShared=16` is reasonable; values larger than the allocation are not.

## Scratch and artifacts

Gaussian scratch should live on a fast writable scratch tier.

Recommended habits:

- set `GAUSS_SCRDIR` explicitly in the job script
- keep bulky scratch off quota-constrained home storage
- stage back only logs, checkpoints, formatted checkpoints, and planned cube outputs

## Logs worth watching

High-value checks:

- immediate parse failure
- scratch or file-permission failure
- SCF non-convergence
- optimization stalling
- checkpoint or restart mismatches

## Restart and continuation

Before continuation:

- confirm the checkpoint source is the intended one
- keep the last good checkpoint before overwriting
- separate restart logic from method or basis changes unless the compatibility is understood

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| job exits immediately in batch | environment or scratch path is wrong | make `g16root` and `GAUSS_SCRDIR` explicit |
| run is slower than expected | `%NProcShared` does not match real allocation | align Link 0 with the scheduler request |
| multi-node run fails oddly | Linda not supported or misconfigured | reduce to shared-memory mode or validate Linda support first |
| restart is inconsistent | stale checkpoint handoff | verify `%Chk` and `%OldChk` before resubmitting |
