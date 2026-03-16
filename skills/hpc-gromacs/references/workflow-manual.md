# GROMACS Workflow Manual

## Contents

- Canonical command pipeline
- Preprocessing artifacts
- Standard stage ordering
- Execution choices

## Canonical command pipeline

Treat the core workflow as:

1. prepare coordinates and topology
2. write an `.mdp` file for the current stage
3. run `gmx grompp`
4. run `gmx mdrun`
5. analyze trajectory and energies

The official user guide and command docs make `grompp` the main consistency gate before dynamics.

## Preprocessing artifacts

High-value file roles:

- `.gro` or similar structure file: coordinates and box
- `.top`: system topology and included force-field logic
- `.itp`: included topology fragments
- `.mdp`: run parameters for the stage
- `.tpr`: compiled portable run input from `grompp`

Treat `.tpr` as the executable contract for `mdrun`.

## Standard stage ordering

Typical MD pipeline:

1. energy minimization
2. NVT equilibration
3. NPT equilibration
4. production MD

Do not jump into production with a fresh unrelaxed structure unless the user explicitly provides a validated state.

## Execution choices

`gmx mdrun` is the primary execution tool.

Practical rules:

- compile each stage with a dedicated `.mdp`
- keep run names stable across stages
- if checkpointing matters, design restart files and output names deliberately
