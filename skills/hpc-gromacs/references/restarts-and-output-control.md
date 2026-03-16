# GROMACS Restarts And Output Control

## Contents

- checkpoint model
- append versus split-output behavior
- long-job continuation
- diagnostic tools

## Checkpoint model

The official `gmx mdrun` docs describe checkpointing as the primary continuation mechanism.

Key files:

- checkpoint input via `-cpi`
- checkpoint output via `-cpo`
- backup checkpoint `state_prev.cpt`

Use checkpointing as the source of truth for safe continuation.

## Append versus split-output behavior

Official `mdrun` behavior:

- with matching previous outputs and checkpoint checksums, files are appended
- if files are missing or mismatched, `mdrun` can stop with a fatal error
- `-noappend` creates new output files with part numbering

Inference for the skill:

- continuation policy must be decided before rerunning
- do not manually edit old outputs and expect seamless append behavior

## Long-job continuation

The official docs recommend using:

- checkpoint interval control
- `-maxh` for walltime-bounded runs

Practical pattern:

1. compile a stage once
2. run with checkpointing enabled
3. continue with `-cpi` on the next allocation

## Diagnostic tools

`gmx dump` is an official low-level inspection tool for:

- `.tpr`
- trajectory files
- checkpoint files
- topology views

Use it when a compiled run input or checkpoint is suspected to be inconsistent.
