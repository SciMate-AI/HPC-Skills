# Scenario Recipes

## Source Focus

- `dynasupport.com` how-to and FAQ pages
- `dynaexamples.com` representative example and keywords pages

## 1. Explicit Structural Impact Or Crash

Use when the task resembles crash box crushing, drop test, impactor contact, or vehicle subsystem intrusion.

Recommended sequence:

1. classify dominant parts as shell, solid, beam, or rigid
2. choose robust automatic contact and inspect thickness handling early
3. set conservative database output and monitor timestep, internal, kinetic, and hourglass energies
4. calibrate material rate effects and failure only after contact stability is credible

Representative lineage:

- `dynasupport.com/howtos/general/recommendations-for-structural-impact`
- `dynaexamples.com/show-cases/contact-overview`

## 2. Explicit Quasi-Static Crush Or Forming

Use when the user wants an explicit solve for a slow process because contact is difficult or the deck already exists in explicit.

Key checks:

- smooth load or displacement curve
- kinetic energy remains small relative to internal energy
- damping and mass scaling are documented and justified

Representative lineage:

- `dynasupport.com/howtos/general/quasistatic-simulation`

## 3. Implicit Static Suspension Or Assembly Loading

Use for slow structural load transfer, compliance studies, preload carryover, or suspension loading.

Suggested workflow:

1. confirm materials and elements are implicit-capable
2. trim contact to essentials
3. ramp load in increments and watch convergence
4. only add preload, friction, or nonlinear details once the base state converges

Representative example:

- `dynaexamples.com/implicit/yaris-static-suspension-system-loading`

## 4. Thermal Stress Or Heat-Driven Deformation

Use when thermal fields drive stress, distortion, or expansion mismatch.

Suggested workflow:

1. confirm temperature-dependent material data and units
2. stage thermal solution and structural response in the intended order
3. request thermal and structural histories at the same critical locations

Representative example:

- `dynaexamples.com/thermal/thermal-stress`

## 5. SPH Bird Strike Or Water Impact

Use when a conventional Lagrangian mesh would distort excessively.

Key checks:

- particle spacing versus target geometry resolution
- coupling surface definition
- whether the result of interest is local damage, global impulse, or splash morphology

Representative example families:

- `dynaexamples.com/sph/bird-strike`
- `dynaexamples.com/sph/water-impact`

## 6. ALE Explosion Or Fluid-Structure Interaction

Use for blast loading, enclosed-fluid transients, or moving-structure interaction with an Eulerian region.

Suggested workflow:

1. define the ALE domain and material initialization explicitly
2. isolate structural-only behavior before coupling if possible
3. inspect boundary conditions to avoid artificial reflections

Representative example:

- `dynaexamples.com/ale-s-ale/ale/explosion`

## 7. ICFD Internal Cooling Or External Flow

Use when the user wants LS-DYNA-native incompressible flow examples such as cylinder flow, building flow, or tool cooling.

Suggested workflow:

1. begin from a basics example with similar Reynolds-number intent
2. confirm inlet, outlet, wall, and moving-boundary treatment
3. request flow observables that connect back to engineering metrics such as pressure drop, heat-transfer coefficient, or force

Representative example families:

- `dynaexamples.com/icfd/basics-examples/cylinder_flow`
- `dynaexamples.com/icfd/advanced-examples/tool_cooling`

## 8. Meshfree Or Material-Removal Processes

Use EFG or related advanced formulations when cutting, severe separation, or other topology change makes standard mesh tracking difficult.

Representative example:

- `dynaexamples.com/efg/metal-cutting`

## 9. Electromagnetic Or Joule Heating

Use EM examples when the task involves eddy currents, resistive heating, or other electromagnetic loading that feeds structural or thermal response.

Representative family:

- `dynaexamples.com/em`

## 10. High-Speed Compressible Flow Or Shock Interaction

Use CESE or dual-CESE examples when the user is modeling shock-dominated flow rather than structural impact.

Representative example:

- `dynaexamples.com/cese/dual-cese/shock-bubble-interaction`

## Recipe Selection Heuristic

When multiple recipes seem possible, choose the one whose dominant unknown matches the user goal:

- force, deformation, intrusion -> structural explicit or implicit
- temperature and thermal stress -> thermal
- flow field -> ICFD or ALE/CESE
- extreme distortion without a stable mesh -> SPH or EFG
- particle transport -> DEM
