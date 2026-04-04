# OpenFOAM Multiphase VOF Recipes

Detailed interFoam / VoF setup including alpha transport, MULES, and interface handling.

## When to Use VOF

- Free-surface flows (dam break, sloshing, waves)
- Gas-liquid interfaces (bubble columns, jet breakup)
- Filling/emptying tanks
- Ship hydrodynamics

**Not suitable for:** dispersed flows with many small bubbles/droplets (use Euler-Euler instead).

## Solver Selection

| Physics | Solver | Notes |
| --- | --- | --- |
| Incompressible two-phase | `interFoam` | Standard VOF; most common |
| Incompressible two-phase (modular) | `foamRun -solver incompressibleVoF` | OpenFOAM Foundation v11+ |
| Compressible two-phase | `compressibleInterFoam` | Phase change, pressure-dependent density |
| Three+ phases | `multiphaseInterFoam` | Multiple alpha fields |

## Required Fields

| Field | Dimensions | Purpose |
| --- | --- | --- |
| `alpha.water` | [0 0 0 0 0 0 0] | Phase fraction (0=air, 1=water) |
| `U` | [0 1 -1 0 0 0 0] | Velocity (shared) |
| `p_rgh` | [1 -1 -2 0 0 0 0] | Modified pressure (hydrostatic removed) |
| `p` | [1 -1 -2 0 0 0 0] | Reconstructed total pressure |

## transportProperties

```c++
phases (water air);

water
{
    transportModel  Newtonian;
    nu              1e-06;        // kinematic viscosity [m^2/s]
    rho             998.2;        // density [kg/m^3]
}
air
{
    transportModel  Newtonian;
    nu              1.48e-05;
    rho             1.225;
}
sigma           0.07;             // surface tension [N/m] (water-air at 20°C)
```

## Timestep Control

```c++
// controlDict
adjustTimeStep  yes;
maxCo           1;                // max Courant for velocity
maxAlphaCo      0.5;              // max Courant near interface (stricter)
maxDeltaT       0.01;
```

If `maxAlphaCo < maxCo`, the solver applies stricter time-step limiting near the interface.

## Alpha Solver Settings (fvSolution)

```c++
"alpha.water.*"
{
    nAlphaCorr      2;            // alpha correction loops per time step
    nAlphaSubCycles 1;            // sub-cycles (2 = solve at half deltaT)
    cAlpha          1;            // interface compression: 0=none, 1=standard, >1=enhanced
    MULESCorr       yes;          // semi-implicit MULES (stable at higher Co)
    nLimiterIter    5;            // MULES limiter iterations

    solver          smoothSolver;
    smoother        symGaussSeidel;
    tolerance       1e-8;
    relTol          0;
}
```

### Key Parameters Explained

| Parameter | Effect | Typical values |
| --- | --- | --- |
| `cAlpha` | Controls interface sharpness; higher = sharper | 0 (off), 1 (standard), 1.5 (aggressive) |
| `nAlphaSubCycles` | Sub-cycles for alpha equation within each time step | 1 (no sub-cycling), 2 (recommended if Co > 0.5) |
| `MULESCorr` | Semi-implicit MULES for stability at larger Co | `yes` recommended |
| `nAlphaCorr` | Number of alpha correction loops | 1–3 |

## fvSchemes for VOF

```c++
ddtSchemes      { default Euler; }             // 1st order time (stable for VOF)
gradSchemes     { default Gauss linear; }
divSchemes
{
    div(rhoPhi,U)   Gauss linearUpwind grad(U);
    div(phi,alpha)  Gauss vanLeer;             // bounded scheme for alpha transport
    div(phirb,alpha) Gauss linear;             // compression flux
    div(((rho*nuEff)*dev2(T(grad(U))))) Gauss linear;
}
laplacianSchemes { default Gauss linear corrected; }
interpolationSchemes { default linear; }
snGradSchemes    { default corrected; }
```

**Alpha convection:** Always use a bounded scheme (vanLeer, MUSCL, vanAlbada). Never use `linear` or `upwind` for alpha — `linear` is unbounded (alpha > 1), `upwind` is too diffusive.

## Initializing the Alpha Field

### Using setFieldsDict

```c++
// system/setFieldsDict
defaultFieldValues ( volScalarFieldValue alpha.water 0 );
regions
(
    boxToCell
    {
        box (0 0 -1) (1 0.5 1);
        fieldValues ( volScalarFieldValue alpha.water 1 );
    }
);
```

```bash
setFields     # run before solver
```

### Using funkySetFields (more complex shapes)

```bash
funkySetFields -field alpha.water -expression "pos().y < 0.5 ? 1 : 0"
```

## Boundary Conditions for VOF

### Inlet (water inflow)

```c++
// 0/alpha.water
inlet
{
    type            fixedValue;
    value           uniform 1;        // pure water entering
}

// 0/U
inlet
{
    type            fixedValue;
    value           uniform (1 0 0);
}

// 0/p_rgh
inlet
{
    type            fixedFluxPressure;
    value           uniform 0;
}
```

### Outlet

```c++
// 0/alpha.water
outlet
{
    type            inletOutlet;
    inletValue      uniform 0;        // air if backflow
    value           uniform 0;
}

// 0/p_rgh
outlet
{
    type            fixedValue;
    value           uniform 0;
}
```

### Atmosphere (open top)

```c++
// 0/alpha.water
atmosphere
{
    type            inletOutlet;
    inletValue      uniform 0;        // air entering from atmosphere
    value           uniform 0;
}

// 0/U
atmosphere
{
    type            pressureInletOutletVelocity;
    value           uniform (0 0 0);
}

// 0/p_rgh
atmosphere
{
    type            totalPressure;
    p0              uniform 0;
    value           uniform 0;
}
```

### Walls

```c++
// 0/alpha.water
walls
{
    type            zeroGradient;     // contact angle: use alphaContactAngle for wetting
}
```

## Turbulent VOF

For turbulent VOF (e.g., wave breaking, turbulent jets):

1. Add k, omega, nut fields as in single-phase RANS
2. Use `kOmegaSSTSAS` or `kOmegaSST` (SAS detects and resolves large-scale structures)
3. Wall functions apply on walls as normal
4. Turbulence schemes: use `upwind` for k/omega initially

## Common VOF Pitfalls

1. **Using `p` instead of `p_rgh`**: VOF solvers use modified pressure. Wrong field = wrong physics.
2. **CFL too high**: VOF interface is sensitive. Keep maxAlphaCo <= 1 (0.5 safer).
3. **Missing `setFields`**: Alpha field starts at 0 everywhere; run `setFields` first.
4. **Interface smearing**: Increase `cAlpha` to 1 or higher; reduce `maxAlphaCo`.
5. **Wrong alpha convection scheme**: Must be bounded (vanLeer, MUSCL). Never `linear`.
6. **Gravity direction wrong**: Check `constant/g` points in correct direction.
