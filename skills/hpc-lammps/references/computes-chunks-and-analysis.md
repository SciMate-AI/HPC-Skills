# LAMMPS Computes, Chunks, And Analysis Manual

## Contents

- Global analysis patterns
- RDF
- MSD
- Chunk workflows
- Averaging outputs

## Global analysis patterns

LAMMPS separates:

- computes that produce values
- fixes that average or emit values
- dump and thermo channels that store values

Do not force every analysis quantity through one output mechanism.

## RDF

The official `compute rdf` docs describe:

- output as a global array
- first column as bin coordinate
- later columns as `g(r)` and coordination number per requested pair set

Important documented caveat:

- by default RDF is not computed beyond the largest force cutoff, because the neighbor list only extends that far plus the skin

Inference for the skill:

- if the user asks for long-range RDF, inspect force cutoff and neighbor logic before assuming the compute is wrong

## MSD

The official `compute msd` docs note:

- output is a global vector of length 4
- restart continuity depends on using the same compute ID
- it cannot be used with a dynamic group

If restart continuity or group stability matters, compute naming is not cosmetic. Keep the same compute ID across restarted workflows.

## Chunk workflows

Official chunk docs cover:

- `compute chunk/atom`
- `compute property/chunk`
- `compute msd/chunk`
- `fix ave/chunk`

Use chunks when the right unit of analysis is:

- molecule
- cluster
- spatial bin
- another subgrouping that is not simply the whole system

Important documented caveat:

- chunk assignments are not stored in restart files

So if a restarted run depends on chunk logic, recreate the chunk assignment explicitly.

## Averaging outputs

The docs recommend `fix ave/time` for writing global vectors and arrays such as chunk-derived quantities.

Use:

- `fix ave/time` for time averaging global signals
- `fix ave/chunk` for chunk-binned output

If the target signal is per-chunk MSD, RDF-derived channels, or other analysis arrays, choose the averaging fix that matches the data rank.
