# VASP Defect Calculation Recipes

## Defect Formation Energy

The formation energy of a defect X in charge state q:

```
E_f[X^q] = E_tot[X^q] - E_tot[bulk] - sum(n_i * mu_i) + q * (E_VBM + E_Fermi) + E_corr
```

Where:
- E_tot[X^q] = total energy of defect supercell
- E_tot[bulk] = total energy of perfect supercell (same size)
- n_i = number of atoms added (+) or removed (-) of species i
- mu_i = chemical potential of species i
- E_VBM = valence band maximum of bulk
- E_Fermi = Fermi level relative to VBM (0 to band gap)
- E_corr = finite-size correction for charged defects

## Neutral Defect Workflow

### Step 1: Converge Bulk Unit Cell

Standard relaxation with tight convergence:
```
EDIFFG = -0.005    # forces < 5 meV/A
ISIF   = 3         # full cell relaxation
```

### Step 2: Build Supercell

- Minimum: 64 atoms (2x2x2 of 8-atom cell); preferred: 128–256 atoms
- Larger supercell = smaller defect-defect interaction
- Create defect: remove atom (vacancy), add atom (interstitial), or substitute

### Step 3: Relax Defect Supercell

```
SYSTEM  = defect-neutral
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-06
EDIFFG  = -0.02

IBRION  = 2
NSW     = 300
ISIF    = 2               # relax ions only; fix cell to bulk lattice constant

ISMEAR  = 0
SIGMA   = 0.05
LREAL   = Auto
LWAVE   = .FALSE.
LCHARG  = .TRUE.
```

**ISIF=2 is critical**: The supercell shape and volume must match the bulk reference exactly.

## Charged Defect Workflow

### Modifying Electron Count

Add or remove electrons via NELECT:

```
# Find default NELECT:
grep NELECT OUTCAR     # from a neutral calculation

# For charge state q:
NELECT = NELECT_neutral - q
# q = +1 → remove 1 electron → NELECT = default - 1
# q = -1 → add 1 electron    → NELECT = default + 1
# q = +2 → remove 2 electrons → NELECT = default - 2
```

VASP automatically adds a uniform jellium background to maintain charge neutrality.

### INCAR for Charged Defect

```
SYSTEM  = defect-charged-q+1
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-06
EDIFFG  = -0.02

IBRION  = 2
NSW     = 300
ISIF    = 2

NELECT  = 255             # default-1 for q=+1 (example)
ISMEAR  = 0
SIGMA   = 0.05

LVHAR   = .TRUE.          # write LOCPOT for electrostatic correction
LREAL   = Auto
LWAVE   = .FALSE.
LCHARG  = .TRUE.
LORBIT  = 11
```

### Spin State Control

For defects with unpaired electrons, control the spin state:

```
ISPIN   = 2
NUPDOWN = 1               # for doublet state (1 unpaired electron)
# or
NUPDOWN = 2               # for triplet state
```

NUPDOWN fixes the total magnetization. If unsure, run without NUPDOWN and check if correct spin state is found.

## Finite-Size Corrections

Charged defects in periodic supercells have spurious electrostatic interactions. Corrections are essential.

### Correction Schemes

| Scheme | Acronym | Accuracy | Notes |
| --- | --- | --- | --- |
| Makov-Payne | MP | Low | Only monopole+quadrupole; overcorrects for non-point-charge defects |
| Freysoldt-Neugebauer-Van de Walle | FNV | **Good** | Recommended for most cases; uses planar-averaged potential |
| Lany-Zunger | LZ | Good | Simpler than FNV; 2/3 of Madelung correction |
| Kumagai-Oba | KO | Best | Extension of FNV for anisotropic cells |

### Requirements for FNV Correction

1. Run defect calculation with `LVHAR=.TRUE.` (writes LOCPOT).
2. Run bulk reference (perfect supercell, same size) with `LVHAR=.TRUE.`.
3. Compute dielectric constant of bulk (LEPSILON=.TRUE. or from experiment).
4. Apply correction using a tool:

```bash
# Using pydefect:
pydefect corrections --defect_entry defect/ --perfect perfect/ --dielectric 10.0

# Using doped:
# Automated within the doped workflow

# Using sxdefectalign (Freysoldt's original tool):
sxdefectalign --vasp -a1 LOCPOT_defect -a2 LOCPOT_bulk --charge 1 --epsilon 10.0
```

### Dielectric Constant Calculation

Required for finite-size corrections:

```
IBRION  = 8               # DFPT for dielectric tensor
LEPSILON = .TRUE.          # compute static dielectric constant
NSW     = 1
EDIFF   = 1E-08
LREAL   = .FALSE.
```

Result: `grep "MACROSCOPIC STATIC" OUTCAR`

## Chemical Potentials

Chemical potentials (mu_i) define the thermodynamic conditions:

- **Metal-rich (element-rich)**: mu_element = E_element_bulk (per atom)
- **Oxide-rich (O-rich)**: mu_O = 1/2 * E_O2
- **Thermodynamic limits**: Constrained by formation enthalpy of the host compound

Example for ZnO:
- Zn-rich: mu_Zn = E_Zn_bulk; mu_O = (E_ZnO - mu_Zn)
- O-rich: mu_O = 1/2 * E_O2; mu_Zn = (E_ZnO - mu_O)

## Defect Level Identification

To identify defect levels in the band gap:

1. Plot site-projected DOS (LORBIT=11) near the defect.
2. Compare with bulk DOS to identify in-gap states.
3. Charge transition level: epsilon(q1/q2) = [E_f(q1) - E_f(q2)] / (q2 - q1)

## Recommended Tools

| Tool | Purpose | Link |
| --- | --- | --- |
| doped | Full defect workflow automation | github.com/SMTG-Bham/doped |
| pydefect | Defect analysis and corrections | github.com/kumagai-group/pydefect |
| PyCDT | Legacy defect toolkit | github.com/mbkumar/pycdt |
| Spinney | Finite-size corrections | |
| VESTA | Visualize defect structures | jp-minerals.org/vesta |

## Common Defect Calculation Pitfalls

1. **ISIF=3 for defect supercell**: Cell must match bulk exactly; use ISIF=2.
2. **Too small supercell**: <64 atoms gives large finite-size errors even with corrections.
3. **Missing LVHAR**: Cannot compute FNV correction without LOCPOT.
4. **Inconsistent settings**: Defect and bulk reference must use identical ENCUT, KPOINTS, POTCAR.
5. **Wrong NELECT**: Double-check by comparing with neutral OUTCAR NELECT.
6. **Ignoring spin state**: Charged defects often have unpaired electrons; set ISPIN=2.
7. **Skipping corrections**: Uncorrected charged defect energies can be wrong by 0.5–2 eV.
