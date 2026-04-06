# NVH Example Recipes

## Source Focus

- `dynaexamples.com/nvh`
- representative reduced-input pages such as `exdample_04_01`

## Use This Reference For

- mapping an NVH request to FRF, SSD, PSD/random vibration, fatigue, acoustics, response spectrum, or brake squeal
- identifying the exact frequency-domain keyword family to reuse
- separating reusable analysis controls from case-specific excitations, damping, and post-processing choices

## Common NVH Reuse Pattern

Copy these families only after matching the problem class:

- `*FREQUENCY_DOMAIN_FRF`
- `*FREQUENCY_DOMAIN_SSD`, `*FREQUENCY_DOMAIN_SSD_ERP`, or `*FREQUENCY_DOMAIN_SSD_FATIGUE`
- `*FREQUENCY_DOMAIN_RANDOM_VIBRATION_FATIGUE`
- `*FREQUENCY_DOMAIN_ACOUSTIC_BEM` or `*FREQUENCY_DOMAIN_ACOUSTIC_FEM`
- `*FREQUENCY_DOMAIN_RESPONSE_SPECTRUM`
- `*CONTROL_IMPLICIT_EIGENVALUE`, `*CONTROL_IMPLICIT_GENERAL`, and related implicit/frequency-domain controls
- `*INTERFACE_SPRINGBACK_LSDYNA` when preload or prestress is explicitly part of the workflow
- frequency-domain database cards such as `*DATABASE_FREQUENCY_BINARY_D3SSD`, `*DATABASE_FREQUENCY_BINARY_D3PSD`, `*DATABASE_FREQUENCY_BINARY_D3RMS`, `*DATABASE_FREQUENCY_BINARY_D3FTG`, and `*DATABASE_FREQUENCY_BINARY_D3SPCM`

Do not copy these blindly:

- frequency range, step count, and damping model
- PSD amplitude levels and correlation assumptions
- acoustic boundary conditions and impedance values
- modal truncation and eigenvalue count
- pre-stress dynain workflow if the target problem is linearized around the undeformed state

## FRF For A Rectangular Plate

Applicable problem:

- first frequency-response function setup under nodal-force excitation
- comparing constant damping against mode-dependent damping

Key solver family:

- `*FREQUENCY_DOMAIN_FRF`

Copy these controls:

- `*FREQUENCY_DOMAIN_FRF`
- `*CONTROL_IMPLICIT_EIGENVALUE`
- `*CONTROL_IMPLICIT_GENERAL`
- `*CONTROL_IMPLICIT_NONLINEAR`
- shell control style if the target is also a shell benchmark

Do not copy blindly:

- the exact frequency range and number of frequency points shown in the reduced input
- the plate geometry or boundary conditions

## FRF For A Cantilever With Pre-Stress Condition

Applicable problem:

- FRF about a preloaded or prestressed operating point

Key solver family:

- FRF plus prestress transfer

Copy these controls:

- `*INTERFACE_SPRINGBACK_LSDYNA` to generate `dynain`
- `*INCLUDE`-based prestress import workflow
- intermittent eigenvalue analysis pattern

Do not copy blindly:

- the same preload state if the target structure has different nonlinear stiffening

## FRF For A Column Model With A Hole

Applicable problem:

- FRF under base acceleration for a solid-dominant part

Key solver family:

- `*FREQUENCY_DOMAIN_FRF` for solid models

Copy these controls:

- acceleration-driven FRF setup
- output-node selection strategy at multiple locations

Do not copy blindly:

- hole geometry or support condition

## Nodal/Resultant Force FRF

Applicable problem:

- frequency-domain force recovery, not just displacement or acceleration response

Key solver family:

- FRF with nodal/resultant output

Copy these controls:

- `*DATABASE_NODAL_FORCE_GROUP`
- force-output mapping tied to FRF excitation

Do not copy blindly:

- grouping definitions if load paths differ

## ERP For A Simplified Engine Model

Applicable problem:

- equivalent radiated power from a vibrating structure

Key solver family:

- `*FREQUENCY_DOMAIN_SSD_ERP`

Copy these controls:

- SSD/ERP setup
- `*DATABASE_FREQUENCY_BINARY_D3SSD` for post-processing

Do not copy blindly:

- simplified engine mounting and base acceleration assumptions

## Fatigue Analysis Based On SSD

Applicable problem:

- sine-sweep or steady-state-dynamics fatigue qualification

Key solver family:

- `*FREQUENCY_DOMAIN_SSD_FATIGUE`

Copy these controls:

- `*DATABASE_FREQUENCY_BINARY_D3SSD`
- `*DATABASE_FREQUENCY_BINARY_D3FTG`

Do not copy blindly:

- bumper-like geometry and fatigue calibration

## Random Vibration With Pressure Load

Applicable problem:

- PSD-driven panel response under distributed pressure loading

Key solver family:

- PSD/random-vibration frequency-domain analysis

Copy these controls:

- PSD output cards:
  `*DATABASE_FREQUENCY_ASCII_NODOUT_PSD`
  `*DATABASE_FREQUENCY_ASCII_ELOUT_PSD`
  `*DATABASE_FREQUENCY_BINARY_D3PSD`

Do not copy blindly:

- pressure PSD levels
- pressure spatial distribution

## Cantilever Beam I, Cantilever Beam II, Tube Model, Mass-Spring Model, Correlated Multiple Nodal Forces

Applicable problem:

- compact PSD studies with known modal content
- verifying RMS and PSD output workflows
- studying correlated versus uncorrelated loading

Key solver family:

- random vibration / PSD family

Copy these controls:

- `*DATABASE_FREQUENCY_BINARY_D3PSD`
- `*DATABASE_FREQUENCY_BINARY_D3RMS`

Do not copy blindly:

- gravity treatment from the second cantilever beam case
- excitation correlation matrices from the multi-force example

## Random Vibration With Thermal Or Pressure Preload

Applicable problem:

- random vibration about a loaded or thermally pre-stressed state

Key solver family:

- preload transfer plus random vibration

Copy these controls:

- `*INTERFACE_SPRINGBACK_LSDYNA`
- `dynain`-based prestress import
- intermittent eigenvalue analysis

Do not copy blindly:

- preload magnitude and thermal field from the example
- domain decomposition files unless your parallel partitioning is similar

## Aluminium Bracket And Aluminium Beam

Applicable problem:

- random-vibration fatigue of lightweight structures

Key solver family:

- `*FREQUENCY_DOMAIN_RANDOM_VIBRATION_FATIGUE`

Copy these controls:

- fatigue post-processing databases:
  `*DATABASE_FREQUENCY_BINARY_D3FTG`
  `*DATABASE_FREQUENCY_BINARY_D3PSD`
  `*DATABASE_FREQUENCY_BINARY_D3RMS`
- method choice examples:
  Steinberg three-band on the bracket
  Dirlik on the beam

Do not copy blindly:

- the fatigue method if your standard requires another damage model
- notch geometry and stress concentration assumptions

## BEM Acoustics Cases

Applicable problem:

- exterior or boundary-element acoustics
- panel contribution and transfer-vector studies

Key solver family:

- `*FREQUENCY_DOMAIN_ACOUSTIC_BEM`

Copy these controls:

- `*FREQUENCY_DOMAIN_ACOUSTIC_BEM`
- `*FREQUENCY_DOMAIN_ACOUSTIC_BEM_PANEL_CONTRIBUTION` for the tunnel example
- `*FREQUENCY_DOMAIN_ACOUSTIC_BEM_MATV` for transfer-vector workflows
- `*FREQUENCY_DOMAIN_ACOUSTIC_FRINGE_PLOT_SPHERE` for car-model noise visualization

Do not copy blindly:

- indirect versus collocation BEM choice without checking the target use case
- FFT windowing choice from the compartment example if the excitation type differs

## FEM Acoustics Cases

Applicable problem:

- enclosed-cavity acoustics and vibro-acoustic coupling with volumetric acoustic meshes

Key solver family:

- `*FREQUENCY_DOMAIN_ACOUSTIC_FEM`

Copy these controls:

- `*FREQUENCY_DOMAIN_ACOUSTIC_FEM`
- `*DATABASE_FREQUENCY_BINARY_D3ACS`
- impedance-boundary setup from the cabin-with-seats example when seats or trims are approximated by acoustic impedance

Do not copy blindly:

- hexahedral versus tetrahedral acoustic mesh choice without mesh-quality justification
- impedance values and absorbing-surface assumptions

## Response Spectrum Analysis Cases

Applicable problem:

- seismic or base-acceleration qualification using response spectra

Key solver family:

- `*FREQUENCY_DOMAIN_RESPONSE_SPECTRUM`

Copy these controls:

- `*DEFINE_CURVE`
- `*DEFINE_TABLE`
- `*DATABASE_FREQUENCY_BINARY_D3SPCM`
- `*DATABASE_NODAL_FORCE_GROUP` for the multi-story building variant

Do not copy blindly:

- design spectra curves
- damping-coefficient tables

## Simple Brake

Applicable problem:

- brake squeal and contact-coupled modal instability

Key solver family:

- implicit rotational dynamics with intermittent eigenvalue analysis

Copy these controls:

- `*CONTACT_AUTOMATIC_SURFACE_TO_SURFACE_MORTAR_ID`
- `*CONTROL_IMPLICIT_EIGENVALUE`
- `*CONTROL_IMPLICIT_ROTATIONAL_DYNAMICS`
- `*CONTROL_IMPLICIT_SOLVER`

Do not copy blindly:

- friction coefficients, pad preload, or rotor speed
- the exact step sequence unless your brake event order is the same

