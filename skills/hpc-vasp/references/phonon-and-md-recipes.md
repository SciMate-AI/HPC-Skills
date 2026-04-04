# VASP Phonon and Molecular Dynamics Recipes

## Phonon Calculations

### Approach Overview

| Method | INCAR tag | Pros | Cons |
| --- | --- | --- | --- |
| Finite differences (VASP internal) | IBRION=5/6 | Simple setup; elastic constants with IBRION=6 | Expensive for large cells |
| DFPT (VASP internal) | IBRION=7/8 | No supercell needed for Gamma phonons | Only q=Gamma; limited to certain functionals |
| Phonopy (external) | IBRION=-1 per displacement | Full dispersion; thermal properties | Multi-step workflow; needs scripting |

### Finite Differences: IBRION=5/6

```
SYSTEM  = phonon-finite-diff
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-08            # CRITICAL: very tight for accurate forces

IBRION  = 6                # symmetry-reduced finite differences (preferred over 5)
NSW     = 1                # must be >= 1 for IBRION=5/6
NFREE   = 2                # central differences (default; more accurate than forward)
POTIM   = 0.015            # displacement magnitude in Angstrom

ISIF    = 2                # or >= 3 if computing elastic constants too

ISMEAR  = 0
SIGMA   = 0.05
LREAL   = .FALSE.          # CRITICAL: must be exact for phonon accuracy

LWAVE   = .FALSE.
LCHARG  = .FALSE.
```

**IBRION=6 + ISIF>=3**: Also computes the elastic constant tensor. ENCUT must be high (1.5x ENMAX).

**Supercell k-point rule:** If unit cell needs NxNxN k-mesh, a 2x2x2 supercell needs (N/2)x(N/2)x(N/2).

### DFPT: IBRION=7/8

```
SYSTEM  = phonon-dfpt
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-08

IBRION  = 8                # symmetry-reduced DFPT (preferred over 7)
NSW     = 1

ISMEAR  = 0
SIGMA   = 0.05
LREAL   = .FALSE.

LEPSILON = .TRUE.          # compute Born effective charges and dielectric tensor
LPHON_POLAR = .TRUE.       # include LO-TO splitting (VASP 6+)
```

Note: VASP DFPT only computes phonons at Gamma (q=0). For full dispersion, use Phonopy.

### Phonopy Interface Workflow

**Step 1: Create supercell and displacements**
```bash
phonopy -d --dim="2 2 2" -c POSCAR-unitcell
# Creates: SPOSCAR (supercell) and POSCAR-{001,002,...} (displaced structures)
```

**Step 2: Run VASP single-point for each displacement**

INCAR for each displacement (no relaxation!):
```
PREC     = Accurate
ENCUT    = 520
EDIFF    = 1E-08           # very tight convergence essential
IBRION   = -1              # NO ionic relaxation
NSW      = 0
ISMEAR   = 0
SIGMA    = 0.05
LREAL    = .FALSE.         # exact projection for force accuracy
LWAVE    = .FALSE.
LCHARG   = .FALSE.
```

**Step 3: Collect forces**
```bash
phonopy -f disp-001/vasprun.xml disp-002/vasprun.xml ...
# Creates: FORCE_SETS
```

**Step 4: Post-process**
```bash
phonopy --dim="2 2 2" -p band.conf       # band structure
phonopy --dim="2 2 2" -p mesh.conf       # DOS
phonopy --dim="2 2 2" -t mesh.conf       # thermal properties
```

### Phonon Pre-Relaxation Requirements

Before computing phonons, the structure MUST be very well relaxed:
- Use tight EDIFFG=-0.001 (forces < 1 meV/A) for phonon pre-relaxation.
- Residual forces cause imaginary modes that are artifacts, not physics.
- Use the SAME ENCUT, KPOINTS, and functional for pre-relaxation and phonon calculation.

### Supercell Size Guidelines

| System | Typical supercell | Rationale |
| --- | --- | --- |
| Simple cubic / BCC / FCC | 2x2x2 to 4x4x4 | Short-range force constants |
| Ionic crystal (NaCl, MgO) | 3x3x3 to 4x4x4 | Long-range Coulomb; need larger |
| 2D material (MoS2, graphene) | 4x4x1 to 6x6x1 | In-plane phonons need range |
| Polar semiconductor | 3x3x3 + NAC correction | Add non-analytic correction (BORN file) |

---

## Elastic Constants

Computed automatically with IBRION=6 + ISIF>=3:

```
IBRION  = 6
ISIF    = 3
NFREE   = 4               # 4 for better accuracy than default 2
POTIM   = 0.015
ENCUT   = 1.5 * max(ENMAX) # high cutoff for stress convergence
PREC    = Accurate
EDIFF   = 1E-08
LREAL   = .FALSE.
```

Results: elastic tensor printed in OUTCAR (`grep "TOTAL ELASTIC" OUTCAR -A 10`).

---

## Ab Initio Molecular Dynamics (AIMD)

### NVT Ensemble (Nose-Hoover Thermostat)

```
SYSTEM  = aimd-nvt
PREC    = Normal           # Accurate is overkill for MD
ENCUT   = 400              # can be lower than static; test convergence
EDIFF   = 1E-05            # looser than static; speed matters

IBRION  = 0                # molecular dynamics
NSW     = 5000             # number of MD steps
POTIM   = 1.0              # time step in fs; 1-2 fs typical
ISIF    = 2                # fix cell shape and volume

MDALGO  = 2                # Nose-Hoover thermostat
SMASS   = 1.0              # Nose mass; controls coupling (0.5-3.0 typical)
TEBEG   = 300              # initial temperature (K)
TEEND   = 300              # final temperature (K); same = constant T

ISYM    = 0                # disable symmetry for MD
ALGO    = VeryFast         # RMM-DIIS; fastest electronic minimizer
NELMIN  = 4                # minimum SCF steps per ionic step (avoid incomplete SCF)
ISMEAR  = 0
SIGMA   = 0.1

LREAL   = Auto             # real-space for speed
LWAVE   = .FALSE.
LCHARG  = .FALSE.
```

### NVE Ensemble (Microcanonical)

```
MDALGO  = 1                # NVE; or omit MDALGO and set SMASS=-3
# Remove TEBEG, TEEND, SMASS
# Use IBRION=0, NSW, POTIM as above
```

Initialize velocities from a previous NVT run (CONTCAR contains velocities).

### NPT Ensemble (Langevin Thermostat + Barostat)

```
MDALGO  = 3                # Langevin thermostat
LANGEVIN_GAMMA = 10.0 10.0 # friction coefficient per species (ps^-1)
LANGEVIN_GAMMA_L = 10.0    # lattice friction
PMASS   = 1000             # fictitious lattice mass for barostat
ISIF    = 3                # allow cell to change
TEBEG   = 300
TEEND   = 300
```

### AIMD Practical Notes

| Parameter | Guidance |
| --- | --- |
| POTIM | 1.0 fs for heavy elements; 0.5 fs if H atoms present |
| Supercell | >= 64 atoms for bulk liquids; >= 100 for interfaces |
| K-points | Gamma only for large supercells (standard practice) |
| Equilibration | First 500–2000 steps; discard from statistics |
| Production | 5000–50000 steps depending on property |
| Temperature control | Check temperature in OSZICAR: should fluctuate around TEBEG |

### Common AIMD Pitfalls

1. **POTIM too large**: Energy conservation fails; atoms fly apart. Start with 1.0 fs, reduce if crashes.
2. **EDIFF too tight**: Wastes time. 1E-05 is sufficient for MD.
3. **Forgetting ISYM=0**: Symmetry with moving atoms causes errors.
4. **NELMIN too small**: SCF not converged between steps → drift in conserved quantity.
5. **Using ALGO=Normal**: Too slow for MD. Use VeryFast or Fast.
