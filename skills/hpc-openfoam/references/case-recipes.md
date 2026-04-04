# OpenFOAM Case Recipes

Complete case configurations for common flow scenarios with concrete dictionary entries.

## Recipe Selection Checklist

1. Steady or transient?
2. Incompressible or compressible?
3. Single-phase or multiphase?
4. Laminar or turbulent? If turbulent: RANS or LES?
5. Heat transfer involved?
6. Target output: fields, forces, pressure drop, interface position?

## Recipe 1: Internal Incompressible Pipe/Duct (Steady RANS)

### Configuration

| Setting | Value |
| --- | --- |
| Solver | `simpleFoam` |
| Turbulence | k-omega SST |
| Fields | U, p, k, omega, nut |
| Patches | inlet, outlet, walls |

### Key Dictionaries

**controlDict:**
```c++
application     simpleFoam;
startFrom       startTime;
startTime       0;
stopAt          endTime;
endTime         2000;        // iterations (not seconds)
deltaT          1;
writeControl    timeStep;
writeInterval   500;
purgeWrite      3;
```

**fvSchemes:**
```c++
ddtSchemes      { default steadyState; }
gradSchemes     { default Gauss linear; grad(U) cellLimited Gauss linear 1; }
divSchemes
{
    default         none;
    div(phi,U)      bounded Gauss linearUpwind grad(U);  // 2nd order for velocity
    div(phi,k)      bounded Gauss upwind;                 // 1st order for stability
    div(phi,omega)  bounded Gauss upwind;
    div((nuEff*dev2(T(grad(U))))) Gauss linear;
}
laplacianSchemes { default Gauss linear corrected; }
interpolationSchemes { default linear; }
snGradSchemes    { default corrected; }
```

**fvSolution:**
```c++
solvers
{
    p   { solver GAMG; smoother GaussSeidel; tolerance 1e-6; relTol 0.01; }
    U   { solver smoothSolver; smoother GaussSeidel; tolerance 1e-7; relTol 0.01; }
    "(k|omega)" { solver smoothSolver; smoother GaussSeidel; tolerance 1e-7; relTol 0.01; }
}
SIMPLE
{
    nNonOrthogonalCorrectors 1;
    consistent          yes;     // SIMPLEC algorithm (faster convergence)
    residualControl
    {
        p       1e-4;
        U       1e-4;
        "(k|omega)" 1e-4;
    }
}
relaxationFactors
{
    equations
    {
        U       0.7;
        k       0.5;
        omega   0.5;
    }
    fields
    {
        p       0.3;
    }
}
```

### Useful Function Objects

```c++
// In controlDict functions{} block
pressureDrop
{
    type            pressure;
    libs            (fieldFunctionObjects);
    mode            staticCoeff;
    pInf            0;
    rhoInf          1;
    UInf            (5 0 0);
    patches         (inlet outlet);
    writeControl    timeStep;
    writeInterval   1;
}
```

## Recipe 2: External Aerodynamic (Steady RANS)

### Configuration

| Setting | Value |
| --- | --- |
| Solver | `simpleFoam` |
| Turbulence | k-omega SST |
| Fields | U, p, k, omega, nut |
| Patches | inlet, outlet, body, top, bottom, sides (or symmetry) |

### Key Differences from Internal Flow

**Boundary conditions:**
```c++
// 0/U
inlet     { type fixedValue; value uniform (30 0 0); }
outlet    { type inletOutlet; inletValue uniform (30 0 0); value uniform (30 0 0); }
body      { type noSlip; }
top       { type symmetryPlane; }    // or freestream
sides     { type symmetryPlane; }
```

**Force monitoring (essential for aero):**
```c++
forceCoeffs
{
    type            forceCoeffs;
    libs            (forces);
    writeControl    timeStep;
    writeInterval   1;
    patches         (body);
    rho             rhoInf;
    rhoInf          1.225;
    liftDir         (0 1 0);
    dragDir         (1 0 0);
    CofR            (0 0 0);
    pitchAxis       (0 0 1);
    magUInf         30;
    lRef            1;          // reference length
    Aref            1;          // reference area
}

yPlus
{
    type            yPlus;
    libs            (fieldFunctionObjects);
    writeControl    timeStep;
    writeInterval   100;
}
```

### Numerics Tips for External Aero

- Use `cellLimited Gauss linear 1` for gradients (prevents overshoots near body)
- `linearUpwind grad(U)` for velocity convection
- Start with `upwind` for first 200 iterations, then switch to `linearUpwind`
- Monitor force coefficients for convergence (more meaningful than residuals)

## Recipe 3: Free-Surface / VOF (Transient)

### Configuration

| Setting | Value |
| --- | --- |
| Solver | `interFoam` |
| Fields | U, p_rgh, alpha.water |
| Patches | inlet, outlet, walls, atmosphere |
| Phase properties | `transportProperties` with two phases |

### Key Dictionaries

**controlDict:**
```c++
application     interFoam;
startFrom       startTime;
startTime       0;
stopAt          endTime;
endTime         5;
deltaT          0.001;          // small initial timestep
adjustTimeStep  yes;
maxCo           1;
maxAlphaCo      0.5;            // stricter near interface
maxDeltaT       0.01;
writeControl    adjustableRunTime;
writeInterval   0.1;
```

**transportProperties:**
```c++
phases (water air);

water
{
    transportModel  Newtonian;
    nu              1e-06;       // kinematic viscosity [m^2/s]
    rho             998.2;       // density [kg/m^3]
}
air
{
    transportModel  Newtonian;
    nu              1.48e-05;
    rho             1.225;
}
sigma           0.07;            // surface tension [N/m]
```

**fvSchemes (VOF-specific):**
```c++
ddtSchemes      { default Euler; }
gradSchemes     { default Gauss linear; }
divSchemes
{
    div(rhoPhi,U)   Gauss linearUpwind grad(U);
    div(phi,alpha)  Gauss vanLeer;           // phase fraction
    div(phirb,alpha) Gauss linear;           // compression term
    div(((rho*nuEff)*dev2(T(grad(U))))) Gauss linear;
}
laplacianSchemes { default Gauss linear corrected; }
interpolationSchemes { default linear; }
snGradSchemes    { default corrected; }
```

**fvSolution (VOF-specific):**
```c++
solvers
{
    "alpha.water.*"
    {
        nAlphaCorr      2;
        nAlphaSubCycles 1;
        cAlpha          1;          // interface compression (0=none, 1=standard)
        MULESCorr       yes;        // semi-implicit MULES (stable at higher Co)
        nLimiterIter    5;
    }
    p_rgh { solver GAMG; smoother DIC; tolerance 1e-8; relTol 0.01; }
    p_rghFinal { $p_rgh; relTol 0; }
    U     { solver smoothSolver; smoother symGaussSeidel; tolerance 1e-6; relTol 0; }
}
PIMPLE
{
    nOuterCorrectors    1;
    nCorrectors         3;
    nNonOrthogonalCorrectors 1;
    momentumPredictor   no;
}
```

**Important:** VOF uses `p_rgh` (pressure minus hydrostatic component), NOT `p`. The `p` field is reconstructed from `p_rgh`.

### Initial Alpha Field (setFieldsDict)

```c++
// system/setFieldsDict
defaultFieldValues ( volScalarFieldValue alpha.water 0 );
regions
(
    boxToCell
    {
        box (0 0 0) (1 0.5 1);     // fill lower half with water
        fieldValues ( volScalarFieldValue alpha.water 1 );
    }
);
```

Run: `setFields` before launching solver.

## Recipe 4: Transient Incompressible (PIMPLE)

### Configuration

| Setting | Value |
| --- | --- |
| Solver | `pimpleFoam` |
| Use when | Transient effects matter (vortex shedding, pulsating flow, LES) |

### Key Differences from SIMPLE

**controlDict:**
```c++
application     pimpleFoam;
deltaT          0.001;          // physical time step (seconds)
adjustTimeStep  yes;
maxCo           2;              // PIMPLE allows Co > 1
```

**fvSchemes (transient):**
```c++
ddtSchemes      { default backward; }       // 2nd order time; or Euler for 1st order
// ... rest similar to steady but without "bounded" prefix
divSchemes
{
    div(phi,U)  Gauss linearUpwind grad(U);
    // ...
}
```

**fvSolution (PIMPLE):**
```c++
PIMPLE
{
    nOuterCorrectors    2;       // >1 enables PIMPLE outer loops (allows Co > 1)
    nCorrectors         2;       // pressure corrections per outer loop
    nNonOrthogonalCorrectors 1;
    turbOnFinalIterOnly false;   // solve turbulence each outer iteration
}
relaxationFactors
{
    equations
    {
        ".*"    1;               // no under-relaxation on final iteration
        ".*Final" 1;
    }
}
```

### PISO vs PIMPLE Decision

| Feature | PISO (nOuter=1) | PIMPLE (nOuter>1) |
| --- | --- | --- |
| Max Courant | < 1 | > 1 (even 10–50) |
| Cost per step | Low | Higher (multiple outer loops) |
| Best for | Small timesteps, LES | Large timesteps, startup |

## Recipe 5: Buoyant / Natural Convection

### Configuration

| Setting | Value |
| --- | --- |
| Solver | `buoyantSimpleFoam` (steady) or `buoyantPimpleFoam` (transient) |
| Fields | U, p_rgh, p, T, k, omega, nut, alphat |
| Extra | `thermophysicalProperties`, gravity `g` |

### Gravity File

```c++
// constant/g
dimensions      [0 1 -2 0 0 0 0];
value           (0 -9.81 0);
```

### thermophysicalProperties

```c++
thermoType
{
    type            heRhoThermo;
    mixture         pureMixture;
    transport       const;
    thermo          hConst;
    equationOfState perfectGas;
    specie          specie;
    energy          sensibleEnthalpy;
}
mixture
{
    specie      { molWeight 28.96; }
    thermodynamics { Cp 1004.4; Hf 0; }
    transport   { mu 1.831e-05; Pr 0.705; }
}
```

### Temperature Wall BCs (alphat)

```c++
// 0/alphat — turbulent thermal diffusivity
walls
{
    type            compressible::alphatWallFunction;
    Prt             0.85;
    value           uniform 0;
}
```
