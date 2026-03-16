# LAMMPS Script Structure

## Contents

- Required command order
- System definition choices
- Data-file handling
- Output essentials

## Required command order

Keep this sequence:

1. `units`
2. `dimension`
3. `boundary`
4. `atom_style`
5. structure creation or `read_data`
6. masses, pair styles, pair coefficients, neighbor settings
7. minimization and velocity initialization
8. fixes, thermo, dumps, run

LAMMPS is sensitive to out-of-order setup. Do not debug physics before the command ordering is clean.

## System definition choices

Use one box-construction path:

- procedural generation with `lattice`, `region`, `create_box`, `create_atoms`
- external structure with `read_data`

If `read_data` is used, do not keep `create_box` or `create_atoms` in the same script.

## Data-file handling

When using `read_data`, verify:

- atom count and type count match the intended force field
- `Masses` exists if the chosen potential family does not supply masses implicitly
- bonded sections exist when `atom_style` expects them
- the `Atoms` section format matches the chosen `atom_style`

Treat the atom-type map as a contract for `pair_coeff`.

## Output essentials

At minimum, define:

- `thermo`
- `thermo_style`
- a trajectory `dump` if the run needs visualization or post-processing

Use `custom` dump output when downstream tools like OVITO need explicit coordinates and atom IDs.
