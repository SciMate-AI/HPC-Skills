# VASP Surface and Slab Recipes

## Slab Model Construction

### Geometry Principles

- **Vacuum layer**: 10–15 A minimum between periodic slab images. 12 A is a safe default.
- **Slab thickness**: Converge slab thickness separately. Typically 4–7 layers for metals, 6–10 for oxides.
- **Vacuum direction**: Conventional choice is z (third lattice vector).
- **Symmetric vs asymmetric**: Symmetric slabs (same termination top and bottom) avoid net dipole. Asymmetric slabs require dipole correction.

### POSCAR Setup

```
Surface slab example
1.0
  3.520  0.000  0.000        # a: in-plane lattice vector 1
  0.000  3.520  0.000        # b: in-plane lattice vector 2
  0.000  0.000  25.000       # c: out-of-plane (includes vacuum)
Fe
5
Selective dynamics                # enable selective dynamics
Direct
  0.000  0.000  0.200  F F F    # bottom layer: frozen
  0.000  0.000  0.280  F F F    # second layer: frozen
  0.500  0.500  0.360  T T T    # middle layer: free
  0.000  0.000  0.440  T T T    # fourth layer: free
  0.500  0.500  0.520  T T T    # top layer: free
```

Selective dynamics rules:
- Fix bottom 2–3 layers (bulk-like); free top 2–3 layers (surface-like).
- `T T T` = atom free to move in x, y, z.
- `F F F` = atom frozen.
- For symmetric slabs: fix only the central layer(s), free both surfaces.

## INCAR for Surface Relaxation

```
SYSTEM  = surface-relaxation
PREC    = Accurate
ENCUT   = 520              # >= 1.3*max(ENMAX) not needed since ISIF=2 (no cell change)
EDIFF   = 1E-06
EDIFFG  = -0.02

IBRION  = 2
NSW     = 300
ISIF    = 2                # CRITICAL: relax ions only, fix cell shape and volume

ISMEAR  = 0                # Gaussian; not MP smearing for surfaces
SIGMA   = 0.05

# Dipole correction (for asymmetric slabs or adsorption)
LDIPOL  = .TRUE.           # correct potential and forces for dipole
IDIPOL  = 3                # correction along z (vacuum direction)
DIPOL   = 0.5 0.5 0.35    # fractional coords of slab center of mass

LREAL   = Auto
LWAVE   = .FALSE.
LCHARG  = .TRUE.
LORBIT  = 11
```

### ISIF Rules for Surfaces

| ISIF | Behavior | Correct for surface? |
| --- | --- | --- |
| `0` | Relax ions, no stress tensor | OK but no stress info |
| `2` | Relax ions, compute stress tensor | **Standard choice** |
| `3` | Relax everything | **WRONG**: vacuum layer will collapse |
| `4` | Relax ions + cell shape, fixed volume | **WRONG**: shape change distorts slab |

Always use ISIF=2 for surfaces and slabs.

## Dipole Correction

### When to Use

- Asymmetric slabs (different top and bottom termination)
- Adsorption on one side of the slab
- Charged surfaces
- Work function calculations (even for symmetric slabs, improves accuracy)

### Setup

```
LDIPOL  = .TRUE.
IDIPOL  = 3                # 1=x, 2=y, 3=z; use 3 for standard slab with vacuum along z
DIPOL   = 0.5 0.5 z_center # fractional coordinates of the slab center of mass
```

**DIPOL value**: Set to the fractional coordinate of the slab center along z. For a slab centered at z=0.35 in fractional coordinates: `DIPOL = 0.5 0.5 0.35`. This places the potential step in the middle of the vacuum region.

### Pre-convergence Warning

The VASP wiki recommends pre-converging wavefunctions WITHOUT LDIPOL first, then adding the dipole correction. This improves convergence stability for asymmetric slabs.

## K-Points for Surfaces

| Direction | K-points | Rationale |
| --- | --- | --- |
| In-plane (a, b) | Dense: 8x8 to 12x12 | Surface electronic structure needs good sampling |
| Out-of-plane (c) | 1 | No dispersion along vacuum direction |

Example KPOINTS:
```
Automatic mesh
0
Gamma
8 8 1
0 0 0
```

For hexagonal surfaces: always use Gamma-centered mesh.

## Adsorption Energy Workflow

### Protocol

1. **Relax clean slab** (E_slab)
2. **Relax gas-phase molecule** in large box (E_molecule)
   - Box size: 15x16x17 A (break symmetry)
   - ISMEAR=0, SIGMA=0.01
   - Gamma-only k-point
3. **Relax molecule on slab** (E_slab+mol)
4. **Adsorption energy**: E_ads = E_slab+mol - E_slab - E_molecule

### Consistency Requirements

- Same ENCUT, PREC, POTCAR for all three calculations.
- Same KPOINTS for slab and slab+molecule (Gamma for molecule).
- Include van der Waals correction (IVDW=12 for DFT-D3) if physisorption matters.
- Use dipole correction for slab+molecule if adsorption is on one side only.

## Work Function Calculation

The work function is: phi = V_vacuum - E_Fermi

### Protocol

1. Run static SCF on relaxed slab with LVHAR=.TRUE. (writes LOCPOT).
2. Average the electrostatic potential along z using a tool (VASPKIT, pymatgen, or custom script).
3. V_vacuum = plateau value in the vacuum region.
4. E_Fermi = from OUTCAR (`grep "E-fermi" OUTCAR`).

### Additional INCAR tags

```
LVHAR   = .TRUE.           # write LOCPOT (electrostatic potential)
LDIPOL  = .TRUE.           # dipole correction for accurate vacuum level
IDIPOL  = 3
```

## Surface Energy Calculation

Surface energy: gamma = (E_slab - N * E_bulk) / (2 * A)

Where:
- E_slab = total energy of slab (both surfaces)
- N = number of formula units in slab
- E_bulk = energy per formula unit in bulk
- A = surface area (a x b for orthogonal cell)
- Factor of 2 because slab has two surfaces

Requires convergence tests on both slab thickness and vacuum layer.

## Common Surface Pitfalls

1. **ISIF=3 on a slab**: Vacuum collapses. Always ISIF=2.
2. **MP smearing on surface**: ISMEAR > 0 can give wrong forces for gapped surfaces. Use ISMEAR=0.
3. **Too thin vacuum**: Slab-slab interaction. Check that LOCPOT reaches a flat plateau in vacuum.
4. **Frozen wrong layers**: Fix bottom layers (bulk-like), free top layers (surface).
5. **Missing dipole correction**: Asymmetric slabs or adsorption without LDIPOL gives wrong forces and energies.
6. **DIPOL value wrong**: Must be at the center of the slab, not center of the cell.
7. **k-points along vacuum**: Use 1 k-point in the z-direction; more is wasteful and may cause artifacts.
