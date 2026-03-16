# LAMMPS Variables, Loops, And Control-Flow Manual

## Contents

- Variables as workflow glue
- Looping with `next` and `jump`
- Conditional exits
- Multi-run automation rules

## Variables as workflow glue

LAMMPS input decks can encode simple automation with:

- `variable`
- `label`
- `next`
- `jump`
- `if`

Use these features for controlled workflow logic, not as a substitute for external orchestration when the branching becomes complex.

## Looping with `next` and `jump`

The official `next` and `jump` docs show the standard loop pattern:

1. define a loop variable
2. run a block
3. `next` the variable
4. `jump` back to the label

This works for:

- parameter sweeps
- multi-directory runs
- staged workflows inside one input language

## Conditional exits

The official docs also show an important pattern:

- run for a chunk of steps
- test a variable such as temperature
- `jump` out when the stop condition is met

If a variable is checked after a `run`, make sure it is current on the timestep where the run ends, typically by including it in thermo output or otherwise ensuring it is evaluated.

## Multi-run automation rules

Use built-in control flow when:

- the workflow is short
- the branching logic is local to one simulation
- reproducibility benefits from keeping the logic next to the input deck

Use an external driver instead when:

- file management grows complex
- cross-case aggregation is needed
- the control flow starts hiding the physical setup

LAMMPS control flow is powerful, but it is still an input language. Keep scripts readable enough that force-field and ensemble intent remains obvious.
