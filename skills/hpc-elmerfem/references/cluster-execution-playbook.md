# ElmerFEM Cluster Execution Playbook

## Purpose

Use this reference when an ElmerFEM workflow is moving from `.sif` editing into scheduled cluster execution.

## Pairing rule

Use this together with `hpc-orchestration`.

- this file owns Elmer-specific launch, mesh-directory, and solver-output concerns
- `hpc-orchestration` owns scheduler, storage, transfer, and monitoring scaffolds

## Preflight

Before production submission:

1. confirm the mesh directory resolves from the actual run directory
2. confirm body and boundary IDs match the mesh as staged
3. confirm the `.sif` selects the intended physics and solver stack
4. run one small validation solve with the intended environment
5. confirm output files land on writable storage

Do not use a long allocation to discover an ID-mapping or mesh-directory mistake.

## Launch strategy

Portable starting point:

- stage into the case directory containing the mesh and `.sif`
- launch `ElmerSolver` through `srun` unless the site packaging requires another launcher

Example shape:

```bash
srun ElmerSolver case.sif > elmer.log 2>&1
```

Keep the staged mesh and the active `.sif` together so the run directory is self-consistent.

## Logs worth watching

High-value checks:

- parse failures in the `.sif`
- mesh-directory or ID-mapping errors
- linear or nonlinear solver divergence
- unexpectedly heavy result output

## Storage and output

Recommended habits:

- keep authoritative mesh sources and `.sif` files on project storage
- use scratch for heavy transient solve outputs if needed
- stage back the intended result files and solver logs explicitly

Output planning matters because multiphysics workflows can create bulky result sets quickly.

## Restart and continuation

If the workflow is transient or staged:

- keep restart or continuation artifacts in a predictable subdirectory
- retain the exact `.sif` that produced each stage
- do not change mesh IDs or physics assignments and expect continuation to remain valid

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| job exits before solving | bad `.sif` or mesh-directory path | validate run-directory layout and parse behavior |
| solver diverges after queue submission | linear or nonlinear controls too aggressive | tune solver settings before changing scale |
| outputs are missing or huge | output section is wrong for the workflow | narrow result output and verify paths |
| continuation behaves inconsistently | mesh or ID mapping changed between stages | keep stage artifacts and mappings explicit |
