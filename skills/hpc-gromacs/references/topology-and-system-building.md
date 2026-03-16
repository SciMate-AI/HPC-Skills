# GROMACS Topology And System-Building Manual

## Contents

- `pdb2gmx`
- box editing and centering
- solvation
- ion insertion

## `pdb2gmx`

The official `gmx pdb2gmx` workflow is the canonical route for supported biomolecular structures.

Use it when:

- the force field is one of the packaged or installed GROMACS force fields
- hydrogens and topology generation should follow force-field conventions
- protonation prompts and residue naming need GROMACS-side handling

Operational rules from the official docs:

- force fields are discovered through `<forcefield>.ff` directories
- local copies can override the library force field
- residue naming and protonation state decisions materially affect the generated topology

If protonation or residue naming is uncertain, fix that before running dynamics.

## Box editing and centering

Before solvation, center and size the solute deliberately.

Practical sequence:

1. generate or import the solute structure
2. use `gmx editconf` to center it and define the box
3. only then solvate

Do not rely on solvation alone to create a sensible box around an off-center solute.

## Solvation

The official `gmx solvate` docs emphasize:

- it uses the box from the solute unless `-box` is given
- solvent removal depends on scaled van der Waals radii
- it can update the topology solvent count when `-p` is used

Important caveats:

- solvent molecules must be whole
- atom naming affects radii lookup quality
- `-maxsol` can leave voids and should be used carefully

## Ion insertion

The official `gmx genion` docs emphasize:

- it replaces solvent molecules with monoatomic ions
- the solvent group must be continuous and compositionally uniform
- topology can be updated automatically with `-p`
- ion names must be the force-field molecule names, not arbitrary atom names

Use ion insertion only after:

1. the solvated structure exists
2. a pre-ionization run input exists if needed for the selection workflow
3. topology update policy is clear
