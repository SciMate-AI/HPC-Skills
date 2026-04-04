# VASP NEB and Transition State Recipes

## Nudged Elastic Band (NEB) Method

NEB finds the minimum energy path (MEP) between two structures (reactant and product) by optimizing a chain of intermediate images connected by spring forces.

### Prerequisites

1. **Relax initial and final structures** independently with tight EDIFFG (-0.02 or tighter).
2. Both endpoints must be true local minima (no imaginary frequencies).
3. Endpoints must have the same composition, cell shape, and atom ordering.

### Directory Structure

```
neb_calculation/
├── 00/POSCAR          # initial state (frozen endpoint)
├── 01/POSCAR          # intermediate image 1
├── 02/POSCAR          # intermediate image 2
├── 03/POSCAR          # intermediate image 3
├── 04/POSCAR          # intermediate image 4
├── 05/POSCAR          # final state (frozen endpoint)
├── INCAR
├── KPOINTS
└── POTCAR
```

Directories `00/` and `05/` (endpoints) are NOT optimized by NEB — only intermediate images move.

### Generating Initial Path

**Linear interpolation (simplest):**
```bash
# Using VTST scripts:
nebmake.pl POSCAR_initial POSCAR_final 4    # 4 intermediate images
# Creates: 00/ 01/ 02/ 03/ 04/ 05/ with interpolated POSCARs
```

**Using ASE:**
```python
from ase.neb import NEB
from ase.io import read, write
initial = read('POSCAR_initial')
final = read('POSCAR_final')
images = [initial] + [initial.copy() for _ in range(4)] + [final]
neb = NEB(images)
neb.interpolate()
for i, image in enumerate(images):
    write(f'{i:02d}/POSCAR', image)
```

### INCAR for NEB (Vanilla VASP)

```
SYSTEM  = neb-calculation
PREC    = Accurate
ENCUT   = 520
EDIFF   = 1E-06

IMAGES  = 4                # number of intermediate images (excluding endpoints)
SPRING  = -5               # spring constant; negative activates NEB (default: -5)
LCLIMB  = .TRUE.           # climbing image NEB (finds saddle point)

IBRION  = 1                # quasi-Newton (recommended for NEB)
NSW     = 200
EDIFFG  = -0.05            # force convergence; -0.03 for higher accuracy
POTIM   = 0.5              # step size

ISMEAR  = 0
SIGMA   = 0.05
LREAL   = Auto
LWAVE   = .FALSE.
LCHARG  = .FALSE.
```

### INCAR for NEB with VTST Tools

VTST (Henkelman group) adds optimizers and climbing image support:

```
IMAGES  = 4
SPRING  = -5
LCLIMB  = .TRUE.
ICHAIN  = 0                # NEB method (VTST)
IOPT    = 3                # Quick-Min optimizer (VTST)
IBRION  = 3                # disable VASP built-in optimizer
POTIM   = 0                # required when IOPT is used
EDIFFG  = -0.05
```

### Number of Images

| Reaction type | Typical IMAGES | Notes |
| --- | --- | --- |
| Simple diffusion hop | 3–5 | Short path, single barrier |
| Complex rearrangement | 7–11 | Multiple intermediate states |
| Surface reaction | 5–9 | Adsorption + bond breaking |

More images = better path sampling but higher cost. Total MPI ranks must be divisible by IMAGES.

### Climbing Image NEB (CI-NEB)

**Best practice:** Run regular NEB first (LCLIMB=.FALSE.) for ~50 steps to establish a reasonable path, then restart with LCLIMB=.TRUE. to refine the transition state.

The climbing image:
- Is driven uphill to the saddle point
- Does not feel spring forces along the band
- Gives the exact transition state energy

### Parallelization

Total MPI ranks must be divisible by IMAGES:
- 4 images, 16 cores per image → 64 total MPI ranks
- Each image runs its own VASP calculation in parallel
- Set KPAR and NCORE as usual within each image's allocation

### Analyzing NEB Results

```bash
# Energy profile:
nebef.pl          # VTST script; prints image energies
# or grep E0 0*/OSZICAR | tail -1 for each image

# Maximum force:
grep "RMS" 0*/OUTCAR | tail -1
```

The transition state is the highest-energy image. Barrier = E(TS) - E(initial).

### Verifying the Transition State

After NEB converges, verify the saddle point has exactly ONE imaginary frequency:

1. Copy the climbing image CONTCAR to a new directory.
2. Run a frequency calculation (IBRION=5 or 6).
3. Check: exactly one negative eigenvalue in the dynamical matrix.

```
IBRION  = 5                # or 6
NSW     = 1
NFREE   = 2
POTIM   = 0.015
EDIFF   = 1E-08
```

### Common NEB Pitfalls

1. **Bad initial path**: Linear interpolation may create overlapping atoms. Visualize all images before running.
2. **Too few images**: Barrier may be underestimated if the path is poorly sampled.
3. **IBRION=2 with NEB**: CG optimizer often fails for NEB. Use IBRION=1 or IBRION=3 (with VTST IOPT).
4. **Incompatible endpoints**: Initial and final structures must have identical cell, species count, and atom ordering.
5. **Starting with LCLIMB**: Run regular NEB first to establish path; premature climbing distorts spacing.
6. **Rank count mismatch**: Total MPI ranks must be divisible by IMAGES.
