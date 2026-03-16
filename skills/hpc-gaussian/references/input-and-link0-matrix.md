# Gaussian Input And Link 0 Matrix

## Purpose

Use this reference when assembling or checking the structure of a Gaussian input deck.

## Input block matrix

| Block | Role | Typical contents |
| --- | --- | --- |
| Link 0 | runtime and file directives | `%Chk`, `%Mem`, `%NProcShared`, `%LindaWorkers`, `%OldChk` |
| route section | job intent | method, basis, job type, SCF and solvent keywords |
| title | human label | short description of the run |
| charge and multiplicity | electronic state | `0 1`, `-1 2`, etc. |
| geometry | structure | element plus coordinates |
| additional sections | keyword-specific data | read sections for selected options |

## Link 0 directives

High-value directives:

| Directive | Purpose | Typical use |
| --- | --- | --- |
| `%Chk` | checkpoint file | save wavefunction and geometry for restart or post-processing |
| `%OldChk` | prior checkpoint input | restart or read from a previous stage |
| `%Mem` | memory limit | make memory intent explicit |
| `%NProcShared` | shared-memory cores | single-node shared-memory job |
| `%LindaWorkers` | Linda worker list | multi-node network-parallel job when supported |
| `%RWF` | read-write file path | large scratch or explicit file placement |

## Practical rules

- use `%Chk` for any workflow that may need restart, formchk, or cubegen
- use `%OldChk` only when the prior checkpoint is intentionally part of the new job
- use `%NProcShared` for shared-memory parallelism on one node
- use `%LindaWorkers` only when the installation and cluster policy support Linda
- keep file paths simple and portable inside the run directory when possible

## Route-section structure

The route section should communicate:

- the electronic structure method
- the basis set
- the job type
- any important SCF, geometry, or solvent modifiers

Keep it readable enough that the job intent is obvious without decoding every token.

## Failure-prone mismatches

| Mismatch | Why it fails |
| --- | --- |
| `%OldChk` present but not meaningful | accidental restart from stale state |
| `%NProcShared` larger than actual allocation | oversubscription or scheduler mismatch |
| route says frequency or optimization but geometry is not ready | wasted queue time or unstable run |
| missing `%Chk` for long jobs | no clean restart or post-processing handoff |
