# Gaussian Checkpoint Restart And Artifacts

## Purpose

Use this reference when the workflow depends on checkpoint files, formatted checkpoints, cube generation, or restart handoff.

## Checkpoint policy

Use `%Chk` for any run that may need:

- restart
- follow-on stages
- formatted checkpoint conversion
- volumetric post-processing

Checkpoint policy should be decided before long runs, not after a failure.

## `%OldChk` and staged continuation

Use `%OldChk` only when the prior checkpoint is intentionally part of the new run.

Before continuation:

- identify the authoritative prior stage
- confirm the new route intent is compatible with the inherited state
- avoid mixing stale route assumptions with inherited checkpoint data

## Formatted checkpoints and cube workflows

Common artifact chain:

1. binary checkpoint from Gaussian
2. formatted checkpoint via `formchk`
3. cube generation via `cubegen` when volumetric data is needed

Keep these as explicit post-processing steps rather than hidden side effects.

## Artifact retention

Recommended retention policy:

- keep the main output log
- keep the checkpoint for restart-worthy runs
- generate formatted checkpoints only when needed
- generate cube files only when the downstream visualization plan actually needs them

Cube files can become large quickly. Treat them as planned outputs, not defaults.

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| restart behaves unlike the original intent | stale or wrong checkpoint source | verify `%OldChk` and the actual file used |
| post-processing cannot find orbitals or density data | no checkpoint or no formatted checkpoint | make checkpoint generation explicit |
| storage usage explodes | cube or scratch artifacts retained without plan | narrow artifact retention and move bulky files to scratch |
