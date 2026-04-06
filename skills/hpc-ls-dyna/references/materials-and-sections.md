# Materials And Sections

## Source Focus

- `dynasupport.com/howtos/material/anisotropic-plasticity-models`
- `dynasupport.com/howtos/material/cohesive-material-models`
- `dynasupport.com/howtos/material/concrete-models`
- `dynasupport.com/howtos/material/how-to-define-composite-materials-and-layups`
- `dynasupport.com/howtos/material/eulerian-materials`
- `dynasupport.com/howtos/material/material-models-for-polymers`
- `dynasupport.com/howtos/material/viscoelastic-materials`
- `dynasupport.com/howtos/material/viscoplastic-materials`
- `dynasupport.com/howtos/material/negative-volume-in-soft-materials`
- `dynasupport.com/howtos/material/using-equations-of-state`
- `dynasupport.com/howtos/element/beam-formulations`
- `dynasupport.com/howtos/element/discrete-beams-and-springs`
- `dynasupport.com/howtos/element/shell-formulations-in-ls-dyna`
- `dynasupport.com/howtos/element/shell-thickness-offset`
- `dynasupport.com/howtos/element/shell-output`
- `dynasupport.com/howtos/element/strain-measures`

## Selection Workflow

Choose material and section cards together. The constitutive law, element family, integration strategy, and output interpretation are tightly coupled.

1. Identify the dominant physics: elastic-plastic metal, rubber-like large strain, polymer rate dependence, brittle concrete, delamination, foam, fluid-like response.
2. Choose the element family that can represent the geometry and deformation mode.
3. Confirm whether an equation of state is required in addition to the constitutive model.
4. Confirm whether the workflow is explicit-only or must also support implicit.

## Metals And Rate Dependence

For structural metals, start with a well-understood elastic-plastic baseline and add strain-rate, damage, or anisotropy only when the test basis supports it. `dynasupport.com/howtos/material/anisotropic-plasticity-models` is the right branch when yield response depends on rolling or orthotropic directions.

## Polymers, Viscoelasticity, And Viscoplasticity

`dynasupport.com/howtos/material/material-models-for-polymers` organizes polymers by response class:

- elastomeric or rubber-like
- glassy or ductile thermoplastics
- rate-sensitive behavior
- creep or relaxation-dominated behavior

Load `viscoelastic-materials` when time-dependent relaxation dominates, and `viscoplastic-materials` when permanent deformation depends strongly on strain rate.

## Concrete And Brittle Materials

`dynasupport.com/howtos/material/concrete-models` highlights the need to distinguish:

- simple brittle compression-tension response
- reinforced concrete with damage and strain-rate sensitivity
- calibration effort the team can actually support

Choose the simplest concrete model that matches the available material data and failure objective. Complex concrete cards are easy to misuse if calibration is thin.

## Cohesive Zones And Composite Layups

Use cohesive models for interface debonding, delamination, or bonded-joint separation when traction-separation behavior is the target mechanism. Use the composite layup guidance when the part response depends on ply order, orientation, thickness, and failure at the ply level.

## Soft Materials, EOS, And Negative Volume

`dynasupport.com/howtos/material/negative-volume-in-soft-materials` treats negative volume as a deformation-quality warning, not only a solver crash. Common drivers:

- elements too distorted for the chosen formulation
- nearly incompressible soft response with poor mesh design
- contact forcing elements into unrealistic collapse
- loading too abrupt relative to the constitutive and geometric scale

When using highly compressible or fluid-like response, pair the constitutive law with the correct EOS logic rather than forcing a solid-only material to mimic pressure-volume behavior.

## Shells, Solids, Beams, And Discrete Elements

Use shells for thin structures where thickness is small relative to in-plane dimensions and bending or membrane response dominates. Use solids when through-thickness stress or large local contact compression matters. Use beam formulations for slender members with clear centerline behavior. Use discrete beams or springs for connector-like idealization rather than for continuum behavior.

## Shell-Specific Audits

Audit shell models for:

- thickness assignment
- offset interpretation relative to geometry midsurface
- formulation family
- stress and strain output conventions
- whether the selected strain measure matches the post-processing objective

If shell output looks inconsistent with the visual deformation, suspect orientation, offset, or formulation mismatch before changing material parameters.

## Practical Guardrails

- Do not upgrade to a more complex material card without calibration evidence.
- Do not use a shell section to represent thickness-driven crushing if solids are required for the stress state.
- Do not solve soft-material instability with damping alone; check EOS, bulk modulus, contact, and mesh distortion.
- Do not assume a material card available in examples is appropriate in a different unit system or strain-rate regime.

