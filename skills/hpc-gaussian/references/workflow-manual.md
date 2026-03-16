# Gaussian Workflow Manual

## Purpose

Use this as the primary entry point for Gaussian work. It orients the workflow before any route section or restart logic is written.

## Input anatomy

A Gaussian input deck is typically organized as:

1. optional Link 0 lines such as `%Chk`, `%Mem`, `%NProcShared`, or `%LindaWorkers`
2. route section beginning with `#`
3. title section
4. charge and multiplicity line
5. molecular geometry
6. optional additional sections required by selected keywords

Treat these blocks as a coupled unit. A valid route section is not enough if charge, multiplicity, or the geometry block is inconsistent.

## Common workflow stages

Typical staged workflows:

- single-point energy
- geometry optimization
- frequency analysis
- optimization plus frequency
- restart or follow-on analysis using checkpoint artifacts

Do not start from a large multi-step plan if a small validation run would clarify the setup.

## Minimal design sequence

1. fix the molecular structure and coordinate convention
2. set charge and multiplicity
3. choose the method and basis set
4. choose the job type
5. decide whether Link 0 directives for memory, cores, and checkpointing are needed
6. define restart and artifact policy before long production runs

## Cluster pairing

For cluster execution, pair this skill with `hpc-orchestration`.

- Gaussian-specific input and restart logic lives here
- scheduler, scratch, transfer, and monitoring strategy lives there

## Output expectations

High-value artifacts often include:

- Gaussian text output
- checkpoint file
- formatted checkpoint when post-processing requires it
- cube files for volumetric visualization when needed

## Guardrails

- keep the title and route intent human-readable
- make checkpoint policy explicit
- keep one job purpose per input deck unless a staged restart policy justifies more coupling
