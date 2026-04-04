# VASP Stage and Parameter Matrix

Complete INCAR snippets for every standard workflow stage.

## Stage Pipeline Overview

```
Relaxation → Static SCF → DOS → Band Structure → Optical / Advanced
     ↓            ↓         ↓          ↓
  CONTCAR     CHGCAR    DOSCAR     EIGENVAL
  OUTCAR      WAVECAR   vasprun    PROCAR
```

Each stage requires its own INCAR. Do not reuse one INCAR unchanged across stages.

## Stage 1: Geometry Relaxation

### Ions-Only Relaxation (surfaces, defects)

```
SYSTEM  = relaxation-ions-only
PREC    = Accurate
ENCUT   = 520          # or 1.3*max(ENMAX) for your POTCARs
EDIFF   = 1E-06
EDIFFG  = -0.02        # force criterion: max |F| < 0.02 eV/A

IBRION  = 2            # conjugate gradient
NSW     = 300           # max ionic steps
ISIF    = 2            # relax ions only; fix cell shape and volume

ISMEAR  = 0            # Gaussian smearing (safe default)
SIGMA   = 0.05

LREAL   = Auto         # real-space projection for >20 atoms; .FALSE. for small cells
LWAVE   = .FALSE.      # save disk unless restart needed
LCHARG  = .TRUE.       # needed for static follow-on
```

### Full Cell Relaxation (bulk)

```
SYSTEM  = relaxation-full-cell
PREC    = Accurate
ENCUT   = 520          # MUST be >= 1.3*max(ENMAX) to avoid Pulay stress
EDIFF   = 1E-06
EDIFFG  = -0.02

IBRION  = 2
NSW     = 300
ISIF    = 3            # relax ions + cell shape + volume

ISMEAR  = 0            # use 1 for metals
SIGMA   = 0.05         # use 0.2 for metals with ISMEAR=1

LREAL   = Auto
LWAVE   = .FALSE.
LCHARG  = .TRUE.
```

## Stage 2: Static SCF

```
SYSTEM  = static-scf
PREC    = Accurate
ENCUT   = 520          # same as relaxation for consistency
EDIFF   = 1E-06

IBRION  = -1           # no ionic update
NSW     = 0            # zero ionic steps

ISMEAR  = -5           # tetrahedron method (accurate for static)
                       # use ISMEAR=0 SIGMA=0.05 if < 3 k-points per direction

LORBIT  = 11           # write PROCAR for projected DOS
LWAVE   = .TRUE.       # needed for bands / optical follow-on
LCHARG  = .TRUE.       # needed for DOS / bands follow-on
NEDOS   = 2001         # smooth DOS output
```

Note: for metals, check entropy term. If T*S > 1 meV/atom, reduce SIGMA.

## Stage 3: DOS Calculation

```
SYSTEM  = dos-followon
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-06

IBRION  = -1
NSW     = 0
ICHARG  = 11           # read CHGCAR from static; do NOT update charge

ISMEAR  = -5           # tetrahedron for accurate DOS
LORBIT  = 11           # site-projected DOS
NEDOS   = 2001         # number of DOS energy grid points
EMIN    = -10          # energy window (eV relative to Fermi)
EMAX    = 10

LWAVE   = .FALSE.
LCHARG  = .FALSE.
```

K-points: use 1.5–2x denser mesh than relaxation. Must be Gamma-centered for ISMEAR=-5.

## Stage 4: Band Structure

```
SYSTEM  = band-structure
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-06

IBRION  = -1
NSW     = 0
ICHARG  = 11           # read CHGCAR; non-self-consistent

ISMEAR  = 0            # Gaussian (tetrahedron not valid for line-mode)
SIGMA   = 0.05
LORBIT  = 11

LWAVE   = .FALSE.
LCHARG  = .FALSE.
```

K-points: use line-mode KPOINTS file with high-symmetry path (e.g., from SeeK-path or VASPKIT).

**Exception for DFT+U and hybrids:** ICHARG=11 is unreliable. Use zero-weight k-points method:
1. Copy IBZKPT from static calculation to KPOINTS
2. Append band-path k-points with weight = 0
3. Run self-consistently (remove ICHARG=11)

## Stage 5: Optical Properties

```
SYSTEM  = optical
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-06

IBRION  = -1
NSW     = 0
ICHARG  = 11

ISMEAR  = -5
NBANDS  = 2 * NELECT   # need many empty bands for optical transitions
LOPTICS = .TRUE.       # calculate dielectric function
CSHIFT  = 0.1          # broadening for optical spectra
NEDOS   = 2001

LWAVE   = .FALSE.
LCHARG  = .FALSE.
```

Requires GW POTCARs (_GW variants) for best accuracy with unoccupied states.

## High-Value INCAR Tags by Concern

| Concern | Tags | Concrete values |
| --- | --- | --- |
| Electronic convergence | ALGO, NELM, EDIFF | ALGO=Fast; NELM=200 for hybrids; EDIFF=1E-06 |
| Ionic relaxation | IBRION, NSW, ISIF, EDIFFG, POTIM | IBRION=2; NSW=300; EDIFFG=-0.02; POTIM=0.5 |
| Smearing | ISMEAR, SIGMA | insulator: 0/0.05; metal: 1/0.2; static: -5/— |
| Spin | ISPIN, MAGMOM | ISPIN=2; MAGMOM per atom (see magnetic recipes) |
| Cutoff | ENCUT, PREC | PREC=Accurate; ENCUT=1.3*ENMAX for cell relax |
| Parallelism | KPAR, NCORE | KPAR=nodes; NCORE=cores/NUMA |
| Output | LWAVE, LCHARG, LORBIT | Stage-dependent; see above |

## KPOINTS Strategy by Stage

| Stage | K-point mode | Typical density | Grid type |
| --- | --- | --- | --- |
| Relaxation | Automatic mesh | KSPACING=0.25–0.3 | Gamma or MP |
| Static SCF | Automatic mesh | Same as or denser than relaxation | Gamma for ISMEAR=-5 |
| DOS | Automatic mesh | 1.5–2x relaxation density | Gamma-centered |
| Band structure | Line mode | 20–40 points per segment | High-symmetry path |
| Phonon (supercell) | Automatic mesh | Scale inversely with supercell | Gamma-centered |
| MD | Gamma only | 1x1x1 (large supercell) | Gamma |
