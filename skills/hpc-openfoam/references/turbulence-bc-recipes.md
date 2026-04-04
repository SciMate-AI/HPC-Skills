# OpenFOAM Turbulence Boundary Recipes

Concrete turbulence model setup with field values, wall functions, and y+ guidance.

## Model Selection

| Physics | Model | Fields required | turbulenceProperties |
| --- | --- | --- | --- |
| Laminar | — | None | `simulationType laminar;` |
| RANS k-epsilon | kEpsilon | k, epsilon, nut | `simulationType RAS; RAS { RASModel kEpsilon; }` |
| RANS k-omega SST | kOmegaSST | k, omega, nut | `simulationType RAS; RAS { RASModel kOmegaSST; }` |
| RANS Spalart-Allmaras | SpalartAllmaras | nuTilda, nut | `simulationType RAS; RAS { RASModel SpalartAllmaras; }` |
| LES Smagorinsky | Smagorinsky | nut (+ k for some) | `simulationType LES; LES { LESModel Smagorinsky; }` |
| LES WALE | WALE | nut | `simulationType LES; LES { LESModel WALE; }` |

**k-omega SST is the recommended default** for most RANS applications. It combines the advantages of k-omega near walls and k-epsilon in the freestream.

## turbulenceProperties Dictionary

### k-omega SST (most common)

```c++
// constant/turbulenceProperties
simulationType  RAS;

RAS
{
    RASModel        kOmegaSST;
    turbulence      on;
    printCoeffs     on;
}
```

### k-epsilon

```c++
simulationType  RAS;

RAS
{
    RASModel        kEpsilon;
    turbulence      on;
    printCoeffs     on;
}
```

### Laminar

```c++
simulationType  laminar;
```

## Inlet Value Estimation

### Formulas

Given reference velocity U_ref, turbulence intensity I, and turbulent length scale L:

```
k       = 1.5 * (I * U_ref)^2
epsilon = C_mu^0.75 * k^1.5 / L
omega   = k^0.5 / (C_mu^0.25 * L)
nut     = k / omega  (or C_mu * k^2 / epsilon)
```

Where C_mu = 0.09, L is typically 0.07 * D_hydraulic (for internal flows) or 0.01–0.1 * characteristic_length (for external flows).

### Turbulence Intensity Guidelines

| Flow type | I (intensity) | Examples |
| --- | --- | --- |
| Very low | < 1% | High-quality wind tunnel, calm atmosphere |
| Low | 1–5% | Low-speed internal flow, large pipes |
| Medium | 5–10% | Moderate internal flow, HVAC |
| High | 10–20% | Complex geometry, rotating machinery |

### Worked Example: Pipe Flow

U_ref = 10 m/s, D = 0.1 m, I = 5%:
```
L       = 0.07 * 0.1 = 0.007 m
k       = 1.5 * (0.05 * 10)^2 = 0.375 m^2/s^2
omega   = 0.375^0.5 / (0.09^0.25 * 0.007) = 159.6 s^-1
epsilon = 0.09^0.75 * 0.375^1.5 / 0.007 = 9.43 m^2/s^3
nut     = 0.375 / 159.6 = 2.35e-3 m^2/s
```

## Wall Function Selection and y+ Requirements

### y+ Regimes

| y+ range | Layer | Wall treatment |
| --- | --- | --- |
| 0–5 | Viscous sublayer | Low-Re / wall-resolved |
| 5–30 | Buffer layer | Avoid (neither WF nor resolved is accurate) |
| 30–300 | Log-law region | Standard wall functions |
| > 300 | Too coarse | Remesh |

### Wall Function Recommendations

| Field | Wall function BC | y+ range | Notes |
| --- | --- | --- | --- |
| nut | `nutUSpaldingWallFunction` | Any (y+-insensitive) | **Recommended default**; continuous profile |
| k | `kqRWallFunction` | Any | Zero-gradient at wall |
| omega | `omegaWallFunction` | Any | Blends viscous/log; y+-insensitive |
| epsilon | `epsilonWallFunction` | 30–300 | Log-law based |
| nuTilda | `fixedValue uniform 0` | 0–5 | For Spalart-Allmaras |

**The combination of `nutUSpaldingWallFunction` + `kqRWallFunction` + `omegaWallFunction` is y+-insensitive** — it adapts automatically whether the first cell is in the viscous sublayer or log-law region.

### First Cell Height Estimation

```
y = y+ * nu / u_tau
u_tau = sqrt(tau_w / rho)
tau_w ≈ 0.5 * C_f * rho * U^2
C_f ≈ 0.058 * Re_x^(-0.2)    (flat plate, turbulent)
```

Quick approximation for target y+=30:
```
y ≈ 30 * nu / (U * sqrt(0.5 * C_f))
```

Tools: `yPlusCalc` (online calculators), or run `postProcess -func yPlus` after initial solution.

## Complete Field Set: k-omega SST RANS

### 0/k
```c++
dimensions      [0 2 -2 0 0 0 0];
internalField   uniform 0.375;

boundaryField
{
    inlet
    {
        type            fixedValue;
        value           uniform 0.375;
    }
    outlet
    {
        type            inletOutlet;
        inletValue      uniform 0.375;
        value           uniform 0.375;
    }
    walls
    {
        type            kqRWallFunction;
        value           uniform 0.375;
    }
    frontAndBack
    {
        type            empty;
    }
}
```

### 0/omega
```c++
dimensions      [0 0 -1 0 0 0 0];
internalField   uniform 160;

boundaryField
{
    inlet
    {
        type            fixedValue;
        value           uniform 160;
    }
    outlet
    {
        type            inletOutlet;
        inletValue      uniform 160;
        value           uniform 160;
    }
    walls
    {
        type            omegaWallFunction;
        value           uniform 160;
    }
    frontAndBack
    {
        type            empty;
    }
}
```

### 0/nut
```c++
dimensions      [0 2 -1 0 0 0 0];
internalField   uniform 0;

boundaryField
{
    inlet
    {
        type            calculated;
        value           uniform 0;
    }
    outlet
    {
        type            calculated;
        value           uniform 0;
    }
    walls
    {
        type            nutUSpaldingWallFunction;
        value           uniform 0;
    }
    frontAndBack
    {
        type            empty;
    }
}
```

## Failure Signatures

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Repeated `bounding k` | k going negative; bad inlet values or scheme | Use `upwind` for k convection; check inlet k value |
| Repeated `bounding omega` | omega exploding; wall function mismatch | Verify `omegaWallFunction` on walls; check inlet omega |
| nut becomes very large | Turbulence overprediction | Check inlet I and L values; reduce if unrealistic |
| Residuals stall after initial drop | Wall function y+ mismatch | Run `postProcess -func yPlus`; adjust mesh or WF |
| NaN in turbulence fields | Missing wall function on wall patches | Ensure all wall patches have proper WF BCs for k, omega/epsilon, nut |
