# Implicit Example Recipes

## Source Focus

- `dynaexamples.com/implicit`
- `dynaexamples.com/implicit/yaris-static-suspension-system-loading`
- `dynaexamples.com/implicit/yaris-dynamic-suspension-system-loading`
- `dynaexamples.com/implicit/Yaris%20Static%20Door%20Sag`
- `dynaexamples.com/show-cases/bolts`
- representative reduced-input and keywords pages under the implicit branch

## Use This Reference For

- picking the closest implicit structural precedent
- deciding whether the case is static, quasi-static, transient implicit, or preload driven
- porting only the implicit controls and contact strategy that survive the geometry and load change

## Starter Deck Mapping

Use these starter decks first:

- `assets/templates/implicit-static-outline.k` for static, quasi-static, door sag, compliance, and non-bolt assembly loading
- `assets/templates/bolt-preload-implicit-starter.k` for clamp load, joint closure, pretension carryover, and bolt showcase variants
- `assets/templates/explicit-impact-outline.k` only when the source example is explicit or when an explicit preload phase must be built before an implicit continuation
- `assets/templates/examples/implicit-static-minimal/` when the task should start as a multi-file implicit project
- `assets/templates/examples/bolt-preload-minimal/` when preload and service stages should be separated from the first draft

## Common Implicit Reuse Pattern

Copy these families only after matching the problem class:

- `*CONTROL_IMPLICIT_GENERAL`
- `*CONTROL_IMPLICIT_AUTO`
- `*CONTROL_IMPLICIT_SOLUTION`
- `*CONTROL_IMPLICIT_DYNAMICS` when the example is genuinely transient implicit
- `*CONTROL_IMPLICIT_SOLVER`
- `*CONTROL_TIMESTEP` or its load-curve-based maximum timestep logic
- mortar contact and tied-contact definitions that are already known to converge in implicit
- database cards such as `*DATABASE_GLSTAT`, `*DATABASE_MATSUM`, `*DATABASE_NODOUT`, `*DATABASE_RCFORC`, and joint/contact outputs

Do not copy these blindly:

- implicit timestep limits
- contact friction and penalty values
- the exact convergence tolerances from a much smaller or larger model
- load curve magnitudes and support motion history
- any include-tree assumptions tied to the Toyota Yaris source model

## Salzburg 2017 Linear And Nonlinear Sets

Applicable problem:

- first implicit learning deck
- verifying linear versus nonlinear solver path
- checking element, material, and support compatibility before a production model

Key solver family:

- canonical implicit training decks

Copy these controls:

- baseline `*CONTROL_IMPLICIT_GENERAL`
- `*CONTROL_IMPLICIT_AUTO`
- `*CONTROL_IMPLICIT_SOLUTION`
- small-model database cadence and convergence-inspection workflow

Do not copy blindly:

- educational simplifications into production contact networks
- linear assumptions once contact, plasticity, or large displacement becomes dominant

Starter:

- `assets/templates/implicit-static-outline.k`
- `assets/templates/examples/implicit-static-minimal/`

## Yaris Static Suspension System Loading

Applicable problem:

- suspension jounce/rebound, bushing compliance, ride-height static loading
- static load transfer through joints, springs, dampers, tires, and ground contact

Key solver family:

- implicit static solver on an originally explicit vehicle subsystem model

The reduced input and keywords pages show reusable patterns such as:

- `*DEFINE_TRANSFORMATION` and `*INCLUDE_TRANSFORM` for subsystem reuse
- `*CONTROL_IMPLICIT_AUTO`
- `*CONTROL_IMPLICIT_DYNAMICS`
- `*BOUNDARY_PRESCRIBED_MOTION_SET`
- `*LOAD_BODY_Z`
- `*CONTACT_AUTOMATIC_SURFACE_TO_SURFACE_MORTAR_ID`
- `*CONTACT_AUTOMATIC_SINGLE_SURFACE_MORTAR_ID`

Copy these controls:

- displacement-ramp logic for control-arm or knuckle motion
- gravity/body-load staging
- mortar contact preference for tire-ground and structural interfaces
- joint-force and rigid-body output requests

Do not copy blindly:

- Yaris-specific include files and transformed coordinates
- exact maximum timestep curve values
- tire-to-ground friction and contact pairing
- all joint definitions if your suspension topology is different

Starter:

- `assets/templates/implicit-static-outline.k`
- `assets/templates/examples/implicit-static-minimal/`

## Yaris Dynamic Suspension System Loading

Applicable problem:

- slow-to-moderate transient implicit motion where inertia is still relevant
- dynamic suspension event without going back to full explicit

Key solver family:

- transient implicit

The keywords page shows a broader set than the static case, including:

- `*CONTROL_IMPLICIT_DYNAMICS`
- `*CONTROL_IMPLICIT_SOLVER`
- multiple joint families
- contact and rigid-body output
- airbag and foam-related keywords in the inherited subsystem model

Copy these controls:

- transient implicit damping and time-step management pattern
- prescribed-motion logic for motion-driven dynamic loading
- rigid-body and joint output set

Do not copy blindly:

- inherited airbag, foam, or spotweld cards from the donor vehicle unless the target uses them
- transient damping values from this model if your mode content is different

Starter:

- `assets/templates/implicit-static-outline.k`, then add transient implicit dynamics controls
- `assets/templates/examples/implicit-static-minimal/`, then add transient implicit dynamics controls

## Yaris Static Door Sag

Applicable problem:

- door sag, latch/hinge compliance, closure stiffness, and gravity-induced alignment checks

Key solver family:

- quasi-static implicit with force loading

Copy these controls:

- slow-load application strategy
- gravity and boundary-condition staging from a derived vehicle-side submodel
- displacement and reaction-force monitoring at hinge and latch regions

Do not copy blindly:

- the exact force magnitude or door opening angle
- the donor suspension model structure if the target is a clean body-in-white model

Starter:

- `assets/templates/implicit-static-outline.k`
- `assets/templates/examples/implicit-static-minimal/`

## Springback And Trim/Form Workflows

Applicable problem:

- springback after forming
- trim, release, and post-form distortion

Key solver family:

- implicit continuation after an explicit forming path, or implicit-only slow nonlinear solve when appropriate

Copy these controls:

- state-transfer mindset between process stages
- support-release and equilibrium-seeking output selection

Do not copy blindly:

- forming-stage contacts and tooling unless the same process is being reproduced

Starter:

- `assets/templates/implicit-static-outline.k`
- `assets/templates/examples/implicit-static-minimal/`

## Beam Buckling

Applicable problem:

- instability, bifurcation, and geometric-nonlinear column studies

Key solver family:

- nonlinear implicit with careful stepping

Copy these controls:

- small-increment stepping
- imperfection-sensitive monitoring strategy

Do not copy blindly:

- perfect-geometry assumptions if your real structure needs an initial imperfection

Starter:

- `assets/templates/implicit-static-outline.k`
- `assets/templates/examples/implicit-static-minimal/`

## Bolt Type A To D, Implicit

Applicable problem:

- clamped joints, bolted interfaces, preload carryover, shear transfer, and local joint stiffness studies

Key solver family:

- implicit preload and service-load continuation

The bolt showcase pages are useful because they expose both explicit and implicit variants, plus the modeling tradeoff between beam-only and more detailed bolt abstractions. The explicit Type A page also reveals the practical building blocks used in the family:

- `*INITIAL_AXIAL_FORCE_BEAM`
- `*PART_CONTACT`
- `*CONSTRAINED_NODAL_RIGID_BODY`
- `*CONTACT_AUTOMATIC_GENERAL_MPP_ID`
- `*CONTACT_AUTOMATIC_SINGLE_SURFACE_ID`

Copy these controls:

- staged preload then service-load logic
- beam-set or solid-bolt preload bookkeeping
- clamp stack contact partitioning
- reaction-force output on the joint stack

Do not copy blindly:

- the bolt force, bolt stress, or joint geometry from the example
- `*MAT_SPOTWELD` as a universal bolt material shortcut
- beam-only abstraction if slip, head seating, or thread-region flexibility matters

Starter:

- `assets/templates/bolt-preload-implicit-starter.k`
- `assets/templates/examples/bolt-preload-minimal/`
