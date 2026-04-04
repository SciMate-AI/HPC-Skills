# OpenFOAM Numerics and Schemes Tuning Guide

Concrete fvSchemes and fvSolution settings with decision tables for scheme selection.

## fvSchemes: Convection Scheme Selection

### Scheme Hierarchy (least to most accurate)

| Scheme | Order | Bounded | Diffusion | Best for |
| --- | --- | --- | --- | --- |
| `upwind` | 1st | Yes | High | Initial stabilization, turbulence scalars |
| `linearUpwind grad(U)` | 2nd | Mostly | Low | **RANS velocity (default choice)** |
| `limitedLinear 1` | 2nd (TVD) | Yes | Low-medium | Scalars, energy, species |
| `LUST grad(U)` | ~2nd (blend) | Mostly | Very low | LES velocity |
| `linear` | 2nd (central) | No | None | Rarely for convection; use for interpolation |

### Recommended Schemes by Application

**Steady RANS (simpleFoam):**
```c++
divSchemes
{
    default         none;
    div(phi,U)      bounded Gauss linearUpwind grad(U);
    div(phi,k)      bounded Gauss upwind;
    div(phi,omega)  bounded Gauss upwind;
    div(phi,epsilon) bounded Gauss upwind;
    div((nuEff*dev2(T(grad(U))))) Gauss linear;
}
```

**Transient RANS (pimpleFoam):**
```c++
divSchemes
{
    default         none;
    div(phi,U)      Gauss linearUpwind grad(U);
    div(phi,k)      Gauss limitedLinear 1;
    div(phi,omega)  Gauss limitedLinear 1;
    div((nuEff*dev2(T(grad(U))))) Gauss linear;
}
```

**LES:**
```c++
divSchemes
{
    default         none;
    div(phi,U)      Gauss LUST grad(U);        // low dissipation for resolved turbulence
    div(phi,k)      Gauss limitedLinear 1;
    div((nuEff*dev2(T(grad(U))))) Gauss linear;
}
```

**VOF (interFoam):**
```c++
divSchemes
{
    div(rhoPhi,U)   Gauss linearUpwind grad(U);
    div(phi,alpha)  Gauss vanLeer;             // bounded for phase fraction
    div(phirb,alpha) Gauss linear;             // interface compression
    div(((rho*nuEff)*dev2(T(grad(U))))) Gauss linear;
}
```

### The `bounded` Keyword

Adding `bounded` to steady-state schemes subtracts a term proportional to the continuity error. This:
- Aids convergence during transient startup
- Vanishes at convergence (does not affect final solution)
- **Required for steady-state RANS** with convection schemes
- Not needed for transient solvers (the time derivative provides the bounding)

### Gradient Schemes and Limiters

```c++
gradSchemes
{
    default         Gauss linear;
    grad(U)         cellLimited Gauss linear 1;    // limited for stability
}
```

Gradient limiters prevent overshoots. Use `cellLimited` for:
- Poor mesh quality (non-orthogonality > 60°)
- External aerodynamics (sharp gradients at body surface)
- Any case where `linearUpwind` oscillates

The limiter coefficient (0–1): 1 = strongest limiting (most stable), 0 = no limiting.

### Laplacian and snGrad Schemes

| Mesh quality | laplacianSchemes | snGradSchemes |
| --- | --- | --- |
| Orthogonal | `Gauss linear corrected` | `corrected` |
| Moderate non-ortho (< 70°) | `Gauss linear corrected` | `corrected` |
| Poor non-ortho (> 70°) | `Gauss linear limited corrected 0.5` | `limited corrected 0.5` |
| Very poor (> 80°) | `Gauss linear limited corrected 0.33` | `limited corrected 0.33` |

### Time Discretization

| Scheme | Order | Bounded | Use when |
| --- | --- | --- | --- |
| `steadyState` | — | — | Steady solvers (simpleFoam) |
| `Euler` | 1st | Yes | Startup, VOF, stability priority |
| `backward` | 2nd | No | Production transient, LES |
| `CrankNicolson 0.9` | ~2nd | Blended | Compromise: stability + accuracy |
| `localEuler` | 1st (local) | Yes | Pseudo-transient acceleration for steady |

## fvSolution: Linear Solver Selection

### Pressure Solver

```c++
p
{
    solver          GAMG;           // Geometric-Algebraic Multi-Grid; best for pressure
    smoother        GaussSeidel;    // or DIC (faster but less robust)
    tolerance       1e-6;
    relTol          0.01;           // 0 for transient final corrector
    nPreSweeps      0;
    nPostSweeps     2;
    cacheAgglomeration true;
    agglomerator    faceAreaPair;
    nCellsInCoarsestLevel 10;
    mergeLevels     1;
}
```

### Velocity and Scalar Solvers

```c++
U
{
    solver          smoothSolver;
    smoother        symGaussSeidel;  // or GaussSeidel
    tolerance       1e-7;
    relTol          0.01;
}
"(k|omega|epsilon)"
{
    solver          smoothSolver;
    smoother        symGaussSeidel;
    tolerance       1e-7;
    relTol          0.01;
}
```

### Final Corrector (Transient)

```c++
pFinal
{
    $p;
    relTol          0;     // force full convergence on final corrector
}
UFinal
{
    $U;
    relTol          0;
}
```

## Relaxation Factors

### Steady-State (SIMPLE)

| Variable | Conservative | Standard | Aggressive |
| --- | --- | --- | --- |
| p | 0.2 | 0.3 | 0.5 |
| U | 0.5 | 0.7 | 0.9 |
| k | 0.3 | 0.5 | 0.7 |
| omega/epsilon | 0.3 | 0.5 | 0.7 |
| T (energy) | 0.3 | 0.5 | 0.7 |

Start conservative. Increase gradually after initial stability is established.

Format in fvSolution:
```c++
relaxationFactors
{
    fields
    {
        p       0.3;
    }
    equations
    {
        U       0.7;
        k       0.5;
        omega   0.5;
    }
}
```

### Transient (PIMPLE)

Generally use relaxation factor = 1 (no under-relaxation) for the final iteration:
```c++
relaxationFactors
{
    equations
    {
        ".*"        0.7;        // under-relax during outer iterations
        ".*Final"   1.0;        // no relaxation on final iteration
    }
}
```

## Algorithm Controls

### SIMPLE (Steady)

```c++
SIMPLE
{
    nNonOrthogonalCorrectors 1;
    consistent      yes;         // SIMPLEC variant (faster, less relaxation needed)
    pRefCell        0;           // needed for enclosed domains
    pRefValue       0;
    residualControl
    {
        p       1e-4;
        U       1e-4;
        "(k|omega|epsilon)" 1e-4;
    }
}
```

### PIMPLE (Transient)

```c++
PIMPLE
{
    nOuterCorrectors    2;       // 1 = PISO; >1 = PIMPLE (allows larger Co)
    nCorrectors         2;       // pressure corrections per outer loop
    nNonOrthogonalCorrectors 1;
    turbOnFinalIterOnly false;   // true = faster; false = more stable
}
```

### PISO (Simple Transient)

```c++
PISO
{
    nCorrectors     2;
    nNonOrthogonalCorrectors 1;
}
```

## Progressive Scheme Upgrade Strategy

For difficult cases, start simple and upgrade:

```
Phase 1 (stability):  upwind + Euler + aggressive relaxation → run 500 iterations
Phase 2 (accuracy):   linearUpwind + backward + standard relaxation → run to convergence
Phase 3 (refinement): limitedLinear/LUST + backward + loose relaxation → production run
```

Never jump directly to high-order schemes on a new case. Stabilize first, then upgrade.
