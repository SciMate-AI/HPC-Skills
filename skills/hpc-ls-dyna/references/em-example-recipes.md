# EM Example Recipes

## Source Focus

- `dynaexamples.com/em`
- `dynaexamples.com/em/eddycurr`
- representative reduced-input pages such as `team13`, `em_forming`, and `em_inductive`

## Use This Reference For

- selecting the correct LS-DYNA EM subfamily
- deciding whether the case is eddy current, magnetostatic, inductive heating, resistive heating, or coupled EM-structural/thermal
- lifting only the EM-specific controls that fit the target application

## Common EM Reuse Pattern

Copy these families only after matching the actual physics:

- `*EM_CONTROL`
- EM-related `*PARAMETER` blocks for micro and macro timestep separation
- structural controls such as `*CONTROL_TERMINATION`, `*CONTROL_TIMESTEP`, and `*DATABASE_BINARY_D3PLOT` when mechanical coupling exists
- conductor and structural `*PART`, `*SECTION_SOLID`, and material cards
- circuit definition patterns for current-driven or voltage-driven coils

Do not copy these blindly:

- solver-version assumptions noted on the example pages
- unit systems, often shown as `(g/mm/s)` or SI
- the exact current amplitudes, conductivities, or convergence tolerances
- monolithic FEM/BEM settings if your model does not need them

## Basic Eddy Current Problem Set Up

Applicable problem:

- first EM activation for a conducting part carrying current or exposed to a changing field

Key solver family:

- eddy-current basics

Copy these controls:

- the minimum `*EM_CONTROL` activation pattern
- conductor material and section wiring
- skin-depth-aware mesh refinement logic

Do not copy blindly:

- mesh density through thickness if frequency and conductivity differ
- any benchmark current amplitude

## Electromagnetic Forming Problem

Applicable problem:

- Lorentz-force driven sheet or tube forming
- pulsed discharge forming with coupled structural motion

Key solver family:

- EM plus structural and thermal coupling

Copy these controls:

- `*EM_CONTROL`
- coil/workpiece partitioning
- R-L-C circuit setup logic
- structural `*CONTROL_TERMINATION` and `*CONTROL_TIMESTEP` coordination with EM solve
- thermal handoff pattern if Joule heating matters

Do not copy blindly:

- the exact discharge circuit values
- workpiece thickness, gap, or stand-off
- the same timestep split if pulse duration changes substantially

## Tube Expansion Problem

Applicable problem:

- coil-driven radial forming or expansion of tubular conductors

Key solver family:

- EM forming with axisymmetric or quasi-axisymmetric geometry

Copy these controls:

- the same EM-control family as plate forming
- axisymmetric partition logic when the geometry supports it

Do not copy blindly:

- the example title or units shown in the reduced input
- axisymmetric simplifications if the true device is not axisymmetric

## Inductive Heating Problem

Applicable problem:

- inductive heating of a workpiece without major structural motion
- process-heating studies where averaged Joule heating drives the thermal response

Key solver family:

- eddy current plus thermal coupling

Copy these controls:

- micro EM timestep logic over one current period
- macro timestep logic for averaged Joule heating handoff to thermal solver
- temperature-dependent update sequencing when required

Do not copy blindly:

- `NUMLS`-based microstep choices without checking current frequency
- the assumption that one macrostep can span the full termination time if material properties or coil position are changing

## Pancake Coil Inductive Heating

Applicable problem:

- local inductive heating with flux concentrators

Key solver family:

- monolithic EM heating with magnetic flux concentration

Copy these controls:

- monolithic solver activation when zero-conductivity and high-permeability parts coexist
- average Joule heating to thermal handoff pattern

Do not copy blindly:

- flux concentrator material assumptions
- coil geometry and stand-off

## TEAM 1 Problem

Applicable problem:

- code verification for transient eddy current diffusion

Key solver family:

- benchmark eddy current verification

Copy these controls:

- benchmark-grade observability and validation mentality

Do not copy blindly:

- any benchmark simplification into production geometry

## TEAM 13 Problem

Applicable problem:

- nonlinear magnetostatic or weakly time-dependent EM validation with steel saturation

Key solver family:

- nonlinear magnetostatic or eddy current monolithic solver

Copy these controls:

- parameterized EM tolerances from the reduced input
- separation of EM and structural timestep parameters
- simple structural placeholder parts when the structure only provides geometry support

Do not copy blindly:

- the example tolerances without checking conditioning
- the choice between magnetostatic and conductive transient paths unless you know whether diffusion matters
- the very large sample current value from the benchmark

## TEAM 20 And TEAM 24

Applicable problem:

- force prediction and actuator/electric machine validation

Key solver family:

- nonlinear magnetostatic or transient actuator solver

Copy these controls:

- benchmark-style torque or force observability
- stranded-coil and voltage-driven coil logic for actuator-like devices

Do not copy blindly:

- machine geometry or test current profiles
- air-domain assumptions if your setup requires explicit field containment elsewhere

## Voltage Driven Coil

Applicable problem:

- when coil voltage is prescribed and current is unknown

Key solver family:

- circuit-coupled EM

Copy these controls:

- voltage input pattern
- turn-count and resistance bookkeeping
- EM material type logic for a stranded coil becoming part of the system

Do not copy blindly:

- the same coil resistance or number of turns

## D.C. Electric Motor

Applicable problem:

- motor torque or field-distribution studies with permanent magnets and armature current

Key solver family:

- advanced transient EM with structural coupling capability

Copy these controls:

- partitioning between magnets, conductors, and mechanical parts
- torque-monitoring mindset

Do not copy blindly:

- motor geometry, commutation assumptions, or magnet properties

## Resistive Heating, Battery Modelling, And Resistance Spot Welding Tutorials

Applicable problem:

- Joule heating dominated electro-thermal problems
- cell discharge, short-circuit, or weld-current process studies

Key solver family:

- resistive-heating EM branches

Copy these controls:

- tutorial folder structure and staged learning path
- electro-thermal material partitioning
- version checks called out by the page

Do not copy blindly:

- tutorial-only branch features into older solver releases
- simplified weld or battery material models into safety-critical studies

