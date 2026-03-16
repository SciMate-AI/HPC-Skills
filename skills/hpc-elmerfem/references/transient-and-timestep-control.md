# ElmerFEM Transient And Timestep Control

## Contents

- transient simulation type
- timestep controls
- output intervals
- staged transient workflow

## Transient simulation type

In Elmer, transient behavior is controlled from `Simulation`.

Use transient mode when:

- time evolution is physically important
- source terms or boundary conditions vary in time
- later states depend on earlier states

Do not leave a steady-state simulation block in place for a transient problem.

## Timestep controls

Typical Simulation controls include:

- `Simulation Type`
- `Timestep Intervals`
- `Timestep Sizes`
- `Output Intervals`

Keep timestep policy explicit instead of embedding time assumptions elsewhere in the file.

## Output intervals

Use `Output Intervals` deliberately:

- frequent output for debugging or transient fronts
- sparse output for long runs where storage matters

If the user only needs final state or a few snapshots, reduce unnecessary output.

## Staged transient workflow

Use this pattern:

1. verify mesh and ID mapping
2. debug the solver in a simpler steady or short transient mode if needed
3. commit to the full transient schedule only after the model is stable
