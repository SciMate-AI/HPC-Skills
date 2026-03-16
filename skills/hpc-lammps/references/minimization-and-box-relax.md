# LAMMPS Minimization And Box Relax Manual

## Contents

- When to minimize
- Minimization workflow
- `fix box/relax`
- Pressure-monitoring caveat
- Practical pre-production sequence

## When to minimize

Minimize before production dynamics when:

- atoms may overlap
- the structure was freshly assembled
- the box or lattice spacing is only approximate
- a metallic or molecular structure was imported from a preprocessing step that did not fully relax it

If a run blows up immediately, assume missing minimization is a prime suspect.

## Minimization workflow

The official `minimize` docs support combining minimization with other relevant fixes, especially those that add forces or relax the box.

Practical sequence:

1. define force field and neighbor logic
2. run position-only minimization
3. if box stress matters, use box relaxation
4. only then assign full thermal velocities and production ensembles

## `fix box/relax`

The official `fix box/relax` docs are clear:

- it is used during minimization
- it adjusts box geometry toward target stress or pressure
- pressure during minimization should be interpreted carefully because the kinetic contribution is ignored

The docs also recommend helpful tactics:

- consider `min_modify line quadratic`
- sometimes minimize several times in succession
- often relax atom positions before relaxing the box
- for solids, hydrostatic relaxation before shear-stress targeting can help

## Pressure-monitoring caveat

The docs warn that if atoms still carry non-zero velocities, standard thermodynamic pressure can look misleading during box relaxation because the fix uses virial pressure logic for the minimization target.

Inference for the skill:

- zero or ignore thermal interpretation during minimization
- monitor the pressure quantity appropriate to the minimization path

## Practical pre-production sequence

High-confidence workflow:

1. read or create the structure
2. define force field
3. set conservative neighbor rebuilds
4. minimize
5. optionally box-relax
6. start with NVT or a similarly controlled equilibration stage
7. only then move to NPT, loading, or long production dynamics
