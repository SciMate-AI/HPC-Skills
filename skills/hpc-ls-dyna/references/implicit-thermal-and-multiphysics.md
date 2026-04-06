# Implicit, Thermal, And Multiphysics

## Source Focus

- `dynasupport.com/howtos/implicit/elements-and-material-models-available-for-implicit`
- `dynasupport.com/howtos/implicit/implicit-checklist`
- `dynaexamples.com/implicit/*`
- `dynaexamples.com/thermal/*`
- `dynaexamples.com/sph/*`
- `dynaexamples.com/icfd/*`
- `dynaexamples.com/ale-s-ale/*`
- `dynaexamples.com/em/*`
- `dynaexamples.com/dem/*`
- `dynaexamples.com/efg/*`
- `dynaexamples.com/cese/*`
- `dynaexamples.com/show-cases/*`
- `dynaexamples.com/iga/*`

## Implicit Entry Criteria

Read `dynasupport.com/howtos/implicit/implicit-checklist` before enabling implicit. The practical gate is not only solver preference but model compatibility:

- supported element and material combinations
- realistic load stepping
- contact complexity that the nonlinear solve can handle
- boundary conditions compatible with equilibrium seeking

If the model still relies on violent impact, rapidly changing topology, or highly transient contact, stay in explicit.

## Implicit Checklist

Before the first implicit run:

1. confirm all active materials and elements are supported in implicit
2. reduce the model to the minimum nonlinear features required
3. apply loading in controlled increments
4. inspect constraints for hidden rigid-body modes
5. simplify contact wherever possible before tuning convergence

## Implicit Example Lineage

`dynaexamples.com/implicit` includes representative themes such as:

- Yaris static suspension system loading
- springback
- trim and form workflows
- beam buckling
- bolt type assembly or joint behavior
- vibration and mode-tracking style examples

Use these as precedent families for slow structural problems.

## Thermal And Thermo-Mechanical

`dynaexamples.com/thermal` covers:

- thermal stress
- rolling and annealing style heat-treatment examples
- induction heating and welding-style workflows
- battery or thermal runaway style thermal cases

These examples are useful when temperature fields are either the primary unknown or a preload on the structural solve.

## SPH

The SPH section includes classic bird and water impact lineages plus fluid-like free-surface use cases. Use SPH when extreme distortion or fragmentation makes a Lagrangian mesh impractical. Audit particle spacing, boundary treatment, and coupling surfaces carefully.

## ALE And S-ALE

`dynaexamples.com/ale-s-ale` spans explosion, fluid-structure interaction, sloshing, airbag-like gas flow, and incompressible tank or membrane examples. Use ALE when material advection and large fluid deformation must be resolved on a background mesh. Separate pure structural contact issues from fluid coupling issues during debugging.

## ICFD

`dynaexamples.com/icfd` provides both basics and advanced examples such as:

- cylinder flow
- flow over buildings
- tool cooling
- nozzle filling
- stirred tank
- particle separator
- fluid-structure coupling

Use these as precedents for incompressible CFD-style setup, especially when the user wants LS-DYNA-native flow examples instead of OpenFOAM-style workflows.

## EM, DEM, EFG, CESE, And IGA

The examples site also covers:

- EM: eddy currents and resistive heating
- DEM: particle transport and big-data particle handling
- EFG: metal cutting and meshfree forming-style operations
- CESE and dual-CESE: shock bubble interaction and high-speed flow examples
- IGA: tensile and benchmark-style smooth-geometry structural examples

Treat these sections as capability proofs and modeling precedents. Reuse their solver family only when the current problem truly matches the formulation assumptions.

## Multiphysics Guardrails

- Do not mix solver families casually in one deck without a clear coupling plan.
- Do not borrow an advanced example without copying its observability strategy.
- Do not debug coupled problems at full complexity first; reduce to one subsystem, then re-couple.
