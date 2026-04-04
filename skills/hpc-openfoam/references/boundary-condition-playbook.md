# OpenFOAM Boundary Condition Playbook

Concrete boundary condition syntax for every common field and patch type.

## Patch Naming Contract

Each patch name must agree across:
- the mesh boundary definition (`constant/polyMesh/boundary`)
- every field file in the start-time directory (`0/U`, `0/p`, `0/k`, etc.)
- any function object or sampling setup

If the mesh says `inlet` and a field file says `Inlet`, the case is broken. Case-sensitive match is mandatory.

## Patch-Type Decisions

Choose from geometry, not desired field value:

| Patch type | Use when | Notes |
| --- | --- | --- |
| `wall` | Physical solid surface | Triggers wall functions, no-slip |
| `patch` | Generic boundary (inlet, outlet, far-field) | No geometric constraint |
| `symmetryPlane` | True geometric symmetry plane | Zero normal gradient for all fields |
| `empty` | Front/back of 2D mesh (one cell thick) | Mandatory for 2D cases |
| `wedge` | Axisymmetric wedge (5-degree sector) | Must come in paired wedge patches |
| `cyclic` | Periodic boundaries (translational) | Must define matching patch pair |
| `cyclicAMI` | Non-conformal periodic (e.g., sliding mesh) | Needs AMI weights |

## Velocity Boundary Conditions

### Inlet

```c++
inlet
{
    type            fixedValue;
    value           uniform (5 0 0);     // m/s in x-direction
}
```

For mapped/profiled inlet:
```c++
inlet
{
    type            fixedProfile;
    profile         csvFile;
    // ... profile specification
}
```

### Outlet

```c++
outlet
{
    // Option 1: zero-gradient (most common for velocity at pressure outlet)
    type            zeroGradient;
}
```

```c++
outlet
{
    // Option 2: inletOutlet (handles backflow safely)
    type            inletOutlet;
    inletValue      uniform (0 0 0);    // velocity if flow reverses
    value           uniform (0 0 0);
}
```

```c++
outlet
{
    // Option 3: pressureInletOutletVelocity (for pressure-driven outlet)
    type            pressureInletOutletVelocity;
    value           uniform (0 0 0);
}
```

### Wall

```c++
walls
{
    type            noSlip;              // zero velocity; simplest wall BC
}
```

```c++
movingWall
{
    type            fixedValue;
    value           uniform (1 0 0);     // sliding wall at 1 m/s
}
```

### Symmetry / Far-field

```c++
symmetryPlane
{
    type            symmetryPlane;       // automatic zero normal component
}
```

```c++
farField
{
    type            freestream;
    freestreamValue uniform (10 0 0);    // external aero far-field
}
```

## Pressure Boundary Conditions

### Incompressible (p or p/rho)

```c++
inlet
{
    type            zeroGradient;        // pressure floats at inlet
}

outlet
{
    type            fixedValue;
    value           uniform 0;           // reference pressure at outlet
}

walls
{
    type            zeroGradient;        // no pressure gradient into wall
}
```

### Compressible / Buoyant (p_rgh)

```c++
inlet
{
    type            fixedFluxPressure;   // adjusts pressure to satisfy flux constraint
    value           uniform 0;
}

outlet
{
    type            prghTotalPressure;   // total pressure for buoyant flows
    p0              uniform 1e5;
    value           uniform 1e5;
}

walls
{
    type            fixedFluxPressure;
    value           uniform 0;
}
```

### Atmosphere (open top for VOF)

```c++
atmosphere
{
    type            totalPressure;
    p0              uniform 0;
    value           uniform 0;
}
```

## Turbulence Field Boundary Conditions

### k-omega SST Wall Functions (Standard RANS)

**k at walls:**
```c++
walls
{
    type            kqRWallFunction;     // zero-gradient; y+-insensitive
    value           uniform 0.1;         // initial value (will be overwritten)
}
```

**omega at walls:**
```c++
walls
{
    type            omegaWallFunction;   // blends viscous/log layer automatically
    value           uniform 100;         // initial value
}
```

**nut at walls:**
```c++
walls
{
    type            nutUSpaldingWallFunction;  // continuous nut profile; y+-insensitive
    value           uniform 0;
}
```

### k-epsilon Wall Functions

**k at walls:**
```c++
walls
{
    type            kqRWallFunction;
    value           uniform 0.1;
}
```

**epsilon at walls:**
```c++
walls
{
    type            epsilonWallFunction;
    value           uniform 10;
}
```

**nut at walls:**
```c++
walls
{
    type            nutUSpaldingWallFunction;
    value           uniform 0;
}
```

### Turbulence Inlet Values

Estimate from turbulence intensity and length scale:

```
k     = 1.5 * (I * U_ref)^2
epsilon = C_mu^0.75 * k^1.5 / L
omega = k^0.5 / (C_mu^0.25 * L)
```

Where: I = turbulence intensity (0.01–0.10), U_ref = reference velocity, L = turbulent length scale (~0.07 * D_hydraulic), C_mu = 0.09.

**Example for U=5 m/s, I=5%, L=0.007 m:**
```
k     = 1.5 * (0.05 * 5)^2 = 0.09375 m^2/s^2
omega = 0.09375^0.5 / (0.09^0.25 * 0.007) = 79.8 s^-1
epsilon = 0.09^0.75 * 0.09375^1.5 / 0.007 = 1.18 m^2/s^3
```

**Inlet BC using intensity (auto-calculates k):**
```c++
inlet
{
    type            turbulentIntensityKineticEnergyInlet;
    intensity       0.05;       // 5% turbulence intensity
    value           uniform 0.1;
}
```

**Inlet BC for omega:**
```c++
inlet
{
    type            fixedValue;
    value           uniform 80;  // calculated from formula above
}
```

### Turbulence at Outlet

```c++
outlet
{
    type            inletOutlet;
    inletValue      uniform 0.01;    // safe fallback for backflow
    value           uniform 0.01;
}
```

## Temperature Boundary Conditions

```c++
inlet
{
    type            fixedValue;
    value           uniform 300;     // K
}

outlet
{
    type            inletOutlet;
    inletValue      uniform 300;
    value           uniform 300;
}

hotWall
{
    type            fixedValue;
    value           uniform 350;     // fixed temperature wall
}

insulatedWall
{
    type            zeroGradient;    // adiabatic wall
}

heatFluxWall
{
    type            externalWallHeatFluxTemperature;
    mode            flux;
    q               uniform 1000;    // W/m^2
    kappaMethod     fluidThermo;
    value           uniform 300;
}
```

## Failure Patterns to Catch Early

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Missing patch in field file | Patch name mismatch or missing entry | Match names exactly to `constant/polyMesh/boundary` |
| `cyclic` patch treated as inlet | Wrong patch type in boundary file | Fix `constant/polyMesh/boundary` or use `changeDictionary` |
| 2D case uses `patch` on front/back | Should be `empty` | Change to `empty` in boundary and all field files |
| Turbulence enabled but fields missing | No k/omega/epsilon/nut files in `0/` | Create all required turbulence field files |
| Both p and U overconstrained | fixedValue on both inlet and outlet for both fields | Release one: typically zeroGradient p at inlet, fixedValue p at outlet |
| Pressure diverges in enclosed domain | No pressure reference point | Add `pRefCell 0; pRefValue 0;` to SIMPLE/PIMPLE dict |
