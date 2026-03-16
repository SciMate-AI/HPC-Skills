# FEniCS PDE Template Cookbook

## Contents

- Poisson and diffusion
- Mixed Poisson
- Stokes and incompressible flow
- Elasticity and hyperelasticity
- Cahn-Hilliard style phase-field problems

## Poisson and diffusion

Use the standard scalar elliptic template when the PDE is diffusion-dominated or reduces to Poisson form.

Canonical structure:

- scalar Lagrange space
- `TrialFunction` and `TestFunction` for linear form
- Dirichlet conditions applied on the scalar space
- source term enters the linear functional

Use this family for:

- steady heat conduction
- electrostatic potential
- pressure correction subproblems that reduce to scalar diffusion

## Mixed Poisson

The official mixed Poisson demo is the reference pattern when both flux and scalar are primary unknowns.

Use it when:

- flux is not just derived output but a constrained unknown
- `H(div)` conformity matters
- local conservation is important

Stable pattern from the official demo:

- Raviart-Thomas space for flux-like unknown
- discontinuous Lagrange space for the scalar

If the user explicitly cares about flux accuracy or local conservation, do not default back to a simple scalar Poisson template.

## Stokes and incompressible flow

The official demos include Taylor-Hood Stokes and divergence-conforming Navier-Stokes.

Use a Stokes-like mixed formulation when:

- velocity and pressure are coupled primary unknowns
- incompressibility is essential
- the user is solving creeping flow, low-Re flow, or a steady subproblem of Navier-Stokes

Use a stable velocity-pressure pair rather than trying to patch an unstable pair with solver tweaks.

## Elasticity and hyperelasticity

Official demos cover both linear elasticity and hyperelasticity.

Decision pattern:

- small-strain linear constitutive law -> linear elasticity template
- geometrically or materially nonlinear large deformation -> hyperelastic or nonlinear mechanics template

If the stored energy or stress depends nonlinearly on deformation, move directly to a nonlinear residual/Jacobian workflow.

## Cahn-Hilliard style phase-field problems

The official DOLFINx demo set includes Cahn-Hilliard.

Use this family when:

- there is a conserved order parameter
- diffusion is driven by a chemical potential
- fourth-order behavior is rewritten as a mixed lower-order system

This is not a scalar Poisson variant. Treat it as a coupled system with its own stability and timestep considerations.
