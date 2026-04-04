# OpenFOAM Heat Transfer and Compressible Recipes

Concrete setup for buoyant, compressible, and conjugate heat transfer cases.

## When to Leave Incompressible Templates

| Physics | Solver | Key difference |
| --- | --- | --- |
| Isothermal incompressible | simpleFoam / pimpleFoam | No energy equation, p is kinematic |
| Forced convection (small ΔT) | buoyantSimpleFoam | Energy equation, p_rgh, Boussinesq OK |
| Natural convection (large ΔT) | buoyantSimpleFoam / buoyantPimpleFoam | Full buoyancy, thermophysical model |
| Compressible (Ma > 0.3) | rhoPimpleFoam / rhoSimpleFoam | Density varies with pressure; hePsiThermo |
| Conjugate heat transfer | chtMultiRegionFoam | Multi-region: fluid + solid coupling |

Do not bolt temperature onto an incompressible template without checking solver-family requirements.

## thermophysicalProperties Templates

### Incompressible with Temperature (Boussinesq)

```c++
thermoType
{
    type            heRhoThermo;
    mixture         pureMixture;
    transport       const;
    thermo          hConst;
    equationOfState Boussinesq;
    specie          specie;
    energy          sensibleEnthalpy;
}
mixture
{
    specie      { molWeight 28.96; }
    thermodynamics { Cp 1004.4; Hf 0; }
    transport   { mu 1.831e-05; Pr 0.705; }
    equationOfState { rho0 1.225; T0 300; beta 3.33e-03; }
}
```

### Ideal Gas (Compressible)

```c++
thermoType
{
    type            hePsiThermo;
    mixture         pureMixture;
    transport       sutherland;
    thermo          hConst;
    equationOfState perfectGas;
    specie          specie;
    energy          sensibleEnthalpy;
}
mixture
{
    specie      { molWeight 28.96; }
    thermodynamics { Cp 1004.4; Hf 0; }
    transport   { As 1.67212e-06; Ts 170.672; }
}
```

### Density-Based with Perfect Gas

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

### Common Fluid Properties

| Fluid | molWeight | Cp [J/kg/K] | mu [Pa.s] | Pr | rho [kg/m^3] |
| --- | --- | --- | --- | --- | --- |
| Air (300K) | 28.96 | 1004.4 | 1.831e-05 | 0.705 | 1.225 |
| Water (300K) | 18.015 | 4182 | 8.9e-04 | 6.13 | 998.2 |
| Air (Sutherland) | 28.96 | 1004.4 | As=1.67e-06, Ts=170.7 | — | ideal gas |

## Buoyant and Thermophysical Field Sets

Mandatory fields for buoyantSimpleFoam / buoyantPimpleFoam:
- `U`, `p`, `p_rgh`, `T`
- Turbulence fields (k, omega/epsilon, nut) if turbulent
- `alphat` (turbulent thermal diffusivity)

Required constant/ files:
- `thermophysicalProperties`
- `turbulenceProperties`
- `g` (gravity vector)

### Gravity File

```c++
// constant/g
dimensions      [0 1 -2 0 0 0 0];
value           (0 -9.81 0);
```

### alphat Wall BC

```c++
// 0/alphat
walls
{
    type            compressible::alphatWallFunction;
    Prt             0.85;
    value           uniform 0;
}
```

## Pressure Conventions

| Solver type | Pressure variable | Dimensions | Notes |
| --- | --- | --- | --- |
| Incompressible (simpleFoam) | p (= P/rho) | [0 2 -2 0 0 0 0] | Kinematic pressure |
| Buoyant (buoyantSimpleFoam) | p_rgh (= p - rho*g*h) | [1 -1 -2 0 0 0 0] | Modified pressure |
| Compressible (rhoPimpleFoam) | p | [1 -1 -2 0 0 0 0] | Thermodynamic pressure |
| VOF (interFoam) | p_rgh | [1 -1 -2 0 0 0 0] | Hydrostatic removed |

**Critical:** Using the wrong pressure variable causes silent errors. Always match solver expectations.

## Conjugate Heat Transfer (chtMultiRegionFoam)

### Case Directory Structure

```
case/
├── 0/
│   ├── fluid/    (U, p_rgh, T, k, omega, nut, alphat)
│   └── solid/    (T)
├── constant/
│   ├── fluid/    (thermophysicalProperties, turbulenceProperties, polyMesh/)
│   ├── solid/    (thermophysicalProperties, polyMesh/)
│   └── regionProperties
├── system/
│   ├── fluid/    (fvSchemes, fvSolution, decomposeParDict)
│   ├── solid/    (fvSchemes, fvSolution, decomposeParDict)
│   ├── controlDict, decomposeParDict, topoSetDict
```

### regionProperties

```c++
// constant/regionProperties
regions ( fluid (fluid) solid (solid) );
```

### Solid thermophysicalProperties

```c++
thermoType
{
    type            heSolidThermo;
    mixture         pureMixture;
    transport       constIso;
    thermo          hConst;
    equationOfState rhoConst;
    specie          specie;
    energy          sensibleEnthalpy;
}
mixture
{
    specie      { molWeight 56; }
    transport   { kappa 80; }
    thermodynamics { Cp 450; Hf 0; }
    equationOfState { rho 7870; }
}
```

### Common Solid Properties

| Material | rho [kg/m^3] | Cp [J/kg/K] | kappa [W/m/K] |
| --- | --- | --- | --- |
| Steel | 7870 | 450 | 80 |
| Aluminum | 2700 | 900 | 237 |
| Copper | 8960 | 385 | 401 |
| Glass | 2500 | 840 | 1.0 |

### Fluid-Solid Interface Coupling BCs

```c++
// Fluid side:
fluid_to_solid
{
    type            compressible::turbulentTemperatureCoupledBaffleMixed;
    Tnbr            T;
    kappaMethod     fluidThermo;
    value           uniform 300;
}
// Solid side:
solid_to_fluid
{
    type            compressible::turbulentTemperatureCoupledBaffleMixed;
    Tnbr            T;
    kappaMethod     solidThermo;
    value           uniform 300;
}
```

### CHT Workflow

```bash
blockMesh → topoSet → splitMeshRegions -cellZones -overwrite
→ set BCs per region → decomposePar -allRegions
→ mpirun -np N chtMultiRegionFoam -parallel → reconstructPar -allRegions
```

## Temperature Boundary Conditions

```c++
// Fixed temperature wall
hotWall { type fixedValue; value uniform 350; }

// Adiabatic wall
insulatedWall { type zeroGradient; }

// Heat flux wall
heatFluxWall
{
    type  externalWallHeatFluxTemperature;
    mode  flux;
    q     uniform 1000;      // W/m^2
    kappaMethod fluidThermo;
    value uniform 300;
}

// Convective heat transfer
outerWall
{
    type  externalWallHeatFluxTemperature;
    mode  coefficient;
    h     uniform 10;        // W/m^2/K
    Ta    uniform 293;       // ambient temperature
    kappaMethod fluidThermo;
    value uniform 300;
}
```

## Common Heat Transfer Pitfalls

1. **Wrong thermoType**: hePsiThermo vs heRhoThermo must match solver expectation.
2. **Missing alphat field**: Turbulent thermal diffusivity needed for all turbulent heat transfer.
3. **Missing g file**: Buoyant solvers crash without `constant/g`.
4. **Boussinesq with large ΔT**: Use ideal gas if ΔT > 30K (Boussinesq is a linearization).
5. **CHT mesh alignment**: Fluid-solid interface must share patch faces.
6. **Copying simpleFoam case for heat transfer**: Missing thermophysical models and p_rgh.
