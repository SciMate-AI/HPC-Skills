# VASP Magnetic and Spin-Orbit Coupling Recipes

## Collinear Spin-Polarized Calculations

### Minimal INCAR additions for magnetism

```
ISPIN   = 2              # enable spin polarization
MAGMOM  = 4*3.0 2*0.0   # initial moment per atom (adjust to your system)
LORBIT  = 11             # print atomic magnetic moments in OUTCAR
```

### MAGMOM Initialization Strategy

Start with moments LARGER than the expected converged value. VASP will relax to the correct moment.

**Common initial values for 3d metals:**

| Element | Oxidation state | Initial MAGMOM | Typical converged | Notes |
| --- | --- | --- | --- | --- |
| Fe | Fe(0) metal | 3.0 – 5.0 | ~2.2 (BCC) | High-spin default |
| Fe | Fe(II) in oxide | 4.0 – 5.0 | ~3.5 | High-spin d6 |
| Fe | Fe(III) in oxide | 5.0 | ~4.2 | High-spin d5 |
| Co | Co(0) metal | 2.0 – 3.0 | ~1.7 (HCP) | |
| Co | Co(II) in oxide | 3.0 | ~2.5 | |
| Ni | Ni(0) metal | 1.0 – 2.0 | ~0.6 (FCC) | Small moment |
| Ni | Ni(II) in oxide | 2.0 | ~1.7 | |
| Mn | Mn(II) | 5.0 | ~4.5 | Half-filled d5; always high-spin |
| Mn | Mn(IV) in MnO2 | 4.0 | ~3.0 | |
| Cr | Cr(0) metal | 3.0 – 4.0 | ~0.6 (BCC AFM) | Antiferromagnetic ground state |
| V | V(0) metal | 2.0 – 3.0 | ~0 (paramagnetic) | |
| O | in transition metal oxide | 0.6 | ~0.0 – 0.3 | Small induced moment |
| N, C, S, Se | non-magnetic | 0.0 | 0.0 | |

### MAGMOM Shorthand Syntax

```
MAGMOM = 4*3.0 8*0.0          # 4 Fe atoms at 3.0, 8 O atoms at 0.0
MAGMOM = 2*5.0 2*-5.0 4*0.0   # AFM: 2 up, 2 down Mn; 4 O
```

The number of values must equal total NIONS in POSCAR.

### Ferromagnetic vs Antiferromagnetic Setup

**Ferromagnetic (FM):** All magnetic atoms have same sign MAGMOM.
```
MAGMOM = 4*5.0 4*0.0    # 4 Mn all spin-up
```

**Antiferromagnetic (AFM):** Alternate signs on magnetic sublattices.
```
MAGMOM = 2*5.0 2*-5.0 4*0.0    # 2 Mn up, 2 Mn down (checkerboard or layered)
```

**Ferrimagnetic:** Different magnitude moments on different sublattices.
```
MAGMOM = 2*5.0 2*-3.0 4*0.0    # tetrahedral vs octahedral sites in spinel
```

To determine ground state: run FM and all relevant AFM orderings, compare total energies.

### SCF Convergence Tips for Magnetic Systems

1. Pre-converge non-magnetic (ISPIN=1) first, then restart with ISPIN=2 and MAGMOM.
2. Use ALGO=All for difficult magnetic convergence.
3. Reduce mixing: AMIX=0.2, BMIX=0.0001, AMIX_MAG=0.8, BMIX_MAG=0.00001.
4. Increase NELM=200 for complex magnetic orderings.
5. Check converged MAGMOM in OUTCAR: `grep "magnetization (x)" OUTCAR`.

### Complete INCAR: Magnetic Bulk Relaxation (e.g., Fe2O3)

```
SYSTEM  = Fe2O3-AFM-relaxation
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-06
EDIFFG  = -0.02

IBRION  = 2
NSW     = 300
ISIF    = 3

ISPIN   = 2
MAGMOM  = 4*5.0 4*-5.0 12*0.6    # 4 Fe up, 4 Fe down, 12 O

ISMEAR  = 0
SIGMA   = 0.05
ALGO    = All
NELM    = 200
AMIX    = 0.2
BMIX    = 0.0001
AMIX_MAG = 0.8
BMIX_MAG = 0.00001

LORBIT  = 11
LWAVE   = .FALSE.
LCHARG  = .TRUE.
LREAL   = Auto
```

---

## Spin-Orbit Coupling (SOC)

### When SOC Matters

- Heavy elements (5d: Pt, Au, W, Bi, Pb; 4d to lesser extent)
- Topological materials (topological insulators, Weyl semimetals)
- Magnetic anisotropy energy (MAE)
- Band splitting in semiconductors (Rashba, Dresselhaus)
- Rare-earth compounds (4f elements)

### SOC Workflow (Two-Step Recommended)

**Step 1: Collinear pre-convergence**
```
ISPIN   = 2
MAGMOM  = 0.0 0.0 3.0    # collinear: 1 value per atom
LSORBIT = .FALSE.
# ... standard relaxation or static INCAR ...
# Save WAVECAR and CHGCAR
```

**Step 2: SOC calculation**
```
LSORBIT = .TRUE.           # enables SOC; auto-sets LNONCOLLINEAR=.TRUE.
MAGMOM  = 0 0 3.0  0 0 -3.0  0 0 0.0   # 3 components per atom (x, y, z)
SAXIS   = 0 0 1            # spin quantization axis (default z)
ISYM    = -1               # recommended: disable symmetry for SOC
LMAXMIX = 4                # d-elements; use 6 for f-elements
LORBMOM = .TRUE.           # print orbital moments
ICHARG  = 1                # read CHGCAR from collinear, then update self-consistently
                           # or ICHARG=11 for non-SCF MAE (faster but less accurate)

ALGO    = All              # robust for SOC
NELM    = 200
AMIX    = 0.2
BMIX    = 0.00001
AMIX_MAG = 0.8
BMIX_MAG = 0.00001

LORBIT  = 11
```

**Must use `vasp_ncl` executable** (not vasp_std or vasp_gam).

### MAGMOM Format for SOC

Collinear (LSORBIT=.FALSE.): 1 value per atom
```
MAGMOM = 3.0 -3.0 0.0    # 3 atoms
```

SOC (LSORBIT=.TRUE.): 3 values per atom (x, y, z components)
```
MAGMOM = 0 0 3.0  0 0 -3.0  0 0 0.0    # 3 atoms, moments along z
```

For moment along x: `3.0 0 0`; along [1,1,0]: `2.12 2.12 0`

### SAXIS: Spin Quantization Axis

SAXIS defines the reference direction for MAGMOM and the quantization axis for spin-orbit interaction.

| SAXIS | Meaning |
| --- | --- |
| `0 0 1` | z-axis (default) |
| `1 0 0` | x-axis |
| `0 1 0` | y-axis |
| `1 1 0` | [110] direction |

For magnetic anisotropy: run separate calculations with SAXIS along different crystal directions and compare total energies. The energy difference is the MAE.

### Magnetic Anisotropy Energy (MAE) Protocol

1. Fully relax structure with collinear spin (ISPIN=2).
2. Run static SCF with ISPIN=2; save WAVECAR + CHGCAR.
3. Run SOC with SAXIS = 0 0 1 (e.g., z-axis); ICHARG=11 or 1.
4. Run SOC with SAXIS = 1 0 0 (e.g., x-axis); same ICHARG.
5. MAE = E(hard axis) - E(easy axis). Typical values: 0.01–10 meV/atom.

Critical settings for MAE:
- Use same k-mesh and ENCUT for all directions
- ISYM=0 or -1 (k-point set must be identical for all SAXIS)
- Very tight EDIFF=1E-08 (MAE is often < 1 meV)
- Dense k-mesh (MAE converges slowly with k-points)

### Complete INCAR: Fe Surface with SOC

```
SYSTEM  = Fe-surface-SOC
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-08

IBRION  = -1
NSW     = 0
ICHARG  = 1              # read collinear CHGCAR, update self-consistently

LSORBIT = .TRUE.
MAGMOM  = 0 0 3.0  0 0 3.0  0 0 3.0  0 0 3.0  0 0 0  0 0 0
          # 4 Fe atoms moment along z, 2 vacuum-side atoms
SAXIS   = 0 0 1
ISYM    = -1
LMAXMIX = 4
LORBMOM = .TRUE.

ISMEAR  = 0
SIGMA   = 0.05
ALGO    = All
NELM    = 200
AMIX    = 0.2
BMIX    = 0.00001
AMIX_MAG = 0.8
BMIX_MAG = 0.00001

LORBIT  = 11
LWAVE   = .TRUE.         # save for MAE comparison runs
LCHARG  = .TRUE.
```

### Common SOC Pitfalls

1. **Forgetting vasp_ncl**: LSORBIT with vasp_std silently gives wrong results or crashes.
2. **MAGMOM format**: Must switch from 1-component to 3-component per atom.
3. **Symmetry**: Many space group operations are broken by SOC direction. Always use ISYM=0 or -1.
4. **LMAXMIX**: Default is 2 (s,p only). Must increase to 4 (d) or 6 (f) for proper charge mixing.
5. **Cost**: SOC doubles the basis (spin-up + spin-down coupled); expect 4–8x cost vs collinear.
