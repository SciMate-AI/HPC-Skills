# Controls, Stability, And Accuracy

## Source Focus

- `dynasupport.com/howtos/general/accuracy`
- `dynasupport.com/howtos/general/double-precision`
- `dynasupport.com/howtos/general/mass-scaling`
- `dynasupport.com/howtos/general/quasistatic-simulation`
- `dynasupport.com/howtos/general/recommendations-for-structural-impact`
- `dynasupport.com/howtos/general/damping`
- `dynasupport.com/howtos/element/hourglass`
- `dynasupport.com/howtos/element/shell-formulations-in-ls-dyna`

## Explicit Versus Implicit

Use explicit when the event is dominated by inertia, impact, complex changing contact, severe discontinuities, or very short durations. Use implicit when the process is genuinely slow and the objective is equilibrium or slow transient response. A slow explicit run is not automatically a bad model; forcing it into implicit can create worse contact and convergence behavior.

## Timestep Management

The stable explicit timestep is usually controlled by the smallest characteristic element dimension divided by wave speed, then further reduced by contact and formulation details. Diagnose timestep collapse in this order:

1. tiny elements or bad aspect ratios
2. shells with inconsistent thickness or offset usage
3. overly stiff contacts or localized penetrations
4. material stiffness jumps, especially in very dense or rigid subsystems

Use mass scaling only after identifying the timestep bottleneck part or element class.

## Mass Scaling

`dynasupport.com` treats mass scaling as a deliberate tradeoff, not a default accelerator. Apply it when:

- the event is quasi-static or weakly inertia-driven
- the bottleneck elements are local and not the primary physics of interest
- added mass can be measured and shown to be acceptable

Do not apply it blindly in high-speed impact, wave propagation, or cases where inertia itself is the result of interest. After applying mass scaling:

- review the mass increase per part
- compare kinetic, internal, and hourglass energy histories
- check whether contact force peaks or arrival times shifted materially

## Quasi-Static Strategy

For explicit quasi-static simulations, `dynasupport.com/howtos/general/quasistatic-simulation` points to a three-part strategy:

1. make loading smooth and slow enough to suppress inertial spikes
2. add only the minimum damping needed to settle oscillations
3. monitor the ratio of kinetic to internal energy throughout loading

Treat the model as quasi-static only if kinetic energy stays small relative to internal energy over the meaningful part of the event.

## Damping

Use damping to control nonphysical oscillation, not to hide modeling mistakes. Excessive damping can bury contact and stiffness problems. If damping seems necessary at large levels, re-check load application smoothness, constraint realism, and contact noise first.

## Structural Impact Recommendations

For crash and impact-style decks:

- prefer robust contact definitions before aggressive high-order tuning
- prioritize credible material rate effects and failure logic over cosmetic mesh refinement
- inspect energy partitions early: internal, kinetic, hourglass, sliding/contact, rigidwall
- start from conservative output and control settings, then tighten once stable

## Hourglass Control

`dynasupport.com/howtos/element/hourglass` highlights hourglass energy as a key quality metric. Zero-energy modes indicate under-integrated element deformation that is not physically resisted. Practical workflow:

1. identify whether the active formulation is under-integrated and susceptible
2. monitor hourglass energy relative to internal energy
3. distinguish true locking or deformation issues from numerical noise
4. if hourglass energy is high, reconsider element formulation, mesh density, thickness representation, and control choice together

Do not treat hourglass control as isolated from mesh design.

## Shell Formulation Selection

`dynasupport.com` distinguishes shell choice by thickness, bending dominance, nonlinear strain expectation, and efficiency needs. When shell behavior looks wrong, review:

- element formulation family
- integration points through thickness
- thickness and offset interpretation
- warpage and aspect ratio
- whether solids would be more appropriate locally

## Double Precision

Use double precision for numerically delicate models, very large models, or cases with severe coordinate magnitude differences. It is not a substitute for poor scaling, but it can reduce accumulation and conditioning issues.

## Stability Triage

If the run is unstable:

1. find the first nonphysical symptom in the histories or animation
2. locate the part or contact pair that triggers it
3. decide whether the root cause is geometry, contact, material, formulation, or loading
4. change one lever only and re-run a short diagnostic window

Typical first levers:

- smooth the loading history
- reduce contact complexity to the needed minimum
- fix local mesh pathologies
- reduce unjustified stiffness contrasts
- revisit shell and hourglass options

