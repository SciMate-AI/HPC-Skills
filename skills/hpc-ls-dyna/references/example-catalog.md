# Dynaexamples Catalog

## Source Focus

- `https://www.dynaexamples.com/sitemap`
- representative example pages and keyword subpages on `dynaexamples.com`

## How To Use This Catalog

Use this file to find the closest precedent family before creating a new deck from scratch. Match by physics and workflow, not by superficial geometry.

For a one-page route from problem type to detailed reference and starter, read `navigation-matrix.md` first.

For per-case extraction guidance, load:

- `references/implicit-example-recipes.md`
- `references/thermal-example-recipes.md`
- `references/sph-example-recipes.md`
- `references/ale-s-ale-example-recipes.md`
- `references/welding-example-recipes.md`
- `references/showcase-contact-preload-recipes.md`
- `references/icfd-example-recipes.md`
- `references/em-example-recipes.md`
- `references/nvh-example-recipes.md`
- `references/dem-example-recipes.md`
- `references/cese-example-recipes.md`
- `references/iga-example-recipes.md`
- `references/efg-example-recipes.md`

For stable terminology and branch naming while extending this skill, load:

- `references/terminology-and-branch-glossary.md`

## Introductory Courses And Structural Basics

The site exposes introductory lesson groups and structural examples including:

- Intro by Jim Day
- Intro by Jim Kennedy
- Intro by John Reid
- Intro by Al Tabiei
- Intro by Klaus Weimar
- Examples Manual
- Process Simulation

Within `Examples Manual`, the named buckets are:

- Constrained
- Contact
- Control
- Load
- Material
- Misc
- Rigidwall
- Section

Use the introductory branches for onboarding, one-feature sanity checks, and quick keyword pattern lookups before moving to a heavier industrial example.

## Implicit

The implicit branch contains concrete examples such as:

- Salzburg 2017 linear and nonlinear sets
- Basic Examples
- Basics I
- Adaptive
- Basics II
- Basics III
- Yaris static suspension system loading
- Yaris dynamic suspension system loading
- Yaris static door sag
- springback
- trim and form workflows
- beam buckling

The bolt showcase family also contributes implicit precedents:

- Bolt Type A implicit
- Bolt Type B implicit
- Bolt Type C implicit
- Bolt Type D implicit

Use this section for slow nonlinear structural precedent, convergence studies, preload carryover, and implicit-ready contact reduction.

## Thermal

The thermal branch includes:

- thermal stress
- rolling or process-heating style examples
- metal forming
- induction heating
- thermal expansion
- heat transfer
- steady-state heat transfer
- transient heat transfer
- radiation and convection
- welding
- coupled welding with solids
- coupled welding with shells
- thermal contact and heat flux
- thermal thick and thin shells

Use this section when temperature is either the primary field or an input to structural response.

## SPH

The SPH branch includes explicit named examples:

- Intermediate examples
- Bar I
- Bar II
- Bar III
- Bar IV
- Bar V
- bird strike
- Bird
- Boot
- Foam
- Sieve
- water impact
- Wave-Structure Interaction

Use these when meshless particles are needed for extreme distortion.

## NVH

The NVH branch is much richer than a single label. Concrete named examples include:

- FRF for a rectangular plate
- FRF for a cantilever with pre-stress condition
- FRF for a column model with a hole (solid elements)
- Nodal/Resultant force FRF
- FRF of a plate with pressure
- ERP for a simplified engine model
- Fatigue analysis based on SSD
- Random vibration with pressure load
- Cantilever beam I
- Cantilever beam II
- Random vibration with thermal preload I
- A mass-spring model
- Correlated multiple nodal forces
- An aluminium bracket
- An aluminium beam
- BEM acoustics of a rectangular plate I
- BEM acoustics of a rectangular plate II
- BEM acoustics of a rectangular plate III
- BEM acoustics of a beam subjected to SSD
- BEM acoustics of a simple car model
- BEM acoustics of a tunnel model
- BEM acoustics of a simplified compartment model
- Response spectrum analysis of a simple block model
- Response spectrum analysis of a simplified multi-story building model
- Simple break
- Square tube
- Square bar

Use this section when the task is frequency response, random vibration, acoustic BEM, fatigue in the frequency domain, brake squeal, or response spectrum analysis rather than crash or forming.

## ICFD

The ICFD branch has four major groups and many concrete cases:

- basics examples
- advanced examples
- beta examples
- intermediate examples

Representative cases include:

- `cylinder_flow`
- Basics: Cylinder flow
- Intermediate: Dam break on shallow wet bed
- Intermediate: Dam break with elastic gate
- Intermediate: Flow over elastic roof
- Intermediate: Free falling wedge
- Intermediate: FSI tutorial flap
- Intermediate: FSI - 2 Flaps
- Intermediate: Pipe junction
- Intermediate: Resin Transfer Molding (RTM)
- Intermediate: SPHERIC Test 2
- Intermediate: SPHERIC Test 10
- Intermediate: Turek and Hron Benchmark
- Intermediate: Vortex excited elastic plate
- Intermediate: Water impact on rigid column
- Intermediate: Wave Impact on Elastic structure
- Intermediate: Thermal Pipe
- Intermediate: Pressure wave in a straight cylindrical vessel
- Intermediate: Vena Cava
- Intermediate: Bridge Flutter
- Intermediate: Mold filling problem
- Advanced: Flow through a funnel
- Advanced: Fluid Elastic Body Interaction
- Advanced: Tuned Liquid Damper
- Advanced: Pillar submerged in deep sea
- Advanced: Blood flow
- Advanced: DrivAer Model
- Advanced: Wind Turbine
- Advanced: Centrifugal Blood Pump Flow
- Advanced: Jet Impingement model
- Advanced: Heart Valve
- Beta: Tool cooling
- Beta: Sinking Sphere

Use ICFD when the main problem is incompressible flow or thermal-fluid performance.

## ALE And S-ALE

The ALE branch includes:

- Intermediate Example
- Advection
- explosion
- Bird
- Pipe
- FSI
- Misc
- sloshing
- Taylor Bar

The S-ALE branch currently exposes:

- Adiabatic Expansion

Use these for Eulerian or semi-Eulerian fluid domains with structural coupling.

## EM

The EM section is a full tutorial family, not just two examples. Concrete branches and example names include:

- Tutorial Resistive heating
- Tutorial Battery modelling
- Tutorial Resistance Spot Welding
- Tutorial Eddy Currents
- Tutorial Electrophysiology
- Tutorial RadioFrequency (RF) heating
- Basic Eddy current problem set up
- Electromagnetic forming problem
- Tube expansion problem
- Inductive heating problem
- Railgun
- Axisymmetric problem
- 2D Axisymmetric Inductive heating
- Coilgun
- Lenz's Law: Magnet Through a Copper Tube
- Arago's disk
- Laminate sheet closure using magnets
- Magnets snapping
- Pancake coil Inductive heating
- D.C Electric motor
- Voltage Driven Coil
- TEAM 1 problem
- TEAM 13 problem
- TEAM 20 problem
- TEAM 24 Problem

Use these when electromagnetic loading or Joule heating is central.

## DEM

The DEM section currently exposes:

- Injection Analysis

Use this branch when discrete particle transport, filling, storage, discharge, or granular-flow interaction are the main objectives.

## EFG

The EFG branch includes:

- metal cutting
- Metal Cutting

Use this as a precedent for meshfree severe-deformation or cutting workflows.

## CESE And Dual-CESE

The CESE and DUAL-CESE section includes:

- DUAL-CESE
- CESE
- Sod shock tube example
- Moving shock wave diffraction
- shock bubble interaction

Use this family when the target problem is shock-dominated fluid flow rather than solid mechanics.

## Showcases

The showcase area highlights:

- contact overview
- Contact Interference
- Drop Test
- Joint Screw
- Joint Rev/Trans
- preload
- Bolts
- Bolt Type A
- Bolt Type B
- Bolt Type C
- Bolt Type D

Use these for interface strategy and assembly/preload sequence ideas.

## IGA

The IGA branch includes:

- tensile test
- Tensile Test
- benchmark-style demonstrations

Use it when the user explicitly requests isogeometric analysis or smooth high-order geometry representation.

## Practical Retrieval Pattern

When you need an example:

1. choose the physics branch above
2. find the closest geometry and loading analogy
3. inspect the keywords subpage if available
4. port only the formulation, control, and observability logic that survives the unit system and boundary-condition change
