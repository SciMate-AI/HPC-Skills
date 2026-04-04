# VASP Restarts, Spin, and Wavefunction Files

## Restart Files Reference

| File | Contents | Size | Purpose |
| --- | --- | --- | --- |
| `WAVECAR` | Wavefunctions | Large (100 MB – 10+ GB) | Restart SCF from prior orbitals; essential for hybrid/GW continuations |
| `CHGCAR` | Charge density | Medium (10–500 MB) | Restart from prior charge; needed for DOS/bands (ICHARG=11) |
| `CONTCAR` | Final ionic positions | Small (KB) | Copy to POSCAR for next relaxation stage |
| `OUTCAR` | Full calculation log | Large | Diagnostic; grep for convergence, forces, timing |
| `vasprun.xml` | Machine-readable output | Large | Post-processing with pymatgen, ASE, phonopy |
| `IBZKPT` | Irreducible k-points | Small | Template for zero-weight k-points method |

## ISTART: Wavefunction Initialization

| ISTART | Behavior | When to use |
| --- | --- | --- |
| `0` | Start from scratch (random wavefunctions) | First calculation; no WAVECAR exists |
| `1` | Continue from WAVECAR (same ENCUT) | Continuation of interrupted calculation |
| `2` | Restart from WAVECAR (different ENCUT allowed) | Changing basis set; less common |

VASP auto-detects: if WAVECAR exists and is valid, ISTART defaults to 1. To force a fresh start, either set ISTART=0 or remove WAVECAR.

## ICHARG: Charge Density Initialization

| ICHARG | Behavior | When to use |
| --- | --- | --- |
| `0` | Charge from wavefunctions | Default when ISTART > 0 (WAVECAR exists) |
| `1` | Read CHGCAR, then update self-consistently | Restart from pre-converged charge |
| `2` | Superposition of atomic charges | Default when ISTART=0 (fresh start); standard for relaxation |
| `11` | Read CHGCAR, keep fixed (non-SCF) | DOS and band structure post-processing |

Critical rules:
- ICHARG=11 means the charge is NOT updated — use only for post-processing.
- ICHARG=11 is unreliable for DFT+U and hybrid functionals; use zero-weight k-points instead.
- When changing k-mesh substantially, avoid ICHARG=1 — the charge may not interpolate well.

## Stage Handoff Patterns

### Relaxation → Static

```bash
cp CONTCAR POSCAR       # use optimized geometry
# Keep CHGCAR for charge continuity (optional but faster)
# Edit INCAR for static: IBRION=-1, NSW=0, ISMEAR=-5
```

### Static → DOS

```bash
# Keep CHGCAR from static (required for ICHARG=11)
# Edit INCAR: add ICHARG=11, ISMEAR=-5, NEDOS=2001, LORBIT=11
# Create denser KPOINTS (1.5-2x static mesh, Gamma-centered)
```

### Static → Band Structure

```bash
# Keep CHGCAR from static (required for ICHARG=11)
# Edit INCAR: add ICHARG=11, ISMEAR=0, SIGMA=0.05
# Replace KPOINTS with line-mode high-symmetry path
```

### PBE → Hybrid (HSE06)

```bash
# Keep WAVECAR from PBE (speeds up hybrid convergence dramatically)
# Edit INCAR: add LHFCALC=.TRUE., HFSCREEN=0.2, ALGO=Damped, TIME=0.4
# Do NOT use ICHARG=11 — run self-consistently
```

### Collinear → SOC

```bash
# Keep WAVECAR and CHGCAR from collinear spin-polarized calculation
# Edit INCAR: add LSORBIT=.TRUE., ISYM=0, LMAXMIX=4
# Change MAGMOM to 3-component form: "0 0 3.0" per atom
# Use vasp_ncl executable instead of vasp_std
```

## Spin and Magnetization Setup

### Collinear Spin (ISPIN=2)

```
ISPIN  = 2
MAGMOM = 3.0 3.0 -3.0 -3.0 0.0 0.0    # one value per atom
```

MAGMOM initialization guidelines:

| Element | Typical initial MAGMOM | Notes |
| --- | --- | --- |
| Fe | 3.0 – 5.0 | BCC Fe: ~2.2 muB converged |
| Co | 2.0 – 3.0 | HCP Co: ~1.7 muB converged |
| Ni | 1.0 – 2.0 | FCC Ni: ~0.6 muB converged |
| Mn | 4.0 – 5.0 | Highly variable; can be AFM |
| Cr | 3.0 – 4.0 | Often AFM |
| O (in oxide) | 0.0 – 0.6 | Small induced moment possible |
| Non-magnetic | 0.0 | C, Si, Al, etc. |

Rules:
- Always start with MAGMOM larger than expected converged value; VASP will relax to correct moment.
- For antiferromagnetic ordering: alternate signs (e.g., `5.0 -5.0 5.0 -5.0` for Mn atoms in AFM).
- Shorthand syntax: `MAGMOM = 4*3.0 2*0.0` means 4 atoms with 3.0, 2 atoms with 0.0.
- MAGMOM must have exactly NIONS values (one per atom in POSCAR).
- If restarting from WAVECAR, MAGMOM is only used for symmetry detection — the actual magnetic state comes from the wavefunction.

### Noncollinear / SOC (LSORBIT=.TRUE.)

```
LSORBIT    = .TRUE.       # enables SOC; auto-sets LNONCOLLINEAR=.TRUE.
MAGMOM     = 0 0 3.0  0 0 -3.0  0 0 0.0    # 3 components (x,y,z) per atom
SAXIS      = 0 0 1        # quantization axis (default: z)
ISYM       = 0            # disable symmetry (recommended for SOC)
LMAXMIX    = 4            # d-elements; use 6 for f-elements
LORBMOM    = .TRUE.       # print orbital moments
```

Must use `vasp_ncl` executable. See `magnetic-and-soc-recipes.md` for full workflow.

## Practical Continuation Rules

1. **Always copy CONTCAR to POSCAR** when continuing a relaxation or starting a follow-on stage.
2. **Keep WAVECAR** if: continuing same calculation, switching to hybrid from GGA, or GW.
3. **Keep CHGCAR** if: doing DOS, bands, or charge-density analysis.
4. **Delete WAVECAR** if: k-mesh changed substantially, or switching between collinear and SOC.
5. **Check file compatibility**: WAVECAR encodes ENCUT, NBANDS, k-mesh. If any changed, ISTART=1 may fail — use ISTART=0 or adjust.

## File Size Estimation

| System size | WAVECAR | CHGCAR | Notes |
| --- | --- | --- | --- |
| 2 atoms, 6x6x6 k | ~50 MB | ~2 MB | Small bulk |
| 50 atoms, 2x2x1 k | ~200 MB | ~20 MB | Surface slab |
| 200 atoms, Gamma | ~500 MB | ~50 MB | Large supercell |
| Hybrid + many bands | ~2–10 GB | ~50 MB | HSE06 is expensive |

Set LWAVE=.FALSE. and LCHARG=.FALSE. to skip writing these files when not needed for follow-on stages.
