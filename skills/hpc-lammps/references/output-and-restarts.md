# LAMMPS Output And Restart Design

## Contents

- Thermo output design
- Dump design
- Time averaging and aggregation
- Restart behavior

## Thermo output design

`thermo_style custom` accepts global quantities. It is the right surface for:

- built-in thermo keywords
- global compute output
- global fix output
- equal-style variables

It is not the direct surface for arbitrary per-atom data.

Official output guidance maps the common channels clearly:

- `thermo_style custom` -> global scalars to screen and log
- `dump custom` -> per-atom vectors to dump files
- `fix ave/time` -> time-averaged global outputs
- `fix ave/chunk` -> chunk-averaged outputs

Design logs around those data types instead of trying to push everything through thermo output.

## Dump design

Use `dump custom` when downstream tools need explicit per-atom records such as:

- `id`
- `type`
- `x y z`
- optionally velocities, forces, or custom per-atom quantities

If the desired quantity is local, per-grid, or chunk-based, choose the matching output mechanism rather than forcing it into a per-atom dump.

## Time averaging and aggregation

Official docs emphasize that `fix ave/time` can write and average global quantities.

Use it for:

- smoothed temperature or pressure histories
- averaged energies
- reduced monitor signals used by automation

Use `fix ave/chunk` when the target is spatial or group chunking rather than a single global signal.

## Restart behavior

Restart semantics vary by fix.

An especially important documented exception:

- `fix langevin` does not write its random-number-generator state to binary restarts
- therefore exact restarts are not possible for that fix, even though restarted runs should be statistically consistent

Operational consequences:

- do not promise bitwise-identical continuation across a Langevin restart
- if restart reproducibility matters, record which fixes carry hidden stochastic state
- verify restart support fix by fix when exact continuation matters, because restart fidelity is not uniform across all fixes

Machine-readable logging tip:

- `thermo_style yaml` exists and is useful when an external parser will consume logs
- extract the YAML blocks cleanly instead of parsing mixed console chatter

Automation design pattern:

- use `thermo_style yaml` or tightly scoped `thermo_style custom` for global control-plane signals
- use dumps for atom-resolved state
- use averaging fixes for smoothed monitor channels that trigger automated decisions
