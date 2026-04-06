# Showcase Contact And Preload Recipes

## Source Focus

- `dynaexamples.com/show-cases`
- `dynaexamples.com/show-cases/contact-overview`
- `dynaexamples.com/show-cases/contact-interference`
- `dynaexamples.com/show-cases/drop-test`
- `dynaexamples.com/show-cases/joint-screw`
- `dynaexamples.com/show-cases/joint-revtrans`
- `dynaexamples.com/show-cases/preload`
- `dynaexamples.com/show-cases/bolts`

## Use This Reference For

- drilling into load-case and keyword showcases that are broader than a single physics family
- choosing between generic explicit, bolt-preload, or implicit starters for demonstration-style models
- lifting specific contact or joint keywords without importing unrelated subsystem complexity

## Starter Deck Mapping

Use these starter decks first:

- `assets/templates/explicit-impact-outline.k` for drop test, generic contact overview, and interference-style explicit examples
- `assets/templates/bolt-preload-implicit-starter.k` for preload and bolt-family examples
- `assets/templates/implicit-static-outline.k` for joint motion and rigid-body mechanism examples when the problem is kinematic rather than high-speed impact
- `assets/templates/examples/explicit-impact-minimal/` when the showcase should be rebuilt as a multi-file explicit project
- `assets/templates/examples/bolt-preload-minimal/` when preload and service stages should be split into local include files
- `assets/templates/examples/implicit-static-minimal/` when joint-driven mechanism demos should start from a multi-file structural scaffold

## Contact Overview

Applicable problem:

- quickly testing several contact families on simple shells, solids, and beams

Key solver family:

- explicit contact demonstration

The keywords page explicitly highlights:

- `*CONTACT_AUTOMATIC_GENERAL_ID`
- `*CONTACT_AUTOMATIC_SINGLE_SURFACE_ID`
- `*CONTACT_AUTOMATIC_SINGLE_SURFACE_MORTAR_ID`
- `*SECTION_BEAM_TITLE`
- `*SECTION_SHELL_TITLE`
- `*SECTION_SOLID_TITLE`

Copy these controls:

- side-by-side contact family comparison logic
- use of simple section diversity to expose contact behavior differences

Do not copy blindly:

- general contact as the default answer for every production model
- mortar contact in explicit just because it appears in the showcase

Starter:

- `assets/templates/explicit-impact-outline.k`
- `assets/templates/examples/explicit-impact-minimal/`

## Contact Interference

Applicable problem:

- depenetration and prestress from initially interfering parts

Key solver family:

- explicit contact interference setup

The keywords page explicitly lists:

- `*CONTACT_SURFACE_TO_SURFACE_INTERFERENCE_ID`
- `*DATABASE_NODOUT`
- `*DATABASE_SLEOUT`
- `*DATABASE_RCFORC`

Copy these controls:

- depenetration-before-service-load logic
- contact-state and nodal-history observability

Do not copy blindly:

- rigid-shell cylinder geometry
- interference magnitude

Starter:

- `assets/templates/explicit-impact-outline.k`
- `assets/templates/examples/explicit-impact-minimal/`

## Drop Test

Applicable problem:

- deformable body dropped on rigid wall
- first pass on explicit impact with gravity or prescribed initial state

Key solver family:

- explicit structural impact

Copy these controls:

- rigidwall impact pattern
- energy and force-monitoring outputs

Do not copy blindly:

- drop height or body geometry

Starter:

- `assets/templates/explicit-impact-outline.k`
- `assets/templates/examples/explicit-impact-minimal/`

## Joint Screw

Applicable problem:

- converting rotational motion into translation through rigid-body joints

Key solver family:

- rigid-body kinematic joint demonstration

The keywords page explicitly lists:

- `*BOUNDARY_PRESCRIBED_MOTION_RIGID_ID`
- `*CONSTRAINED_JOINT_SCREW_ID`
- `*DATABASE_JNTFORC`
- `*DATABASE_RCFORC`

Copy these controls:

- rigid-body prescribed motion
- joint-force output

Do not copy blindly:

- rigid-body idealization if the real problem depends on flexible-body compliance

Starter:

- `assets/templates/implicit-static-outline.k`
- `assets/templates/examples/implicit-static-minimal/`

## Joint Rev/Trans

Applicable problem:

- rigid-body mechanisms using revolute and translational joints

Key solver family:

- joint demonstration

The keywords page explicitly lists:

- `*CONSTRAINED_JOINT_REVOLUTE_ID`
- `*CONSTRAINED_JOINT_TRANSLATIONAL_ID`
- `*DATABASE_JNTFORC`
- `*LOAD_BODY_Z`

Copy these controls:

- basic rigid-body mechanism assembly
- joint reaction output

Do not copy blindly:

- rigid-body simplification for mechanisms whose compliance matters

Starter:

- `assets/templates/implicit-static-outline.k`
- `assets/templates/examples/implicit-static-minimal/`

## Preload

Applicable problem:

- dynamic-relaxation preload of a system by force

Key solver family:

- explicit or quasi-static preload establishment

The keywords page explicitly lists:

- `*CONTACT_AUTOMATIC_SINGLE_SURFACE_ID`
- `*CONTACT_FORCE_TRANSDUCER_PENALTY_ID`
- `*LOAD_RIGID_BODY`
- `*DATABASE_SLEOUT`
- `*DATABASE_HISTORY_NODE`

Copy these controls:

- preload-then-observe reaction-force workflow
- contact-force transducer usage where preload transfer must be monitored

Do not copy blindly:

- dynamic relaxation as a default when implicit preload would be simpler

Starter:

- `assets/templates/bolt-preload-implicit-starter.k` for structural preload studies
- `assets/templates/explicit-impact-outline.k` only if dynamic relaxation is intentionally required
- `assets/templates/examples/bolt-preload-minimal/` for structural preload studies
- `assets/templates/examples/explicit-impact-minimal/` only if dynamic relaxation is intentionally required

## Bolts And Bolt Types A-D

Applicable problem:

- common bolt abstractions and load-transfer tradeoffs

Key solver family:

- explicit or implicit bolt showcase family

The explicit and implicit bolt keyword pages collectively show recurring building blocks:

- `*INITIAL_AXIAL_FORCE_BEAM`
- `*PART_CONTACT`
- `*CONTACT_AUTOMATIC_GENERAL_MPP_ID`
- `*CONTACT_AUTOMATIC_SINGLE_SURFACE_ID`
- `*CONTACT_AUTOMATIC_SINGLE_SURFACE_MORTAR_ID`
- `*CONTROL_IMPLICIT_GENERAL`
- `*CONTROL_IMPLICIT_AUTO`
- `*CONTROL_IMPLICIT_SOLUTION`
- `*CONTROL_IMPLICIT_SOLVER`
- `*CONTROL_IMPLICIT_EIGENVALUE`
- `*INITIAL_STRESS_SECTION`

Copy these controls:

- beam-preload or section-stress preload logic
- explicit versus implicit comparison mindset
- contact-force transducer outputs for joint force path inspection

Do not copy blindly:

- spotweld material shortcuts as a universal bolt model
- beam-only representation when head seating and local bearing matter

Starter:

- `assets/templates/bolt-preload-implicit-starter.k`
- `assets/templates/examples/bolt-preload-minimal/`
