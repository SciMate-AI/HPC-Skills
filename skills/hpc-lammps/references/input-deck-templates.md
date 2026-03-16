# LAMMPS Input Deck Templates

## Contents

- Minimal Lennard-Jones fluid
- Minimal EAM metal
- Molecule-style workflow skeleton
- Template usage rules

## Minimal Lennard-Jones fluid

Use this shape for a simple reduced-unit LJ fluid:

```text
units           lj
dimension       3
boundary        p p p
atom_style      atomic

lattice         fcc 0.8442
region          box block 0 10 0 10 0 10
create_box      1 box
create_atoms    1 box

pair_style      lj/cut 2.5
pair_coeff      1 1 1.0 1.0 2.5
mass            1 1.0

neighbor        0.3 bin
neigh_modify    delay 0 every 1 check yes

velocity        all create 1.44 12345 mom yes rot yes
fix             1 all nve
thermo          100
run             1000
```

Use this for reduced-unit workflow testing, not as a substitute for a material-specific model.

## Minimal EAM metal

Use this shape for a simple elemental metallic run:

```text
units           metal
dimension       3
boundary        p p p
atom_style      atomic

read_data       structure.data

pair_style      eam/alloy
pair_coeff      * * potential.eam.alloy Cu

neighbor        2.0 bin
neigh_modify    delay 0 every 1 check yes

minimize        1.0e-4 1.0e-6 1000 10000
timestep        0.001
fix             1 all nvt temp 300 300 0.1
thermo          100
dump            1 all custom 100 traj.lammpstrj id type x y z
run             10000
```

Replace the element mapping with the actual species map from the potential file.

## Molecule-style workflow skeleton

Use this shape when bonded topology matters:

```text
units           real
dimension       3
boundary        p p p
atom_style      full

read_data       system.data

# bonded and non-bonded styles
# pair_style ...
# bond_style ...
# angle_style ...

neighbor        2.0 bin
neigh_modify    delay 0 every 1 check yes

minimize        1.0e-4 1.0e-6 1000 10000
timestep        1.0
fix             1 all nvt temp 300 300 100.0
thermo          100
run             10000
```

Do not reuse `atom_style atomic` templates for bonded molecular systems.

## Template usage rules

- treat templates as structural starting points
- convert timestep and damping to the chosen unit system before running
- verify that the pair style, coeff mapping, and data-file semantics match the actual model
- insert minimization before production dynamics unless the starting state is already validated
