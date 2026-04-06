# SPH Example Recipes

## Source Focus

- `dynaexamples.com/sph`
- `dynaexamples.com/sph/intermediate-examples`
- `dynaexamples.com/sph/bird`
- `dynaexamples.com/sph/boot`
- `dynaexamples.com/sph/sieve`
- `dynaexamples.com/sph/intermediate-examples/wavestructure`
- representative keywords pages such as `sph/bird/keywords`

## Use This Reference For

- deciding whether SPH is the right formulation versus ALE or pure Lagrangian
- selecting contact, EOS, and particle-region setup from a nearby precedent
- linking impact, free-surface, grease, foam, and benchmark SPH cases to the right starter

## Starter Deck Mapping

Use these starter decks first:

- `assets/templates/sph-bird-impact-starter.k` for bird strike, free particle impact, Taylor-bar-style SPH impact, and SPH-to-structure contact
- `assets/templates/explicit-impact-outline.k` for mixed Lagrangian explicit impact where SPH is only a local extension or where a structural explicit base model already exists
- `assets/templates/icfd-tool-cooling-starter.k` never as a direct SPH starter; use it only if the problem is actually CFD/thermal and not particle SPH
- `assets/templates/examples/sph-bird-impact-minimal/` when the SPH case should begin as a multi-file project
- `assets/templates/examples/explicit-impact-minimal/` when the target structure is already being organized as a multi-file explicit project

## Common SPH Reuse Pattern

Copy these families only after matching the physics:

- `*CONTROL_SPH`
- `*DEFINE_BOX`
- `*SECTION_SPH`
- `*ELEMENT_SPH`
- `*MAT_NULL` plus EOS cards for fluid-like SPH
- `*MAT_LOW_DENSITY_FOAM` or other constitutive cards for solid-like SPH particles
- `*CONTACT_AUTOMATIC_NODES_TO_SURFACE` for SPH-to-Lagrangian interfaces
- `*LOAD_BODY_Z` and gravity curves for free-surface cases

Do not copy these blindly:

- SPH particle spacing
- kernel support size or box size
- artificial viscosity settings
- rigid-wall extents
- EOS choice between water-like, bird-like, grease-like, and foam-like media

## Bar I, II, III

Applicable problem:

- comparing SPH and Lagrangian response for the same bar material
- first contact and impact qualification of a solid-like SPH body

Key solver family:

- explicit structural SPH

The SPH index page states these examples compare equivalent bars under:

- initial velocity loading
- rigid-wall impact
- shell-structure impact

Copy these controls:

- `*INITIAL_VELOCITY` style loading
- side-by-side validation mentality between Lagrangian and SPH
- basic SPH section and contact setup

Do not copy blindly:

- the comparison geometry
- the same constitutive law if your target is fluid-like rather than plastic-solid

Starter:

- `assets/templates/sph-bird-impact-starter.k`, then replace the bird material and EOS with the target solid-like SPH model
- `assets/templates/examples/sph-bird-impact-minimal/`, then replace the bird material and EOS with the target solid-like SPH model

## Bar IV And V

Applicable problem:

- Taylor-bar-style impact and high-strain-rate deformation in SPH

Key solver family:

- explicit SPH impact against rigid wall

Copy these controls:

- impact velocity initialization
- rigid-wall contact and short-time observability

Do not copy blindly:

- Taylor-bar dimensions or benchmark velocity

Starter:

- `assets/templates/sph-bird-impact-starter.k`
- `assets/templates/examples/sph-bird-impact-minimal/`

## Bird

Applicable problem:

- bird strike on blades, panels, or thin structures
- fluid-like projectile impacting a shell or solid target

Key solver family:

- explicit SPH projectile plus Lagrangian structure

The keywords page explicitly lists:

- `*CONTROL_SPH`
- `*CONTROL_CONTACT`
- `*CONTROL_ENERGY`
- `*CONTROL_HOURGLASS`
- `*DATABASE_GLSTAT`
- `*DATABASE_MATSUM`
- `*DATABASE_RBDOUT`
- `*DEFINE_BOX`
- `*SECTION_SPH`
- `*EOS_GRUNEISEN`
- `*MAT_NULL`
- `*CONTACT_AUTOMATIC_NODES_TO_SURFACE_TITLE`
- `*INITIAL_VELOCITY_NODE`

Copy these controls:

- SPH bird region setup
- bird-to-structure nodes-to-surface contact
- EOS-based fluid-like bird material pattern
- impact output set emphasizing force, energy, and rigid-body response

Do not copy blindly:

- turbine-blade geometry
- impact velocity and angle
- Gruneisen parameters without density and sound-speed justification

Starter:

- `assets/templates/sph-bird-impact-starter.k`
- `assets/templates/examples/sph-bird-impact-minimal/`

## Boot

Applicable problem:

- grease, gel, or particulate medium enclosed by deformable solids
- mixed Lagrangian solid plus SPH medium interaction

Key solver family:

- explicit SPH medium interacting with solid enclosure and rod-like hardware

Copy these controls:

- mixed solid-plus-SPH partitioning
- contact structure between grease particles, rubber boot, and rigid or solid rod

Do not copy blindly:

- grease rheology and particle count
- the assumption that the enclosing material is rubber with the same stiffness range

Starter:

- `assets/templates/sph-bird-impact-starter.k`, then replace the projectile path with enclosed-medium geometry
- `assets/templates/examples/sph-bird-impact-minimal/`, then replace the projectile path with enclosed-medium geometry

## Foam

Applicable problem:

- compressible foam block response using SPH instead of conventional elements

Key solver family:

- explicit solid-like SPH with foam constitutive law

The SPH index explicitly states:

- `*MAT_LOW_DENSITY_FOAM` is used

Copy these controls:

- SPH section pattern
- compression setup against rigid wall and solid block

Do not copy blindly:

- foam crush parameters
- wall clearance and block speed

Starter:

- `assets/templates/sph-bird-impact-starter.k`, then switch to foam material and compression loading
- `assets/templates/examples/sph-bird-impact-minimal/`, then switch to foam material and compression loading

## Sieve

Applicable problem:

- impact against perforated or open thin structures where discrete passage and local breakup matter

Key solver family:

- explicit impact with local SPH or mixed discretization

Copy these controls:

- impact setup against a thin perforated target
- fine local contact monitoring

Do not copy blindly:

- aluminium sieve dimensions and support

Starter:

- `assets/templates/explicit-impact-outline.k` for the target, then graft in SPH logic from `assets/templates/sph-bird-impact-starter.k`
- `assets/templates/examples/explicit-impact-minimal/` for the target, then graft in SPH logic from `assets/templates/examples/sph-bird-impact-minimal/`

## Intermediate: Wave-Structure Interaction

Applicable problem:

- free-surface sloshing or wave impact on columns and rigid structures
- force-history validation against experiments

Key solver family:

- SPH free-surface fluid with rigid or deformable structure

The page explicitly shows a reusable stack:

- `*CONTROL_BULK_VISCOSITY`
- `*CONTROL_SPH`
- `*DEFINE_BOX`
- `*CONTROL_TERMINATION`
- `*CONTROL_TIMESTEP`
- `*DATABASE_RCFORC`
- `*DATABASE_BINARY_D3PLOT`
- `*LOAD_BODY_Z`
- `*DEFINE_CURVE_TITLE` for gravity ramp
- `*MAT_RIGID`
- `*SECTION_SOLID`
- `*CONTACT_AUTOMATIC_NODES_TO_SURFACE_MPP_ID`
- `*RIGIDWALL_PLANAR_ID`
- and, in the keyword list, `*MAT_NULL` with `*EOS_MURNAGHAN`

Copy these controls:

- gravity-ramp initialization
- rigid-column and container contact setup
- force-monitoring at the impacted structure
- free-surface fluid EOS strategy for water-like media

Do not copy blindly:

- box extents, container dimensions, or rigid-column diameter
- Murnaghan parameters without fluid calibration

Starter:

- `assets/templates/sph-bird-impact-starter.k`, then replace prescribed impact velocity with gravity-driven initialization and rigidwall/container logic
- `assets/templates/examples/sph-bird-impact-minimal/`, then replace prescribed impact velocity with gravity-driven initialization and rigidwall/container logic
