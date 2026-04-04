# OpenFOAM Error Recovery

Diagnostic commands, decision tree, and concrete fix sequences for every common failure mode.

## First 5 Things to Check (Any Failure)

```bash
1. tail -50 log.*                                    # last solver output
2. grep -i "error\|fatal\|exception\|nan\|SIGFPE" log.*
3. checkMesh -latestTime 2>&1 | grep -i "fail\|error\|***"
4. grep "Courant Number" log.* | tail -5             # CFL trend
5. grep "bounding" log.* | tail -10                  # field bounding warnings
```

## Decision Tree

```
Crashes immediately at launch?
  ├── "FOAM FATAL ERROR" + patch name → missing/mismatched patch in field file
  ├── "processor boundary mismatch" → stale processor* dirs; re-run decomposePar
  ├── "cannot find file" → missing dictionary or field file
  └── MPI error → numberOfSubdomains != MPI rank count

Crashes after a few timesteps?
  ├── "Floating point exception" / SIGFPE → NaN in fields
  │   ├── Courant number very high? → reduce deltaT or enable adjustTimeStep
  │   ├── checkMesh shows errors? → fix mesh quality first
  │   └── Aggressive schemes? → switch to upwind temporarily
  ├── "Maximum number of iterations exceeded" → solver not converging
  │   └── Tighten relaxation or increase maxIter
  └── "bounding k/epsilon/omega" → turbulence blowing up
      ├── Check inlet turbulence values (too high or too low?)
      ├── Use upwind for turbulence convection terms
      └── Verify wall functions on all wall patches

Residuals not converging (steady-state)?
  ├── Residuals oscillating → relaxation factors too aggressive
  │   └── Reduce: p=0.2-0.3, U=0.5-0.7, k/omega=0.5
  ├── Residuals plateau → mesh or scheme issue
  │   └── Try better schemes (linearUpwind for U); check mesh quality
  ├── Continuity errors growing → pressure-velocity coupling issue
  │   └── Add non-orthogonal correctors; check mesh non-orthogonality
  └── Very slow convergence → under-relaxation too conservative
      └── Gradually increase relaxation factors after initial stability

Transient simulation diverges?
  ├── CFL > 1 with explicit schemes → reduce deltaT
  ├── PIMPLE nOuterCorrectors=1 with large CFL → increase nOuterCorrectors
  └── Multiphase interface breaking → reduce maxAlphaCo to 0.5
```

## CFL and Timestep Failures

**Symptom in log:**
```
Courant Number mean: 608.234 max: 48546.7
```

**Fix sequence:**
1. Reduce `deltaT` by 10x or more
2. Enable adaptive timestepping:
```c++
// controlDict
adjustTimeStep  yes;
maxCo           0.9;
maxDeltaT       0.01;
```
3. For multiphase: add `maxAlphaCo 0.5;`
4. For PIMPLE with large CFL: increase `nOuterCorrectors` to 50+

**Root cause diagnosis:**
```bash
grep "Courant Number" log.* | awk '{print $NF}' | sort -n | tail -5
# If max Co >> 1: deltaT too large or mesh has tiny cells
```

## Floating Point Exceptions (SIGFPE / NaN)

**Symptom:**
```
#0  Foam::sigFpe::sigHandler(int) ...
Floating point exception (core dumped)
```

**Fix sequence (try in order):**
1. Check mesh: `checkMesh -allGeometry -allTopology`
   - Non-orthogonality > 70°? → add `nNonOrthogonalCorrectors 2;`
   - Non-orthogonality > 85°? → remesh
   - Skewness > 4? → remesh
2. Switch convection schemes to bounded/upwind:
```c++
// fvSchemes - safe startup
div(phi,U)      bounded Gauss upwind;
div(phi,k)      bounded Gauss upwind;
div(phi,omega)  bounded Gauss upwind;
```
3. Reduce relaxation: `p 0.2; U 0.5; k 0.3; omega 0.3;`
4. Check boundary conditions for uninitialized fields
5. Check for zero-volume cells or negative volumes

**Enable NaN trapping for debugging:**
```bash
export FOAM_SIGFPE=true
export FOAM_SETNAN=true
# Re-run solver — will crash at the exact point NaN first appears
```

## Pressure and Bounding Problems

### "bounding k" / "bounding epsilon" / "bounding omega"

**Symptom:**
```
bounding k, min: -0.001234 max: 1.234 average: 0.5
```

**Means:** Turbulence quantity went negative (unphysical); clipped to small positive value.

**Fix sequence:**
1. Use `bounded Gauss upwind` for turbulence convection (k, epsilon, omega)
2. Check inlet turbulence values — too low k can cause problems
3. Verify wall functions on ALL wall patches (missing WF = common cause)
4. Increase under-relaxation on turbulence: `k 0.3; omega 0.3;`
5. If persistent but small magnitude (1e-8), often harmless — monitor trend

### "solution singularity"

**Symptom:**
```
--> FOAM FATAL ERROR:
    solution singularity
```

**Root cause:** Pressure matrix is singular — typically an enclosed domain without pressure reference.

**Fix:** Add to SIMPLE/PIMPLE dict:
```c++
pRefCell    0;
pRefValue   0;
```

### Growing continuity errors

**Symptom:**
```
time step continuity errors : sum local = 1.234e-01, global = 5.678e-02
```
Values should be O(1e-6) or smaller. Growing means instability.

**Fix:**
1. Add non-orthogonal correctors: `nNonOrthogonalCorrectors 2;`
2. Check mesh quality (non-orthogonality, skewness)
3. Verify boundary conditions are not overconstrained
4. Use `bounded` convection schemes

## Mesh Quality Thresholds

| Metric | Good | Acceptable | Problematic | Action if exceeded |
| --- | --- | --- | --- | --- |
| Max non-orthogonality | < 65° | 65–75° | 75–85° | Add nNonOrthCorrectors; > 85° remesh |
| Max skewness | < 2 | 2–4 | > 4 | Remesh; use gradient limiters |
| Max aspect ratio | < 100 | 100–1000 | > 1000 | OK in boundary layers; bad elsewhere |
| Min cell volume | > 0 | > 0 | = 0 or negative | Must fix; negative volumes = crash |

**Non-orthogonal correctors guidance:**

| Max non-orthogonality | nNonOrthogonalCorrectors |
| --- | --- |
| < 70° | 0 |
| 70–80° | 1 |
| 80–85° | 2 |
| > 85° | 3+ (but remesh is better) |

## Parallel Mismatch Failures

**Symptom:**
```
[0] FOAM FATAL ERROR: number of processor patches ... does not match
```

**Fix:**
```bash
rm -rf processor*          # remove stale decomposition
decomposePar               # re-decompose
mpirun -np N solver        # N must match numberOfSubdomains
```

**Common parallel issues:**
1. Changed mesh but didn't re-decompose → `rm -rf processor*; decomposePar`
2. `numberOfSubdomains` doesn't match MPI rank count → edit `decomposeParDict`
3. Empty subdomains with manual decomposition → switch to `scotch`
4. Reconstruction fails → `reconstructPar -latestTime` or run `reconstructPar` without `-latestTime` for all times

## Solver-Specific Issues

### simpleFoam Not Converging

1. Check relaxation factors: p=0.3, U=0.7 is standard starting point
2. If p residual stalls, try p=0.2 with more SIMPLE iterations
3. Use `residualControl` to auto-stop:
```c++
SIMPLE
{
    residualControl
    {
        p       1e-4;
        U       1e-4;
        "(k|omega|epsilon)" 1e-4;
    }
}
```

### pimpleFoam / Transient Issues

1. For Co > 1: need `nOuterCorrectors > 1` in PIMPLE
2. `nOuterCorrectors 1` = PISO behavior (Co < 1 required)
3. For large Co with PIMPLE: use `nOuterCorrectors 50;` with:
```c++
PIMPLE
{
    nOuterCorrectors    50;
    nCorrectors         2;
    nNonOrthogonalCorrectors 1;
    residualControl
    {
        U       { relTol 0.01; tolerance 1e-5; }
        p       { relTol 0.01; tolerance 1e-5; }
    }
}
```

### interFoam Interface Smearing

1. Check `cAlpha` in fvSolution (1 = standard compression; 0 = no compression)
2. Reduce `maxAlphaCo` to 0.2–0.5
3. Add alpha sub-cycles: `nAlphaSubCycles 2;`
4. Verify `div(phi,alpha)` uses `vanLeer` or `MUSCL` scheme
