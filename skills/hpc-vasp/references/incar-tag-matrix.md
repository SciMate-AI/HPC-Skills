# VASP INCAR Tag Matrix

Concrete parameter values and decision tables for every major INCAR tag group.

## Smearing: ISMEAR and SIGMA

| System class | ISMEAR | SIGMA | Rationale |
| --- | --- | --- | --- |
| Insulator / semiconductor (relaxation) | `0` (Gaussian) | `0.05` | Safe default; works for gapped systems |
| Insulator / semiconductor (static DOS) | `-5` (tetrahedron with Blochl corrections) | — | Exact integration; requires Gamma-centered k-mesh |
| Metal (relaxation) | `1` (Methfessel-Paxton order 1) | `0.2` | MP smearing handles partial occupancies at Fermi level |
| Metal (static DOS) | `-5` (tetrahedron) | — | Accurate DOS; needs dense k-mesh (entropy term T*S must be < 1 meV/atom) |
| Surface / slab | `0` (Gaussian) | `0.05` | Vacuum region makes MP smearing unreliable |
| Molecule in box | `0` (Gaussian) | `0.01` | Discrete levels; keep SIGMA very small |
| Molecular dynamics | `0` (Gaussian) | `0.05`–`0.1` | Tetrahedron not available for single-k or Gamma-only |

Rules:
- If using ISMEAR > 0 (MP), check entropy term `T*S` in OUTCAR. If > 1 meV/atom, reduce SIGMA.
- Tetrahedron method (ISMEAR=-5) requires >= 3 k-points in each direction and Gamma-centered mesh.
- Never use ISMEAR=-5 for relaxation — forces are wrong with tetrahedron method.
- ISMEAR=0 with SIGMA=0.05 is the universal safe fallback ("works almost always" per VASP wiki).

## Electronic Algorithm: ALGO

| Scenario | ALGO | Notes |
| --- | --- | --- |
| Standard DFT (default) | `Normal` | Blocked Davidson; robust for most systems |
| Fast convergence (metals, large systems) | `Fast` | Davidson + RMM-DIIS hybrid; good balance of speed and stability |
| Difficult convergence (magnetic, small gap) | `All` | Conjugate gradient; slower but more robust |
| Hybrid functionals (HSE, PBE0) | `Damped` or `All` | `Damped` is most robust for hybrids; `All` is faster if it converges |
| Single-shot (no SCF update) | `None` | For post-processing with fixed orbitals |
| Molecular dynamics (large systems) | `VeryFast` | RMM-DIIS only; fastest but least robust |
| GW calculations | `GW0` / `scGW` etc. | Specialized many-body algorithms |

When ALGO=Fast fails on a magnetic system, try ALGO=All with TIME=0.4 first.

## Precision: PREC

| PREC | ENCUT default | FFT grid | Use case |
| --- | --- | --- | --- |
| `Normal` | ENMAX from POTCAR | Standard | Routine calculations |
| `Accurate` | ENMAX from POTCAR | Finer wrap-around grid | Production runs; avoids aliasing |
| `High` | ENMAX from POTCAR | Even finer grid | Stress tensor, elastic constants |
| `Low` | 0.7 * ENMAX | Coarser | Quick tests only |
| `Single` / `SingleN` | — | — | Machine-learning force field generation |

Always use PREC=Accurate for production. PREC=High if computing stress tensor or elastic constants.

## Energy Cutoff: ENCUT

| Scenario | ENCUT rule | Rationale |
| --- | --- | --- |
| Fixed-cell relaxation | max(ENMAX) from POTCAR | Default is sufficient; always check with `grep ENMAX POTCAR` |
| Volume relaxation (ISIF=3,4,7) | 1.3 * max(ENMAX) | Avoids Pulay stress errors from basis set incompleteness |
| Elastic constants / stress tensor | 1.5 * max(ENMAX) | Stress converges slower than energy |
| Convergence test | sweep from ENMAX to 1.5*ENMAX in 25–50 eV steps | Target: energy difference < 1 meV/atom between consecutive steps |
| Hybrid functional | same rules, but typically 400–520 eV | Hybrids need well-converged plane-wave basis |

Typical ENMAX values by element family:
- Light elements (C, N, O): 400–520 eV
- 3d transition metals: 230–350 eV (standard), 350–450 eV (_pv/_sv)
- Rare earths: 250–350 eV
- Always verify: `grep ENMAX POTCAR`

## SCF Convergence: EDIFF

| Workflow stage | EDIFF | Rationale |
| --- | --- | --- |
| Geometry relaxation | `1E-05` to `1E-06` | Sufficient for accurate forces |
| Static SCF | `1E-06` | Standard production accuracy |
| DOS / band structure | `1E-06` | Inherited from static |
| Phonon (finite differences or DFPT) | `1E-08` | Forces must be extremely accurate |
| NEB / transition state | `1E-06` to `1E-07` | Tight enough for reliable energy barriers |

## Ionic Convergence: EDIFFG

| Scenario | EDIFFG | Meaning |
| --- | --- | --- |
| Standard relaxation | `-0.02` | Converge when max force < 0.02 eV/A (negative = force criterion) |
| Tight relaxation | `-0.01` | For phonon pre-relaxation or high-accuracy work |
| Quick relaxation | `-0.05` | Rough pre-optimization |
| Energy criterion (positive) | `1E-04` | Converge when energy change < value; less reliable than force criterion |

Negative EDIFFG (force-based) is almost always preferred over positive (energy-based).

## Relaxation Algorithm: IBRION

| IBRION | Algorithm | Best for |
| --- | --- | --- |
| `-1` | No ionic update | Static calculations (NSW=0) |
| `0` | Molecular dynamics | AIMD; set POTIM, TEBEG, SMASS |
| `1` | Quasi-Newton (RMM-DIIS) | Near-equilibrium refinement; needs good starting structure |
| `2` | Conjugate gradient | General relaxation from arbitrary starting geometry (default choice) |
| `3` | Damped MD | Difficult cases; useful with VTST optimizers for NEB |
| `5` | Finite differences (all displacements) | Phonons; expensive, no symmetry reduction |
| `6` | Finite differences (symmetry-reduced) | Phonons + elastic constants; preferred over IBRION=5 |
| `7` | DFPT (perturbation theory) | Phonons at Gamma; faster than finite differences |
| `8` | DFPT (symmetry-reduced) | Phonons at Gamma; preferred over IBRION=7 |

## Relaxation Scope: ISIF

| ISIF | Ions | Cell shape | Cell volume | Stress tensor | Use case |
| --- | --- | --- | --- | --- | --- |
| `0` | yes | no | no | no | Molecule in box |
| `2` | yes | no | no | yes | Surface/slab relaxation (most common) |
| `3` | yes | yes | yes | yes | Bulk full relaxation |
| `4` | yes | yes | no | yes | Fixed-volume shape optimization |
| `7` | no | yes | yes | yes | Cell relaxation with frozen ions |

Warning: ISIF=3 with insufficient ENCUT causes Pulay stress. Use ENCUT >= 1.3 * ENMAX.
For slabs: always ISIF=2 to prevent vacuum collapse.

## Electronic Iterations: NELM and NELMIN

| Tag | Default | When to change |
| --- | --- | --- |
| `NELM` | `60` | Increase to 200+ for difficult convergence (magnetic, hybrid, DFT+U) |
| `NELMIN` | `2` | Increase to 6–8 for MD to avoid premature SCF exit between ionic steps |

## Bands: NBANDS

Default formula: NBANDS = NELECT/2 + NIONS/2 (minimum; VASP auto-increases).
- Increase by 20–50% for: metals, f-electron systems, GW calculations, meta-GGA
- For GW: NBANDS may need to be 4–10x the occupied count
- Check OUTCAR: if last bands have non-zero occupation, NBANDS is too small

## Real-Space Projection: LREAL

| LREAL | Use case |
| --- | --- |
| `.FALSE.` | Small systems (< 20 atoms); exact but slow |
| `Auto` | Large systems (> 20 atoms); fast; slight accuracy loss |
| `On` | Legacy; use `Auto` instead |

For phonons and finite differences: always use LREAL=.FALSE. (accuracy critical).

## Mixing Parameters

| Scenario | AMIX | BMIX | AMIX_MAG | BMIX_MAG |
| --- | --- | --- | --- | --- |
| Default (most systems) | `0.4` | `1.0` | `1.6` | `1.0` |
| Difficult SCF (magnetic, SOC) | `0.2` | `0.00001` | `0.8` | `0.00001` |
| Surfaces / slabs | `0.2` | `0.0001` | — | — |
| DFT+U initialization | `0.1` | `0.00001` | `0.2` | `0.00001` |

If SCF oscillates, reduce AMIX first (try 0.1), then reduce BMIX.

## Output Control

| Tag | Value | Purpose |
| --- | --- | --- |
| `LWAVE` | `.TRUE.` / `.FALSE.` | Write WAVECAR; `.TRUE.` for restarts, `.FALSE.` to save disk |
| `LCHARG` | `.TRUE.` / `.FALSE.` | Write CHGCAR; `.TRUE.` for DOS/bands follow-on |
| `LORBIT` | `11` | Write PROCAR + site-projected DOS; essential for PDOS analysis |
| `LVHAR` | `.TRUE.` | Write electrostatic potential to LOCPOT; needed for defect corrections, work function |
| `NEDOS` | `2001` | DOS energy points; increase from default 301 for smooth DOS |
| `EMIN` / `EMAX` | e.g. `-10` / `10` | DOS energy window relative to Fermi level |
