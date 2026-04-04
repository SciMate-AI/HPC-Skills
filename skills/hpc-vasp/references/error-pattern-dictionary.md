# VASP Error Pattern Dictionary

Structured error patterns with real OUTCAR/OSZICAR signatures, root causes, and concrete fixes.

## Input-Set Mismatch Patterns

### Pattern: `VASP_SPECIES_ORDER_MISMATCH`

**Symptom in OUTCAR:**
```
POSCAR: Fe O
POTCAR: O Fe
```
or nonsensical forces/energies immediately from step 1.

**Root cause:** POSCAR species order and concatenated POTCAR order do not match.

**Diagnostic command:**
```bash
grep TITEL POTCAR    # shows POTCAR element order
head -7 POSCAR       # shows POSCAR species line
```

**Fix:** Rebuild POTCAR in exact POSCAR species order:
```bash
cat POTCAR_Fe POTCAR_O > POTCAR   # must match POSCAR line 6
```

### Pattern: `VASP_STAGE_TAG_MISMATCH`

**Symptom:** A static calculation still moves ions, or a relaxation freezes at step 0.

**Diagnostic:**
```bash
grep IBRION OUTCAR   # should be -1 for static
grep NSW OUTCAR      # should be 0 for static
grep ICHARG OUTCAR   # should be 11 for non-SCF band structure
```

**Fix:** Replace INCAR wholesale for the new stage rather than patching individual tags.

---

## SCF Convergence Failure Patterns

### Pattern: `VASP_SCF_OSCILLATORY`

**Symptom in OSZICAR:**
```
DAV:   1    -0.12345E+03    0.456E+01   -0.234E+02    48   0.345E+00
DAV:   2    -0.11823E+03   -0.522E+01    0.187E+01    60   0.289E+00
DAV:   3    -0.12568E+03    0.744E+00   -0.312E+01    72   0.312E+00
```
Energy oscillates by > 1 eV between iterations without converging.

**Root causes (check in order):**
1. Wrong smearing for system type (insulator treated as metal or vice versa)
2. ALGO not suited to system (Normal fails on metals)
3. Mixing parameters too aggressive

**Fix sequence:**
1. Check: is system metallic? If yes, use ISMEAR=1, SIGMA=0.2. If insulator, ISMEAR=0, SIGMA=0.05.
2. Try ALGO=All (more robust) instead of ALGO=Normal or Fast.
3. Reduce mixing: AMIX=0.2, BMIX=0.0001
4. For magnetic systems: add AMIX_MAG=0.8, BMIX_MAG=0.00001

### Pattern: `VASP_NELM_REACHED`

**Symptom in OSZICAR:**
```
DAV:  60    -0.98765E+02    0.123E-02   -0.456E-03   120   0.789E-03
```
Reached NELM (default 60) without satisfying EDIFF.

**Symptom in OUTCAR:**
```
 WARNING: Sub-Space-Matrix is not hermitian in DAV
```

**Root causes:**
1. NELM too small for difficult system
2. Poor initial wavefunction
3. System genuinely hard to converge (magnetic, DFT+U, hybrid)

**Fix sequence:**
1. Increase NELM=200 (or even 500 for hybrids)
2. Try ALGO=All with TIME=0.4
3. Pre-converge with GGA, then restart hybrid from WAVECAR
4. For DFT+U: reduce AMIX=0.1, BMIX=0.00001

### Pattern: `VASP_METAL_SMEARING_MISMATCH`

**Symptom:** Entropy term T*S in OUTCAR is large:
```
EENTRO =       -0.12345678    (should be < 0.001 eV/atom)
```
or oscillatory SCF on a semiconductor/insulator.

**Diagnostic:**
```bash
grep "entropy T" OUTCAR | tail -1    # check T*S magnitude
grep ISMEAR OUTCAR
```

**Fix:**
- Metal with large T*S: reduce SIGMA (try 0.1, then 0.05)
- Insulator using ISMEAR=1: switch to ISMEAR=0, SIGMA=0.05
- Static DOS: use ISMEAR=-5 (tetrahedron)

### Pattern: `VASP_EDDDAV_ZHEGV`

**Symptom in stdout/stderr:**
```
Error EDDDAV: Call to ZHEGV failed. Returncode =   8  2  128
```

**Root causes:**
1. Linear dependencies in basis (often with f-elements)
2. NPAR/NCORE mismatch with parallelization
3. Overlapping atoms in POSCAR
4. Compiler/library issues

**Fix sequence:**
1. Check POSCAR for overlapping atoms (distance < 0.5 A)
2. Switch ALGO from Fast to Normal (Davidson more stable than RMM-DIIS)
3. Try NCORE=4 or adjust parallelization: NPAR = 2 * number_of_nodes
4. Increase NBANDS by 20%
5. Try ISYM=0 (disables symmetry; slower but may fix subspace issues)

### Pattern: `VASP_BRMIX_WARNING`

**Symptom in stdout:**
```
BRMIX: very serious problems
 the old and the new charge density differ
```

**Root cause:** Charge density changed dramatically between SCF steps; mixing scheme failed.

**Fix:**
1. Reduce AMIX=0.1, BMIX=0.001
2. Set IMIX=1 (Kerker mixing) for metallic surfaces
3. For slabs: increase vacuum, check dipole correction
4. Start from a pre-converged CHGCAR (ICHARG=1)

### Pattern: `VASP_VERY_BAD_NEWS`

**Symptom in stdout:**
```
 internal error in subroutine IBZKPT:
 VERY BAD NEWS! internal error in subroutine ...
```

**Root cause:** K-point mesh is incompatible with crystal symmetry.

**Fix:**
1. Use Gamma-centered mesh for hexagonal/FCC cells
2. Check that k-mesh dimensions are compatible with symmetry operations
3. Try ISYM=0 to disable symmetry (last resort)

### Pattern: `VASP_TETRAHEDRON_FOR_METAL_RELAXATION`

**Symptom in OUTCAR:**
```
 WARNING: ISMEAR=-5 is not suitable for relaxation.
```

**Root cause:** Tetrahedron method (ISMEAR=-5) gives wrong forces; only valid for static calculations.

**Fix:** Use ISMEAR=1, SIGMA=0.2 for metal relaxation; ISMEAR=0, SIGMA=0.05 for insulator relaxation.

---

## Ionic Relaxation Patterns

### Pattern: `VASP_ZBRENT_BRACKETING`

**Symptom in stdout:**
```
ZBRENT: fatal error in bracketing
     please rerun with smaller EDIFF, or copy CONTCAR to POSCAR and continue
```

**Root cause:** Line search failed during conjugate gradient ionic relaxation.

**Fix sequence:**
1. Copy CONTCAR to POSCAR and restart
2. Reduce POTIM (try 0.3 instead of default 0.5)
3. Tighten EDIFF to 1E-07
4. Switch IBRION from 2 (CG) to 1 (quasi-Newton) if structure is near equilibrium
5. Check starting structure for unreasonable bond lengths

### Pattern: `VASP_RELAXATION_TOO_AGGRESSIVE`

**Symptom:** Forces oscillate wildly between ionic steps; energy increases.

**Diagnostic:**
```bash
grep "FORCES:" OUTCAR | tail -20   # check force magnitude trend
grep E0 OSZICAR                     # check energy trend
```

**Fix:**
1. Reduce POTIM to 0.1–0.3
2. Use IBRION=1 (quasi-Newton) instead of IBRION=2 (CG)
3. Check starting structure — very short bonds cause enormous forces
4. For molecular systems: start from a geometry optimized at lower level

### Pattern: `VASP_WRONG_RELAXATION_SCOPE`

**Symptom:** Cell parameters change during a surface relaxation (vacuum collapses), or cell is frozen when bulk relaxation was intended.

**ISIF reference:**

| ISIF | Ions | Shape | Volume |
| --- | --- | --- | --- |
| 0 | yes | no | no |
| 2 | yes | no | no |
| 3 | yes | yes | yes |
| 4 | yes | yes | no |

**Fix:** Set ISIF explicitly from stage intent:
- Bulk full relaxation: ISIF=3
- Slab/surface: ISIF=2 (always)
- Fixed-volume shape optimization: ISIF=4

### Pattern: `VASP_PULAY_STRESS`

**Symptom:** Optimized lattice constants are systematically wrong (usually too small); stress tensor shows large isotropic component.

**Diagnostic:**
```bash
grep "Pullay stress" OUTCAR
grep "in kB" OUTCAR | tail -1    # check stress components
```

**Root cause:** ENCUT too low for volume relaxation with ISIF >= 3.

**Fix:** Increase ENCUT to 1.3 * max(ENMAX) from POTCAR. Re-run relaxation.

---

## DOS and Band Handoff Patterns

### Pattern: `VASP_DOS_WITH_WRONG_KPOINT_MODE`

**Symptom:** DOS has spiky artifacts or clearly wrong shape.

**Root cause:** K-mesh too coarse or line-mode KPOINTS accidentally used for DOS.

**Fix:**
1. Use dense uniform mesh (1.5–2x relaxation mesh) for DOS
2. Use ISMEAR=-5 (tetrahedron) for accurate integration
3. Set NEDOS=2001 for smooth output
4. Set LORBIT=11 for site-projected DOS

### Pattern: `VASP_BANDS_WITH_WRONG_HANDOFF`

**Symptom:** Band structure has discontinuities or doesn't match DOS band gap.

**Root cause:** ICHARG or ISTART not set correctly for non-SCF band calculation.

**Fix:**
1. Run static SCF first with dense uniform k-mesh; save CHGCAR
2. For bands: set ICHARG=11 (read CHGCAR, keep fixed)
3. Use line-mode KPOINTS along high-symmetry path
4. For HSE bands: use zero-weight k-points technique instead of ICHARG=11

### Pattern: `VASP_BANDS_ICHARG11_DFTU`

**Symptom:** DFT+U band structure from ICHARG=11 differs significantly from self-consistent result.

**Root cause:** Non-self-consistent DFT+U is unreliable; occupation matrices are not properly updated.

**Fix:** For DFT+U band structures, use the zero-weight k-points method:
1. Run self-consistent calculation, save IBZKPT
2. Copy IBZKPT to KPOINTS, append band-path k-points with zero weight
3. Run self-consistently (no ICHARG=11)

---

## Parallel and Memory Patterns

### Pattern: `VASP_OOM_MEMORY`

**Symptom:** Job killed by scheduler; `slurmstepd: error: Detected 1 oom-kill event`.

**Fix sequence:**
1. Increase NCORE (fewer orbitals per group = less memory)
2. Reduce KPAR (k-point parallelism uses extra memory)
3. Set LREAL=Auto for large systems
4. Set LWAVE=.FALSE., LCHARG=.FALSE. to avoid large I/O
5. Request more memory per node

### Pattern: `VASP_SLOW_KPAR`

**Symptom:** Calculation runs but LOOP time is much longer than expected.

**Diagnostic:**
```bash
grep LOOP OUTCAR | tail -5   # check time per electronic step
```

**Fix:**
1. KPAR should divide the number of k-points evenly
2. KPAR should not exceed number of compute nodes
3. NCORE should be cores per NUMA domain (check with `lstopo`)
4. Never set both NPAR and NCORE
