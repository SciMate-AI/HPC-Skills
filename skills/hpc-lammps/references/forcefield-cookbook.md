# LAMMPS Force-Field Cookbook

## Contents

- Lennard-Jones family
- EAM and MEAM
- Tersoff and other bond-order forms
- ReaxFF
- Hybrid styles

## Lennard-Jones family

Use `lj/cut`-style pair interactions when the system is intentionally modeled with simple pairwise non-bonded interactions.

Good fit:

- reduced-model fluids
- coarse toy systems
- baseline testing of a workflow

Not a good fit:

- metallic bonding
- covalent bond-order materials
- reactive chemistry

## EAM and MEAM

Use EAM or MEAM families for metallic systems when the available potential file matches the species set.

Operational rules from the official docs:

- many-body potentials usually expect wildcard mapping in `pair_coeff`
- the element mapping order matters
- the potential file family must match the chosen pair style

Use this family for:

- elemental metals
- many alloys covered by the distributed parameterization

Do not substitute LJ just because the EAM mapping feels more verbose.

## Tersoff and other bond-order forms

Use Tersoff-style potentials for covalent materials when a supported parameterization exists.

Good fit:

- Si, C, SiC, and related covalent systems under the right parameter file

Operational caution:

- mapping mistakes in many-body potentials are easy and catastrophic
- type-to-element order must be explicit and reviewed

## ReaxFF

Use `reaxff`-family workflows only when reactive chemistry is actually required and the environment is prepared for it.

Practical implications:

- more setup burden
- more sensitivity to timestep and charge-related settings
- not a drop-in replacement for simpler bonded or many-body models

If the chemistry is not reactive, do not reach for ReaxFF by default.

## Hybrid styles

LAMMPS supports hybrid pair styles, but they are not a casual default.

Use hybrid combinations only when:

- the interaction partition is physically justified
- the force-field domains are clearly separated
- the user has a principled reason to mix models

Do not use hybrid styles as a patch for uncertainty about the correct force field.
