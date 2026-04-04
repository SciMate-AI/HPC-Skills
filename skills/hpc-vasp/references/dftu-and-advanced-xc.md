# VASP DFT+U and Advanced Exchange-Correlation Recipes

## DFT+U (Hubbard U Correction)

### When to Use DFT+U

- Transition metal oxides where GGA incorrectly delocalizes d-electrons
- Rare-earth compounds with f-electrons
- Systems where GGA gives metallic behavior but experiment shows insulator (e.g., NiO, FeO, MnO)
- Band gap correction for strongly correlated systems

### Minimal INCAR Setup (Dudarev Method)

```
LDAU     = .TRUE.          # enable DFT+U
LDAUTYPE = 2               # Dudarev (simplified; only U_eff = U - J matters)
LDAUL    = 2 -1            # l quantum number: 2=d-electrons, -1=no correction
LDAUU    = 5.0 0.0         # U value (eV) for each species
LDAUJ    = 0.0 0.0         # J value (eV); for LDAUTYPE=2, only U-J matters
LMAXMIX  = 4               # CRITICAL: must be 4 for d-elements, 6 for f-elements
```

Tag value ordering follows POTCAR/POSCAR species order.

### LDAUTYPE Variants

| LDAUTYPE | Method | Notes |
| --- | --- | --- |
| `1` | Liechtenstein et al. | Full rotationally invariant; U and J independent |
| `2` | Dudarev et al. | **Most common**; only U_eff = U - J matters |
| `3` | Linear response | For computing U self-consistently |
| `4` | Like 1 but no exchange | Special cases |

### Common U Values from Literature

**3d Transition Metal Oxides (LDAUTYPE=2, applied to d-orbitals):**

| System | Element | U_eff (eV) | Source |
| --- | --- | --- | --- |
| Fe2O3 | Fe(III) | 4.0 – 5.3 | Materials Project: 5.3 |
| FeO | Fe(II) | 4.0 – 5.3 | Materials Project: 5.3 |
| NiO | Ni(II) | 6.0 – 6.4 | Materials Project: 6.2 |
| MnO | Mn(II) | 3.9 | Materials Project: 3.9 |
| CoO | Co(II) | 3.3 – 3.5 | Materials Project: 3.32 |
| Cr2O3 | Cr(III) | 3.5 – 3.7 | Materials Project: 3.7 |
| V2O5 | V(V) | 3.1 – 3.25 | Materials Project: 3.25 |
| TiO2 | Ti(IV) | 3.0 – 4.0 | Materials Project: 0 (no U for Ti d0) |
| CuO | Cu(II) | 5.0 – 7.0 | |
| ZnO | Zn(II) | 4.0 – 6.0 | U applied to Zn-3d |

**4f Rare-Earth (applied to f-orbitals, LDAUL=3):**

| System | Element | U_eff (eV) | Notes |
| --- | --- | --- | --- |
| CeO2 | Ce(IV) | 4.5 – 5.5 | LMAXMIX=6 required |
| Gd2O3 | Gd(III) | 6.0 – 7.0 | LMAXMIX=6 required |

**Important**: U values are not universal constants. They depend on:
- Oxidation state and coordination environment
- Choice of POTCAR (standard vs _pv vs _sv)
- LDAUTYPE
- DFT functional used (PBE vs SCAN)

### Complete INCAR: NiO with DFT+U

```
SYSTEM   = NiO-GGA+U
PREC     = Accurate
ENCUT    = 520
EDIFF    = 1E-06
EDIFFG   = -0.02

IBRION   = 2
NSW      = 200
ISIF     = 3

ISPIN    = 2
MAGMOM   = 2*2.0 2*-2.0 4*0.6    # AFM Ni, O with small moment

LDAU     = .TRUE.
LDAUTYPE = 2
LDAUL    = 2 -1              # Ni: d-correction, O: none
LDAUU    = 6.2 0.0
LDAUJ    = 0.0 0.0
LMAXMIX  = 4

ISMEAR   = 0
SIGMA    = 0.05
ALGO     = All
NELM     = 200
AMIX     = 0.1
BMIX     = 0.00001

LORBIT   = 11
LREAL    = Auto
```

### DFT+U Convergence Tips

1. Use ALGO=All (more robust for DFT+U than Fast).
2. Reduce AMIX=0.1, BMIX=0.00001 (charge density more sensitive with U).
3. Start from pre-converged GGA (no U) WAVECAR, then add U.
4. LMAXMIX=4 is essential; without it, d-orbital occupancies are incorrectly mixed.
5. For band structure with DFT+U: do NOT use ICHARG=11. Use zero-weight k-points method.

---

## Van der Waals Corrections

### Empirical Pairwise Corrections (IVDW)

| IVDW | Method | When to use |
| --- | --- | --- |
| `10` | DFT-D2 (Grimme) | Legacy; superseded by D3 |
| `11` | DFT-D3 (zero damping) | Good general-purpose vdW correction |
| `12` | DFT-D3-BJ (Becke-Johnson damping) | **Recommended default** for most systems |
| `2` | Tkatchenko-Scheffler (TS) | Better for molecular systems; environment-dependent |
| `20` | TS with iterative Hirshfeld | Improved TS |

### Minimal INCAR for DFT-D3-BJ

```
IVDW = 12                  # DFT-D3 with Becke-Johnson damping
```

That is it. No other tags needed. Works with any GGA/meta-GGA functional.

### When to Use vdW Corrections

- Layered materials (graphite, MoS2, BN)
- Molecular adsorption on surfaces
- Molecular crystals
- Weak intermolecular interactions
- Biomolecules on surfaces

### Nonlocal vdW-DF Functionals (LUSE_VDW)

These replace the correlation functional with a nonlocal kernel — more physical than empirical corrections.

**optB88-vdW** (popular for solids):
```
GGA      = BO
PARAM1   = 0.1833333333
PARAM2   = 0.22
AGGAC    = 0.0            # remove PBE correlation
LUSE_VDW = .TRUE.         # enable nonlocal vdW correlation
LASPH    = .TRUE.         # aspherical contributions (recommended)
```

**optPBE-vdW:**
```
GGA      = OR
AGGAC    = 0.0
LUSE_VDW = .TRUE.
LASPH    = .TRUE.
```

**SCAN+rVV10** (state-of-the-art meta-GGA + vdW):
```
METAGGA  = SCAN
LUSE_VDW = .TRUE.
BPARAM   = 15.7
CPARAM   = 0.0093
LASPH    = .TRUE.
```

### vdW-DF Requirements

- Place `vdw_kernel.bindat` in the calculation directory (or VASP will generate it, which takes hours).
- PBE or LDA POTCARs are fine — no special POTCARs needed.
- Set LASPH=.TRUE. for non-spherical density contributions.

---

## Meta-GGA Functionals (SCAN, r2SCAN)

### SCAN

```
METAGGA  = SCAN
ALGO     = All            # SCAN often needs robust algorithm
LASPH    = .TRUE.         # essential for meta-GGA accuracy
LMIXTAU  = .TRUE.         # mix kinetic energy density (VASP 6+)
```

### r2SCAN (regularized SCAN, more stable)

```
METAGGA  = R2SCAN
ALGO     = All
LASPH    = .TRUE.
LMIXTAU  = .TRUE.
```

### Meta-GGA Notes

- Meta-GGAs are more accurate than GGA for many properties but ~2x more expensive.
- SCAN/r2SCAN often fix GGA's over-delocalization without needing +U.
- For SCAN+U: combine METAGGA=SCAN with LDAU=.TRUE.
- r2SCAN is numerically more stable than SCAN and recommended as default.
