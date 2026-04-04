# VASP Error Recovery

Quick-reference triage guide with concrete diagnostic commands and fix sequences.

## First 5 Things to Check (Any Failure)

```bash
1. grep "ERROR\|error\|VERY BAD\|ZBRENT\|BRMIX\|EDDDAV" vasp.out OUTCAR
2. tail -50 OSZICAR                    # SCF convergence trend
3. grep TITEL POTCAR && head -7 POSCAR # species order match
4. grep ENMAX POTCAR                   # check cutoff expectations
5. grep "E0=" OSZICAR | tail -20       # energy trend
```

## Decision Tree

```
Job crashed immediately?
  ├── "VERY BAD NEWS" → k-mesh/symmetry incompatibility → use Gamma-centered mesh
  ├── "EDDDAV: Call to ZHEGV" → overlapping atoms OR NPAR issue → check POSCAR distances; try NCORE=4
  ├── "POSCAR and POTCAR are incompatible" → species mismatch → rebuild POTCAR
  └── segfault / bus error → memory or compilation issue → reduce NCORE, increase memory

SCF did not converge (NELM reached)?
  ├── Energy oscillating? → wrong smearing or ALGO → fix ISMEAR; try ALGO=All
  ├── Energy decreasing but slowly? → increase NELM=200; check AMIX
  ├── BRMIX warning? → charge sloshing → reduce AMIX=0.1, BMIX=0.001
  └── Magnetic system? → check MAGMOM init; try AMIX=0.2, AMIX_MAG=0.8

Ionic relaxation failed?
  ├── ZBRENT error? → copy CONTCAR to POSCAR; reduce POTIM
  ├── Forces oscillating? → reduce POTIM; try IBRION=1
  ├── Cell collapsed (slab)? → wrong ISIF → use ISIF=2 for slabs
  └── Energy going up? → bad starting structure → visualize POSCAR; pre-relax with lower accuracy

DOS/bands look wrong?
  ├── DOS spiky? → k-mesh too coarse → increase mesh 2x; use ISMEAR=-5
  ├── Band gap wrong? → check functional; PBE underestimates ~30-50%
  ├── Band discontinuities? → ICHARG not set → use ICHARG=11 for bands
  └── DFT+U bands differ from SCF? → use zero-weight k-points method
```

## Input-Set Mismatches

If VASP fails before or at startup:

1. Verify POSCAR species order and count: `head -7 POSCAR`
2. Verify POTCAR element order: `grep TITEL POTCAR`
3. Verify KPOINTS mode fits the stage: `head -4 KPOINTS`
4. Verify INCAR tags are coherent: check IBRION, NSW, ICHARG match stage intent

Common startup errors:
- `"POSCAR, CURRENTCONTCAR and target structure have incompatible"` → POSCAR and POTCAR species count mismatch
- `"VERY BAD NEWS!"` → k-mesh incompatible with symmetry; use Gamma-centered
- `"internal error in RAD_PROJ"` → POTCAR corrupted or wrong element

## SCF Failures

### Oscillatory SCF (Energy swings > 0.1 eV)

**Fix sequence (try in order):**
1. Fix smearing: insulator → ISMEAR=0, SIGMA=0.05; metal → ISMEAR=1, SIGMA=0.2
2. Switch ALGO=All (robust CG minimizer)
3. Add TIME=0.4 (step size for ALGO=All/Damped)
4. Reduce mixing: AMIX=0.2, BMIX=0.0001
5. For magnetic: set AMIX_MAG=0.8, BMIX_MAG=0.00001
6. Last resort: ALGO=Damped with TIME=0.1

### Slow SCF (Converges but takes >100 steps)

**Fix sequence:**
1. Start from pre-converged WAVECAR (ISTART=1)
2. Try ALGO=Fast (blocked Davidson + RMM-DIIS)
3. Increase NBANDS by 20% (more empty states help RMM-DIIS)
4. For metals: verify SIGMA is not too large (try 0.1)

### BRMIX / Charge Sloshing

Typical for metal surfaces and slabs:
1. Reduce AMIX=0.1, BMIX=0.001
2. Use IMIX=1 (Kerker mixing)
3. Increase vacuum layer for slabs
4. Start from pre-converged CHGCAR (ICHARG=1)

## Ionic Relaxation Failures

### ZBRENT Error

```
ZBRENT: fatal error in bracketing
please rerun with smaller EDIFF, or copy CONTCAR to POSCAR and continue
```

**Fix:**
1. `cp CONTCAR POSCAR` and restart
2. Reduce POTIM=0.3 (default 0.5)
3. Tighten EDIFF=1E-07
4. If near equilibrium: switch to IBRION=1 (quasi-Newton)

### Forces Not Converging

```bash
grep "FORCES:" OUTCAR | awk '{print $NF}' | tail -20  # max force trend
```

If forces plateau above EDIFFG threshold:
1. Check for rattling atoms (large displacement between steps)
2. Increase k-mesh density (forces are more k-sensitive than energy)
3. Check ENCUT convergence for forces (need < 5 meV/A error)
4. For molecular adsorption: try vdW correction (IVDW=12)

### NSW Reached Without Convergence

The calculation ran all NSW steps but didn't satisfy EDIFFG:
1. If energy/forces are still decreasing: increase NSW and restart from CONTCAR
2. If oscillating: reduce POTIM, switch IBRION
3. If stuck: the structure may be in a shallow local minimum; perturb slightly and retry

## Workflow Handoff Failures

### DOS Post-Processing Checklist

Before running DOS:
```
IBRION = -1
NSW    = 0
ICHARG = 11        # read CHGCAR from prior static
ISMEAR = -5        # tetrahedron method
LORBIT = 11        # for PDOS
NEDOS  = 2001      # smooth DOS
EMIN   = -10       # adjust energy window as needed
EMAX   = 10
```
Ensure CHGCAR from a well-converged static calculation exists in the directory.

### Band Structure Post-Processing Checklist

Before running bands:
```
IBRION = -1
NSW    = 0
ICHARG = 11        # non-SCF; read CHGCAR
LORBIT = 11
```
Use line-mode KPOINTS file with high-symmetry path. Exception: for DFT+U and hybrid functionals, use zero-weight k-points method instead of ICHARG=11.

## Performance Troubleshooting

### Calculation is Slower Than Expected

```bash
grep "LOOP:" OUTCAR | tail -5       # time per ionic step
grep "LOOP+" OUTCAR | tail -5       # total time including I/O
```

**Fix sequence:**
1. Set KPAR = min(number_of_nodes, number_of_kpoints)
2. Set NCORE = cores per NUMA domain (typically 8–16)
3. For large systems (>100 atoms): LREAL=Auto, ALGO=Fast
4. Reduce I/O: LWAVE=.FALSE., LCHARG=.FALSE. (unless needed for restart)
5. Check NBANDS is not excessively large
6. For hybrid functionals: PRECFOCK=Fast

### Job Runs Out of Memory

1. Increase NCORE (distributes memory across more cores per orbital)
2. Reduce KPAR (each k-point group duplicates memory)
3. Set LREAL=Auto
4. Set LWAVE=.FALSE., LCHARG=.FALSE.
5. Request nodes with more RAM
