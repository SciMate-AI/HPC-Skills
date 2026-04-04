# VASP Pseudopotential, K-Points, and Convergence

## POTCAR Selection Rules

### Variant Suffixes

| Suffix | Meaning | When to use |
| --- | --- | --- |
| (none) | Standard; fewest valence electrons | Routine calculations where cost matters |
| `_pv` | p-electrons in valence | 3d transition metal oxides, magnetic systems, high-pressure |
| `_sv` | s and p semicore in valence | High accuracy; alkali/alkaline earth; all GW calculations |
| `_d` | d-electrons in valence | Post-transition metals (Ga, Ge, In, Sn) for better accuracy |
| `_h` / `_s` | Hard / soft | `_h` for hybrid functionals (more transferable); avoid `_s` for hybrids |
| `_GW` | Optimized for GW/unoccupied states | Many-body perturbation theory, optical properties |

### Recommended POTCAR Variants by Element

**3d transition metals (Sc–Zn):**

| Element | Routine DFT | Magnetic / oxide | GW / hybrid |
| --- | --- | --- | --- |
| Sc | Sc_sv | Sc_sv | Sc_sv_GW |
| Ti | Ti_pv | Ti_sv | Ti_sv_GW |
| V | V_pv | V_sv | V_sv_GW |
| Cr | Cr_pv | Cr_sv | Cr_sv_GW |
| Mn | Mn_pv | Mn_sv | Mn_sv_GW |
| Fe | Fe_pv | Fe_sv | Fe_sv_GW |
| Co | Co | Co_sv | Co_sv_GW |
| Ni | Ni_pv | Ni_pv | Ni_sv_GW |
| Cu | Cu_pv | Cu_pv | Cu_sv_GW |
| Zn | Zn | Zn | Zn_sv_GW |

**Common main-group elements:**

| Element | Routine DFT | GW / hybrid |
| --- | --- | --- |
| H | H | H_GW |
| C | C | C_GW |
| N | N | N_GW |
| O | O | O_h_GW (hard variant recommended) |
| F | F | F_GW |
| Si | Si | Si_GW |
| S | S | S_GW |
| P | P | P_GW |

**Alkali and alkaline earth:**

| Element | Routine DFT | GW |
| --- | --- | --- |
| Li | Li_sv | Li_sv_GW |
| Na | Na_pv | Na_sv_GW |
| K | K_sv | K_sv_GW |
| Mg | Mg_pv | Mg_sv_GW |
| Ca | Ca_sv | Ca_sv_GW |
| Ba | Ba_sv | Ba_sv_GW |

### POTCAR Coherence Rules

1. Species order in POTCAR must exactly match species order in POSCAR line 6.
2. Concatenate: `cat POTCAR_A POTCAR_B > POTCAR` in POSCAR species order.
3. Never mix PBE and LDA potentials in one calculation.
4. Verify: `grep TITEL POTCAR` should list elements in POSCAR order.
5. For volume relaxation: check `grep ENMAX POTCAR` and set ENCUT >= 1.3 * max(ENMAX).

## K-Point Density Guidelines

### KSPACING Quick Reference

| Accuracy level | KSPACING (A^-1) | Approx. k-points | Use case |
| --- | --- | --- | --- |
| Coarse | `0.5`–`0.4` | ~4x4x4 | Quick tests, pre-relaxation |
| Standard | `0.3`–`0.25` | ~6x6x6 | Production relaxation |
| Fine | `0.2`–`0.15` | ~10x10x10 | Static, DOS |
| Very fine | `0.1` | ~16x16x16 | Band structure reference, phonons |

The k-mesh dimensions are: N_i = max(1, ceiling(|b_i| * 2pi / KSPACING)).

### Monkhorst-Pack vs Gamma-Centered

| Grid type | When to use |
| --- | --- |
| Gamma-centered | Hexagonal cells (always); tetrahedron method (ISMEAR=-5); default safe choice |
| Monkhorst-Pack | Cubic / orthorhombic cells; standard for many workflows |

For hexagonal, rhombohedral, or FCC cells: always use Gamma-centered to avoid symmetry-breaking artifacts.

### K-Points for Special Cases

| Scenario | K-point strategy |
| --- | --- |
| Surface / slab | Dense in-plane (e.g. 8x8x1); 1 along vacuum direction |
| 1D system (nanotube, wire) | Dense along periodic direction; 1x1xN |
| Molecule in box | Gamma only (1x1x1) |
| Supercell | Scale inversely with supercell size: 2x2x2 supercell → halve k-mesh |
| DOS follow-on | 1.5–2x denser than relaxation mesh |
| Band structure | Line-mode k-path through high-symmetry points |

### Materials Project Standard Settings

For reference, the Materials Project uses:
- KSPACING adaptive based on band gap: 0.22 A^-1 (metals) to 0.44 A^-1 (large-gap insulators)
- Gamma-centered for hexagonal; Monkhorst-Pack otherwise
- Formation energy convergence target: 1 meV/atom

## Convergence Testing Protocol

### ENCUT Convergence

```
Step 1: grep ENMAX POTCAR  (find max ENMAX across all species)
Step 2: Create series of single-point calculations (NSW=0, IBRION=-1)
        with ENCUT = ENMAX, ENMAX+50, ENMAX+100, ..., 1.5*ENMAX
Step 3: Plot total energy vs ENCUT
Step 4: Choose ENCUT where energy changes < 1 meV/atom between steps
```

Rules of thumb:
- Default ENMAX gives < 10 meV error in cohesive energy
- 1.3 * ENMAX is safe for most production work
- For stress/elastic: need at least 1.5 * ENMAX

### K-Point Convergence

```
Step 1: Fix ENCUT at converged value
Step 2: Run single-point calculations with increasing k-mesh:
        4x4x4, 6x6x6, 8x8x8, 10x10x10, 12x12x12
Step 3: Plot total energy vs k-mesh density
Step 4: Choose mesh where energy changes < 1 meV/atom
```

### What to Converge Against

| Property | Convergence target |
| --- | --- |
| Total energy (relative) | 1 meV/atom |
| Forces | 5 meV/A |
| Stress tensor | 0.5 kbar |
| Band gap | 10 meV |
| Magnetic moment | 0.01 muB |

### Common Convergence Pitfalls

- Energy differences (e.g. adsorption energy) converge faster than absolute energies — use consistent settings across all calculations being compared.
- Magnetic systems may converge to different magnetic states at different k-meshes — check MAGMOM in OUTCAR.
- Pulay stress from insufficient ENCUT causes systematic error in optimized lattice constants; always use ENCUT >= 1.3*ENMAX for ISIF=3.
