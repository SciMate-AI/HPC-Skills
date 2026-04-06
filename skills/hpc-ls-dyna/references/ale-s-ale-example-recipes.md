# ALE And S-ALE Example Recipes

## Source Focus

- `dynaexamples.com/ale-s-ale`
- `dynaexamples.com/ale-s-ale/ale`
- `dynaexamples.com/ale/explosion`
- `dynaexamples.com/ale/sloshing`
- `dynaexamples.com/ale-s-ale/s-ale`

## Use This Reference For

- deciding whether the case should be ALE, S-ALE, SPH, or pure Lagrangian
- selecting advection order, Eulerian versus Lagrangian comparison logic, and FSI coupling strategy
- choosing the right starter for explosion, sloshing, advection, or structured-ALE problems

## Starter Deck Mapping

Use these starter decks first:

- `assets/templates/ale-explosion-starter.k` for Eulerian fluid domains, underwater blast, sloshing, and ALE FSI baselines
- `assets/templates/explicit-impact-outline.k` when the original comparison case is purely Lagrangian or when the structure side dominates and ALE is only a reference branch
- `assets/templates/sph-bird-impact-starter.k` when the moving medium is better represented with particles rather than an Eulerian background mesh
- `assets/templates/examples/ale-explosion-minimal/` when the ALE case should begin as a multi-file project

## Common ALE Reuse Pattern

Copy these families only after matching the case:

- ALE/Eulerian section and material partitioning
- advection-order choice and related controls
- `*CONTROL_TIMESTEP`, `*CONTROL_TERMINATION`, and energy-history outputs
- gravity or body-force loading such as `*LOAD_BODY_Y` or `*LOAD_BODY_Z`
- tracer/history databases when transport path or free-surface evolution is the result of interest
- rigidwall or FSI interface definitions

Do not copy these blindly:

- advection order
- mesh density or Eulerian box size
- water, explosive, or gas EOS parameters
- quadrature-point choices from FSI teaching examples
- S-ALE structured spacing choices if the target geometry is not compatible with structured meshing

## Intermediate Example

Applicable problem:

- first ALE wave or fluid-structure interaction qualification

Key solver family:

- ALE with fluid-structure coupling

Copy these controls:

- explicit partition between Eulerian fluid and Lagrangian structure
- coupling observability and short-time diagnostics

Do not copy blindly:

- tutorial-scale geometry
- simplified structural stiffness

Starter:

- `assets/templates/ale-explosion-starter.k`
- `assets/templates/examples/ale-explosion-minimal/`

## Advection

Applicable problem:

- comparing 1st- and 2nd-order advection on transport-dominated problems

Key solver family:

- Eulerian ALE advection comparison

Copy these controls:

- advection-comparison workflow
- transport-focused output monitoring

Do not copy blindly:

- the same advection order across all problems
- the same coarse-mesh acceptance criteria

Starter:

- `assets/templates/ale-explosion-starter.k`
- `assets/templates/examples/ale-explosion-minimal/`

## Bird

Applicable problem:

- comparing Lagrangian and Eulerian bird strike idealizations

Key solver family:

- ALE bird model as an alternative to SPH or Lagrangian bird

Copy these controls:

- same target structure while swapping medium discretization
- comparison mindset between Eulerian and non-Eulerian medium models

Do not copy blindly:

- choose ALE just because the example exists; SPH may still be better for free projectile breakup

Starter:

- `assets/templates/ale-explosion-starter.k` for Eulerian bird
- `assets/templates/sph-bird-impact-starter.k` if particle SPH is more appropriate
- `assets/templates/examples/ale-explosion-minimal/` for Eulerian bird
- `assets/templates/examples/sph-bird-impact-minimal/` if particle SPH is more appropriate

## Pipe

Applicable problem:

- viscous fluid modeling in a confined passage

Key solver family:

- ALE internal viscous flow

Copy these controls:

- Eulerian internal-domain setup
- wall-boundary tracking

Do not copy blindly:

- use ALE where ICFD would be simpler for incompressible engineering flow

Starter:

- `assets/templates/ale-explosion-starter.k`
- `assets/templates/examples/ale-explosion-minimal/`

## Explosion

Applicable problem:

- underwater detonation and shock propagation
- mesh and advection-order sensitivity studies for blast in fluid

Key solver family:

- ALE plane-strain blast in water

The page explicitly splits the study into:

- Underwater A: Lagrangian, coarse mesh
- Underwater B: Lagrangian, fine mesh
- Underwater C: Eulerian, 1st-order advection, coarse mesh
- Underwater D: Eulerian, 1st-order advection, fine mesh
- Underwater E: Eulerian, 2nd-order advection, coarse mesh
- Underwater F: Eulerian, 2nd-order advection, fine mesh

Copy these controls:

- mesh-versus-advection comparison strategy
- plane-strain blast observability
- Eulerian domain sizing around the charge and water region

Do not copy blindly:

- the exact mesh counts
- charge size and stand-off
- assume 2nd-order advection is always worth the cost

Starter:

- `assets/templates/ale-explosion-starter.k`
- `assets/templates/examples/ale-explosion-minimal/`

## FSI

Applicable problem:

- bar impact on water surface or similar short-time fluid-structure coupling

Key solver family:

- ALE plus explicit structure

Copy these controls:

- coupling sensitivity workflow across quadrature choices
- short-time impact monitoring

Do not copy blindly:

- quadrature settings without convergence checking

Starter:

- `assets/templates/ale-explosion-starter.k`
- `assets/templates/examples/ale-explosion-minimal/`

## Sloshing

Applicable problem:

- liquid motion in tanks and containers
- comparing Lagrangian versus Eulerian dissipation behavior

Key solver family:

- Lagrangian and Eulerian sloshing benchmark

The ALE sloshing pages explicitly show:

- Sloshing A: Lagrangian with visible viscous behavior
- Sloshing B: Lagrangian with reduced viscous behavior via `*CONTROL_HOURGLASS`
- Sloshing C: Eulerian with advection dissipation
- Sloshing D: Eulerian with reduced viscous behavior using `*CONTROL_HOURGLASS`

The sloshing keyword list explicitly includes:

- `*CONTROL_ENERGY`
- `*CONTROL_TERMINATION`
- `*CONTROL_TIMESTEP`
- `*DATABASE_BINARY_D3PLOT`
- `*DATABASE_GLSTAT`
- `*DATABASE_TRACER`
- `*DATABASE_TRHIST`
- `*EOS_GRUNEISEN`
- `*LOAD_BODY_Y`
- `*MAT_NULL`

Copy these controls:

- tracer and history outputs for free-surface motion
- gravity-loading ramp
- explicit comparison of numerical dissipation sources

Do not copy blindly:

- the same tank dimensions
- assume Eulerian is always less dissipative; the example shows the opposite can happen with coarse advection

Starter:

- `assets/templates/ale-explosion-starter.k`
- `assets/templates/examples/ale-explosion-minimal/`

## Taylor Bar

Applicable problem:

- comparing ALE methods on a high-speed impact benchmark

Key solver family:

- quarter-model impact benchmark under different ALE methods

Copy these controls:

- benchmark-comparison methodology
- reduced symmetry model logic

Do not copy blindly:

- benchmark geometry and impact speed

Starter:

- `assets/templates/ale-explosion-starter.k`

## S-ALE: Adiabatic Expansion

Applicable problem:

- structured-ALE explosive expansion with geometry suited to structured meshing

Key solver family:

- S-ALE

Copy these controls:

- structured mesh spacing logic
- S-ALE-specific solver choice when structured remeshing is the main advantage

Do not copy blindly:

- use S-ALE on arbitrary complex geometry that does not benefit from structured spacing
- carry over structured spacing ratios from the LLNL cylinder benchmark without re-scaling

Starter:

- `assets/templates/ale-explosion-starter.k`, then replace generic ALE setup with S-ALE-specific structured mesh controls
- `assets/templates/examples/ale-explosion-minimal/`, then replace generic ALE setup with S-ALE-specific structured mesh controls
