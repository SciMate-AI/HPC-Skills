# GROMACS Error Recovery

## Contents

- `grompp` failures
- unstable dynamics
- topology and include mismatches
- analysis pitfalls

## `grompp` failures

If `grompp` fails:

1. inspect missing include or topology paths
2. inspect parameter incompatibilities in the `.mdp`
3. inspect atom counts and molecule definitions

Do not bypass serious warnings blindly with permissive flags.

## Unstable dynamics

If `mdrun` explodes or energies become nonphysical:

1. reduce timestep
2. verify minimization was completed
3. verify constraints and thermostat or barostat settings
4. verify the starting structure is physically sane

## Topology and include mismatches

Typical failure class:

- structure and topology atom counts diverge
- included `.itp` files do not match the molecules in the system
- force-field includes are inconsistent

Fix topology coherence before tuning runtime parameters.

## Analysis pitfalls

Analysis commands often require:

- the right trajectory file
- the right structure or run input reference
- correct group selection

If analysis output looks wrong, inspect selection and reference files before blaming the trajectory itself.
