# ICFD Example Recipes

## Source Focus

- `dynaexamples.com/icfd/basics-examples`
- `dynaexamples.com/icfd/intermediate-examples`
- `dynaexamples.com/icfd/advanced-examples`
- `dynaexamples.com/icfd/beta_examples`

## Use This Reference For

- choosing the closest LS-DYNA ICFD precedent
- deciding whether the problem is pure flow, thermal flow, or FSI
- reusing the right `*ICFD_*` controls without dragging along irrelevant case-specific assumptions

## Common ICFD Reuse Pattern

Copy these families only after matching the physics:

- `*ICFD_CONTROL_TIME`
- `*ICFD_CONTROL_OUTPUT`
- `*ICFD_CONTROL_SOLVER`
- `*ICFD_CONTROL_TURBULENCE` when Reynolds number and near-wall treatment justify it
- `*ICFD_INITIAL`
- `*ICFD_MAT`, `*ICFD_PART`, and mesh keywords
- boundary keywords such as `*ICFD_BOUNDARY_PRESCRIBED_VEL`, `*ICFD_BOUNDARY_PRESCRIBED_PRE`, `*ICFD_BOUNDARY_FREESLIP`, `*ICFD_BOUNDARY_NONSLIP`
- drag, timestep, or other ICFD database requests when they map to the engineering outputs

Do not copy these blindly across cases:

- exact timestep values
- turbulence model selection
- far-field distance and outlet placement
- temperature initialization and solid temperature values
- FSI coupling assumptions from elastic benchmark cases
- beta-only controls that may require a special executable

## Basics: Cylinder Flow

Applicable problem:

- first laminar external-flow setup around a bluff body
- drag and recirculation validation
- checking inlet, outlet, far-field, and boundary-layer mesh logic

Key solver family:

- incompressible ICFD basics example

Copy these controls:

- inlet velocity with `*ICFD_BOUNDARY_PRESCRIBED_VEL`
- outlet reference pressure with `*ICFD_BOUNDARY_PRESCRIBED_PRE`
- far-field `*ICFD_BOUNDARY_FREESLIP`
- cylinder `*ICFD_BOUNDARY_NONSLIP`
- mesh generation pattern with boundary-layer focus

Do not copy blindly:

- the coarse mesh density
- the far-field extent if your wake is longer or the object is less slender
- the same outlet location when recirculation reaches the boundary

## Basics: Thermal Flow

Applicable problem:

- forced convection over a hot body
- first conjugate-like thermal-flow setup without full industrial complexity

Key solver family:

- incompressible ICFD with heat equation activated

Copy these controls:

- the flow-side boundary pattern from Cylinder Flow
- the thermal initialization pattern
- prescribed wall or solid temperature treatment
- temperature-aware output cadence for coupled monitoring

Do not copy blindly:

- the example temperatures of 20 C inflow and 80 C hot cylinder
- material properties if the coolant is not the same
- the same thermal timestep if the Peclet and diffusion scales change

## Basics: User Defined Mesh

Applicable problem:

- when mesh is imported from an external generator instead of built with LS-DYNA mesh keywords

Key solver family:

- same ICFD flow family as Cylinder Flow, but with user-supplied volume mesh

Copy these controls:

- the separation between fluid physics cards and mesh import cards
- the boundary-ID driven setup strategy

Do not copy blindly:

- entity or boundary IDs from the original mesh
- assumptions that the imported mesh already has adequate boundary-layer resolution

## Basics: Turbulent Flow

Applicable problem:

- external or internal turbulent flow where Reynolds number is already high enough that laminar setup is invalid

Key solver family:

- incompressible ICFD with turbulence model activated

Copy these controls:

- `*ICFD_CONTROL_TURBULENCE`
- `*ICFD_BOUNDARY_PRESCRIBED_TURBULENCE`
- drag and timestep databases
- boundary-layer meshing concept tied to target `y+`

Do not copy blindly:

- the RANS realizable model choice if the target needs LES or a different wall treatment
- the quoted `Re = 50 000` setup
- the example `y+` target of about 30 unless you intentionally want wall functions

## Basics: Porous Media Flow

Applicable problem:

- pressure drop through porous inserts, screens, or packed media approximations

Key solver family:

- incompressible ICFD with porous-media model

Copy these controls:

- porous region modeling pattern
- Ergun-correlation style setup logic when the medium is well approximated as isotropic porous resistance

Do not copy blindly:

- porous resistance coefficients
- isotropic assumption if the target medium is directional or layered

## Basics: Cylinder Flow FSI

Applicable problem:

- light FSI benchmark where fluid loading drives structural motion
- quick test of one-way versus fully coupled assumptions

Key solver family:

- incompressible ICFD plus structural coupling

Copy these controls:

- the base flow deck from Cylinder Flow
- FSI interface pattern
- structural DOF release logic for a mostly fixed but partially mobile structure

Do not copy blindly:

- the structural timestep simplification used to save cost in the benchmark
- stiffness and mass of the example structural part

## Intermediate: Turek And Hron Benchmark

Applicable problem:

- laminar FSI validation with a cylinder and elastic cantilever
- benchmark-grade code-to-code comparison rather than production geometry

Key solver family:

- monolithic or strongly coupled incompressible FSI benchmark

Copy these controls:

- the benchmark-style output selection
- the coupling pattern for a clamped elastic plate behind a cylinder
- case partitioning into FSI1, FSI2, and FSI3 style difficulty levels

Do not copy blindly:

- benchmark geometry proportions if the real structure is not beam-like
- laminar assumptions if your operating Reynolds number is turbulent

## Intermediate: Bridge Flutter

Applicable problem:

- aeroelastic civil-structure response
- flutter and galloping onset studies

Key solver family:

- strong FSI with deformable structure

Copy these controls:

- the FSI observability pattern
- elastic-structure coupling setup

Do not copy blindly:

- benchmark wind speed or structural stiffness without modal justification
- any reduced model if the real bridge has torsional modes outside the example range

## Intermediate: Dam Break With Elastic Gate

Applicable problem:

- free-surface impact on flexible boundaries
- transient hydroelastic loading

Key solver family:

- transient ICFD with moving boundary and structural coupling

Copy these controls:

- transient control pattern
- interface motion and pressure monitoring strategy

Do not copy blindly:

- fluid depth and gate thickness
- damping implicit in the benchmark geometry

## Intermediate: Pipe Junction And Thermal Pipe

Applicable problem:

- coolant manifolds, branching channels, mixing, and thermal transport in piping

Key solver family:

- incompressible internal flow, optionally with thermal transport

Copy these controls:

- multi-inlet and multi-outlet boundary bookkeeping
- thermal activation pattern from the thermal pipe case

Do not copy blindly:

- branch flow split assumptions
- wall temperature prescriptions if the plant side is conjugate rather than fixed-temperature

## Advanced: Flow Through A Funnel

Applicable problem:

- converging internal passages and strong acceleration zones

Key solver family:

- advanced internal ICFD flow

Copy these controls:

- output placement through contraction regions
- mesh refinement strategy near acceleration and separation zones

Do not copy blindly:

- funnel geometry ratios
- inlet turbulence assumptions if upstream conditioning differs

## Advanced: Fluid Elastic Body Interaction

Applicable problem:

- high-fidelity FSI where structure deformation materially changes flow

Key solver family:

- advanced coupled ICFD-FSI

Copy these controls:

- coupling cadence and output strategy
- structural and fluid partition hygiene

Do not copy blindly:

- solver tolerances from the example if your mesh count differs by orders of magnitude

## Advanced: Blood Flow, Heart Valve, And Centrifugal Blood Pump Flow

Applicable problem:

- biofluid devices and pulsatile internal flow

Key solver family:

- internal incompressible flow with moving or deforming boundaries

Copy these controls:

- internal-flow pressure/velocity boundary style
- transient monitoring strategy at clinically relevant sections

Do not copy blindly:

- viscosity and density if the modeled fluid is not blood
- moving-boundary assumptions if the device is stationary

## Advanced: DrivAer Model And Wind Turbine

Applicable problem:

- external aero with real-world geometry complexity

Key solver family:

- large-scale external ICFD

Copy these controls:

- force and wake observability approach
- wall and far-field partitioning strategy

Do not copy blindly:

- turbulence model choice without `y+` and separation validation
- domain dimensions if blockage ratio changes

## Beta: Tool Cooling

Applicable problem:

- cooling-channel and conjugate heat-transfer studies for tools, molds, or inserts

Key solver family:

- beta ICFD thermal/coupled flow

Copy these controls:

- two-path strategy described on the page:
  transient fluid plus LES until steady flow is reached, then thermal-only continuation
  or steady-state fluid plus RANS `k-epsilon` before thermal coupling
- thermal parameter partitioning for fluid and solid timesteps
- explicit separation of inlet temperature, tool temperature, and blank or workpiece temperature

Do not copy blindly:

- beta-only keywords into a production solver build
- the exact values shown in the reduced input, such as `v_inlet`, `T_tool`, or `dt_fluid`
- LES choice if mesh is not fine enough to support it

## Beta: Sinking Sphere

Applicable problem:

- particle or rigid-body motion through fluid where added mass and transient drag matter

Key solver family:

- transient ICFD with moving body

Copy these controls:

- moving-body monitoring setup
- transient output cadence around acceleration onset

Do not copy blindly:

- body density ratio or gravity scaling from the example

