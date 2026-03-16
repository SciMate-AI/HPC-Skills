# LAMMPS Data Files, Force Fields, And Groups

## Contents

- `read_data` rules
- Multiple data-file assembly
- Force-field mapping
- Type labels and groups

## `read_data` rules

The official `read_data` documentation contains several high-value constraints.

Key rules:

- after the first `read_data`, several type-count and per-atom settings become locked
- when reading additional data files, later type IDs cannot exceed what the first setup allowed
- when a box already exists, additional reads require the appropriate add-style workflow

This matters for generated assembly scripts. The first structure import establishes limits for later composition.

## Multiple data-file assembly

LAMMPS supports building a complex system from multiple data files.

Important official features:

- `group` can place atoms from each imported file into a named group
- `offset`, `shift`, and related keywords support structured composition
- `nocoeff` allows reading coefficient sections without applying them

Use this when:

- assembling walls and fluid from separate files
- importing subsystems that need later repositioning
- reading a structure file whose coefficient sections should not drive the final force field

Do not assume that because a second `read_data` succeeds syntactically, the type layout is still semantically valid.

## Force-field mapping

`pair_coeff` is a mapping layer, not just a numeric line.

Official guidance allows:

- numeric atom types
- wildcard forms
- type labels via `labelmap`

Use that deliberately:

- for simple pair styles, explicit type pairs may be enough
- for many-body styles, the wildcard mapping form is often the intended pattern
- for human-readable scripts with many atom types, type labels can reduce mistakes
- when importing multiple subsystems, groups let later fixes and outputs stay targeted instead of overloading `all`

If the atom-type map is unclear, fix that before debugging dynamics.

## Type labels and groups

High-value operational guidance:

- use groups to keep imported subsystems addressable
- use labels when they reduce ambiguity in `pair_coeff`
- keep a written map from atom type to species or role

A correct force field with a wrong atom-type map is still a broken simulation.
