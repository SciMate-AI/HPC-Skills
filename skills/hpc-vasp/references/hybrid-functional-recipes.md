# VASP Hybrid Functional Recipes

## HSE06 Setup

HSE06 is the most widely used screened hybrid functional. It mixes 25% short-range exact exchange with PBE.

### Minimal INCAR Tags

```
LHFCALC  = .TRUE.         # enable Hartree-Fock / hybrid exchange
HFSCREEN = 0.2            # screening parameter (1/A); 0.2 = HSE06, 0.3 = HSE03
# AEXX defaults to 0.25 — no need to set explicitly for standard HSE06
```

### Recommended Complete INCAR: HSE06 Static

```
SYSTEM   = hse06-static
PREC     = Accurate
ENCUT    = 520
EDIFF    = 1E-06

IBRION   = -1
NSW      = 0

LHFCALC  = .TRUE.
HFSCREEN = 0.2
ALGO     = Damped          # most robust for hybrids; or All (faster if it converges)
TIME     = 0.4             # step size for Damped/All algorithm
PRECFOCK = Fast            # FFT precision for Fock exchange; Fast is usually sufficient

ISMEAR   = 0
SIGMA    = 0.05
ISYM     = 3               # use symmetry of charge density (recommended for hybrids)
NELM     = 200             # hybrids need more SCF steps

LWAVE    = .TRUE.          # save for band structure follow-on
LCHARG   = .TRUE.
LORBIT   = 11
```

### PBE0 Setup

PBE0 uses unscreened 25% exact exchange (no range separation):

```
LHFCALC  = .TRUE.
# Do NOT set HFSCREEN (or set HFSCREEN = 0)
ALGO     = Damped
TIME     = 0.4
```

PBE0 is more expensive than HSE06 due to slow convergence of unscreened exchange.

### Functional Comparison

| Functional | LHFCALC | HFSCREEN | AEXX | Cost vs PBE | Band gap accuracy |
| --- | --- | --- | --- | --- | --- |
| PBE (GGA) | .FALSE. | — | — | 1x | Underestimates 30–50% |
| HSE06 | .TRUE. | 0.2 | 0.25 | 20–100x | Good for most semiconductors |
| HSE03 | .TRUE. | 0.3 | 0.25 | 20–80x | Similar to HSE06 |
| PBE0 | .TRUE. | 0 | 0.25 | 50–200x | Overestimates for small-gap systems |

## Pre-Convergence Strategy (Critical for Cost)

Hybrid calculations are 20–100x more expensive than GGA. Always pre-converge with PBE:

```
Step 1: Run PBE static → save WAVECAR
Step 2: Add hybrid tags to INCAR
Step 3: Set ISTART=1 (reads PBE WAVECAR as starting point)
Step 4: Run HSE06
```

This reduces HSE06 SCF iterations from ~100+ to ~20–40.

## ALGO Selection for Hybrids

| ALGO | Behavior | When to use |
| --- | --- | --- |
| `Damped` | Damped velocity Verlet; most robust | Default choice; always works |
| `All` | Conjugate gradient | Faster than Damped; use if it converges |
| `Normal` | Blocked Davidson | May fail for hybrids; not recommended |

If ALGO=All diverges, fall back to ALGO=Damped with TIME=0.4.
If ALGO=Damped converges slowly, try reducing TIME to 0.2.

## Band Structure with HSE06

ICHARG=11 (non-SCF) is problematic with hybrid functionals. Use the zero-weight k-points method:

### Protocol

```
Step 1: Run self-consistent HSE06 with standard k-mesh.
Step 2: Copy IBZKPT to KPOINTS.
Step 3: Append band-path k-points at the end of KPOINTS with weight = 0.
Step 4: Increase NBANDS slightly (extra k-points need bands allocated).
Step 5: Run self-consistently (do NOT use ICHARG=11).
Step 6: Extract band eigenvalues from vasprun.xml.
```

### Modified KPOINTS file format

```
Explicit k-points
<N_original + N_band_path>
Reciprocal
0.000  0.000  0.000   <weight_1>    # original k-points from IBZKPT
0.500  0.000  0.000   <weight_2>
...
0.000  0.000  0.000   0.000         # band path: Gamma (zero weight)
0.125  0.000  0.000   0.000
0.250  0.000  0.000   0.000
0.375  0.000  0.000   0.000
0.500  0.000  0.000   0.000         # band path: X (zero weight)
...
```

## Tuning AEXX for Band Gap Fitting

The default AEXX=0.25 works well for most semiconductors. For specific materials where the band gap is poorly reproduced:

```
AEXX = 0.30     # increase exact exchange → larger band gap
AEXX = 0.40     # often needed for wide-gap oxides (ZnO, TiO2)
AEXX = 0.20     # decrease for narrow-gap systems
```

Keep HFSCREEN=0.2 fixed when tuning AEXX.

Typical tuned AEXX values from literature:
| Material | AEXX | Gap (eV) |
| --- | --- | --- |
| Si | 0.25 | 1.15 (exp: 1.17) |
| GaAs | 0.25 | 1.12 (exp: 1.52) — may need 0.30 |
| ZnO | 0.37 | 3.4 (exp: 3.44) |
| TiO2 (rutile) | 0.25 | 3.0 (exp: 3.0) |
| NiO | 0.25 + U | 3.5–4.3 depending on U |

## HSE06 + Relaxation

Hybrid relaxation is expensive but sometimes necessary (e.g., defect geometry):

```
LHFCALC  = .TRUE.
HFSCREEN = 0.2
ALGO     = Damped
TIME     = 0.4
PRECFOCK = Fast

IBRION   = 2
NSW      = 100
ISIF     = 2             # or 3 for bulk
EDIFFG   = -0.03         # slightly looser force criterion to save cost
```

Cost-saving tip: relax with PBE first, then refine with HSE06 for only ~10–20 more ionic steps.

## PRECFOCK: Fock Exchange Precision

| PRECFOCK | FFT grid for HF | Speed | Accuracy |
| --- | --- | --- | --- |
| `Fast` | Coarser | Fastest | Sufficient for most applications |
| `Normal` | Standard | Moderate | Better for accurate forces |
| `Accurate` | Fine | Slowest | Only for benchmarking |

Use PRECFOCK=Fast for routine work. Switch to Normal if forces in hybrid relaxation seem noisy.

## Common Hybrid Pitfalls

1. **Forgetting PBE pre-convergence**: Starting hybrid from scratch is 5–10x slower.
2. **Using ALGO=Normal**: Will likely fail; always use Damped or All.
3. **Using ICHARG=11 for bands**: Gives wrong bands with hybrids; use zero-weight k-points.
4. **Soft POTCARs (_s)**: Less transferable with exact exchange; use standard or _h POTCARs.
5. **ISYM setting**: Use ISYM=3 for hybrids (symmetrize charge density, not wavefunctions).
6. **Insufficient NELM**: Hybrids converge slowly; set NELM=200 minimum.
