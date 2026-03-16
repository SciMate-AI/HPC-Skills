# CalculiX Cluster Execution Playbook

## Purpose

Use this reference when a CalculiX deck is moving from input editing into scheduled cluster execution.

## Pairing rule

Use this together with `hpc-orchestration`.

- this file owns CalculiX-specific launch, result-artifact, and continuation concerns
- `hpc-orchestration` owns scheduler, storage, transfer, and monitoring scaffolds

## Preflight

Before production submission:

1. confirm the `.inp` deck parses cleanly on a small run
2. confirm include files, meshes, or referenced data resolve from the actual run directory
3. confirm the job name and output expectations are explicit
4. confirm result files land on writable storage
5. benchmark one representative shape before scaling out

Do not use a long queue allocation to discover a missing include or malformed keyword block.

## Launch strategy

Portable starting point:

- single-job run through the solver executable from the submission directory
- use `srun` when the site packages CalculiX in a scheduler-friendly way

Example shape:

```bash
srun ccx -i model
```

If the site build is serial-only, use one task and size expectations accordingly.

## Logs worth watching

High-value checks:

- parse failure before the solve begins
- singularity or pivot issues
- unsupported keyword or procedure mismatch
- unexpectedly large result artifacts

## Storage and output

Recommended habits:

- keep the authoritative `.inp` and mesh data on project storage
- let scratch absorb heavy transient files when result volume is large
- stage back `.dat`, `.frd`, eigenmode, or thermal outputs intentionally

Result management matters because post-processing artifacts can be larger than expected.

## Restart and continuation

If the workflow is iterative or staged:

- keep one clear naming policy for successive decks and outputs
- separate source deck revisions from generated artifacts
- do not overwrite the last good result set without retaining provenance

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| job exits immediately | bad deck syntax or missing include | validate parsing in the real run directory |
| run produces huge artifacts | output request too broad | narrow result outputs before resubmitting |
| solve quality changes after resubmission | deck revision drifted | diff the active `.inp` against the last good version |
| scaling does not help | solver path or problem size is not parallel-beneficial | benchmark a smaller shape and reset expectations |
