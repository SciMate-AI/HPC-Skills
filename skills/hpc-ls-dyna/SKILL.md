---
name: hpc-ls-dyna
description: Create, review, debug, and recover LS-DYNA keyword decks and simulation workflows. Use when working with LS-DYNA `*.k` or `*.key` input files, include trees, explicit crash or impact models, implicit static or quasi-static solves, contact definitions, section and material selection, timestep or mass-scaling control, hourglass stabilization, thermal or coupled workflows, ALE/SPH/ICFD/EM/DEM/CESE/IGA cases, or LS-DYNA runtime instability and model-quality issues.
---

# HPC LS-DYNA

Follow a progressive loading workflow.

## Start

1. Read `references/workflow-and-keyword-architecture.md` before creating or restructuring any LS-DYNA deck.
2. Read `references/navigation-matrix.md` when the user first describes the problem and you need a one-page map from problem type to upstream branch, detailed reference, and starter or source-first entry point.
3. Read `references/terminology-and-branch-glossary.md` when writing or updating other LS-DYNA references so branch names and workflow terms stay stable.
4. Read `references/controls-stability-and-accuracy.md` when choosing explicit versus implicit, timestep control, mass scaling, damping, shell formulation, or hourglass treatment.
5. Read `references/materials-and-sections.md` when selecting `*MAT`, `*SECTION`, constitutive assumptions, concrete/composite/polymer models, or element formulations.
6. Read `references/contact-and-constraints.md` when choosing automatic contact, tied contact, thickness treatment, edge handling, preload transfer, or connector strategy.
7. Read `references/implicit-thermal-and-multiphysics.md` for implicit setup and non-structural solver families such as thermal, ALE, SPH, ICFD, EM, DEM, CESE, and IGA.
8. Read `references/scenario-recipes.md` for concrete model recipes mapped to common engineering problems.
9. Read `references/example-catalog.md` when the user needs a close precedent from `dynaexamples.com`.
10. Read `references/implicit-example-recipes.md` when the user needs a detailed implicit structural precedent with guidance on which controls to port and which assumptions to discard.
11. Read `references/thermal-example-recipes.md` when the user needs a detailed thermal or thermal-structural precedent.
12. Read `references/sph-example-recipes.md` when the user needs a detailed SPH precedent for bird strike, particle impact, grease or gel media, or free-surface wave interaction.
13. Read `references/ale-s-ale-example-recipes.md` when the user needs an ALE or S-ALE precedent for explosion, sloshing, advection, or ALE FSI.
14. Read `references/welding-example-recipes.md` when the user needs a welding-specific precedent and a clear split between coupled and uncoupled workflows.
15. Read `references/showcase-contact-preload-recipes.md` when the user needs a concise precedent for contact-overview, interference, drop-test, joint, preload, or bolt showcase pages.
16. Read `references/icfd-example-recipes.md` when the user needs a detailed ICFD precedent with guidance on which controls to port and which assumptions to discard.
17. Read `references/em-example-recipes.md` when the user needs a detailed EM, inductive heating, resistive heating, or electromagnetic forming precedent.
18. Read `references/nvh-example-recipes.md` when the user needs FRF, SSD, random vibration, acoustics, response spectrum, or brake squeal precedent.
19. Read `references/dem-example-recipes.md` when the user needs a DEM precedent for granular injection, filling, storage, or discharge.
20. Read `references/cese-example-recipes.md` when the user needs a CESE or DUAL-CESE precedent for shock-dominated compressible flow or compressible FSI.
21. Read `references/iga-example-recipes.md` when the user needs an IGA precedent for trimmed-NURBS geometry and spline-based structural analysis.
22. Read `references/efg-example-recipes.md` when the user needs an EFG precedent for metal cutting, forging, or severe deformation.
23. Read `references/starter-deck-selection.md` when the user needs to know which starter deck or minimal project directory should be used as the first scaffold.
24. Read `references/source-map-and-page-taxonomy.md` when the user asks for provenance, source coverage, or which upstream page family to mine next.
25. Read `references/error-recovery.md` when the deck diverges, runs too slowly, throws segmentation violations, produces negative volume, or shows nonphysical energy/contact behavior.

## Work Sequence

1. Classify the model first: explicit or implicit, single-physics or coupled, shell-dominant or solid-dominant, contact-light or contact-heavy, rate-sensitive or quasi-static.
2. Lock a consistent unit system before any parameter tuning. Do not mix geometry, density, modulus, load, and time scales from different systems.
3. Build or audit the include tree so ownership is clear:
   - top deck and run controls
   - geometry and sets
   - sections, materials, and parts
   - boundary conditions and loads
   - contacts, constraints, and output cards
4. Match formulation to the physics:
   - explicit crash, impact, or crush: stable timestep, contact robustness, energy balance, hourglass control
   - implicit static or quasi-static: convergence controls, supported materials and elements, load stepping, contact stiffness sensitivity
   - fluid or multiphysics: activate only the solver family that matches the example lineage or manual path
5. Validate before a long run:
   - check missing includes, duplicated IDs, free parts, and disconnected sets
   - inspect shell normals, thickness, offsets, and section formulations
   - inspect contact pairs, tied interfaces, and initial penetrations
   - inspect expected timestep bottlenecks and whether mass scaling is justified
6. Make every tuning change traceable. Change one stability lever at a time and re-check energy, contact force, and deformation quality before compounding fixes.

## Scenario Loading

Load the relevant reference when the task centers on:

- `references/controls-stability-and-accuracy.md` - timestep size, `DT2MS`, quasi-static strategy, damping, impact recommendations, double precision, accuracy checks, and energy interpretation
- `references/materials-and-sections.md` - metals, polymers, viscoelasticity, viscoplasticity, composites, concrete, soft materials, EOS usage, shell and beam formulation choices
- `references/contact-and-constraints.md` - automatic contact families, thickness handling, contact-driven timestep collapse, tied and tiebreak interfaces, connector and preload patterns
- `references/navigation-matrix.md` - one-page matrix from problem type to upstream branch, detailed reference, and starter or source-first entry point
- `references/terminology-and-branch-glossary.md` - stable terminology for branch names, workflow stages, and starter vocabulary
- `references/implicit-thermal-and-multiphysics.md` - implicit support limits, thermal and coupled thermal-structural workflows, ALE/S-ALE, SPH, ICFD, EM, DEM, CESE, showcase, and IGA coverage
- `references/scenario-recipes.md` - ready-made modeling paths for suspension loading, bird strike, thermal stress, explosion, cooling flow, metal cutting, eddy currents, shock-bubble interaction, and more
- `references/implicit-example-recipes.md` - detailed implicit case mapping for Yaris static or dynamic loading, door sag, buckling, springback, and bolt preload families
- `references/thermal-example-recipes.md` - detailed thermal case mapping for thermal stress, forming, heat transfer, radiation, welding, thermal contact, and shell thermal gradients
- `references/sph-example-recipes.md` - detailed SPH case mapping for bird strike, free-particle impact, grease and foam media, and wave-structure interaction
- `references/ale-s-ale-example-recipes.md` - detailed ALE and S-ALE case mapping for explosion, sloshing, advection, ALE bird alternatives, and structured-ALE workflows
- `references/welding-example-recipes.md` - welding-specific mapping for coupled solids, coupled shells, and uncoupled thermal-to-structural continuations
- `references/showcase-contact-preload-recipes.md` - concise mapping for contact overview, interference, drop tests, joints, preload, and bolt showcase pages
- `references/icfd-example-recipes.md` - detailed ICFD case mapping for cylinder flow, thermal flow, turbulence, FSI, tool cooling, and advanced fluid benchmarks
- `references/em-example-recipes.md` - detailed EM case mapping for eddy currents, inductive heating, EM forming, TEAM benchmarks, motors, and resistive-heating workflows
- `references/nvh-example-recipes.md` - detailed NVH case mapping for FRF, SSD, PSD/random vibration, fatigue, acoustics, response spectrum, and brake squeal
- `references/dem-example-recipes.md` - DEM mapping for granular injection, filling, discharge, and source-first adaptation of particulate examples
- `references/cese-example-recipes.md` - CESE and DUAL-CESE mapping for shock tubes, shock diffraction, shock-bubble interaction, cavitation, and compressible FSI
- `references/iga-example-recipes.md` - IGA mapping for trimmed-NURBS tensile examples and source-first spline-model adaptation
- `references/efg-example-recipes.md` - EFG mapping for metal cutting and adaptive meshfree severe-deformation workflows
- `references/starter-deck-selection.md` - starter-deck chooser that maps case families to the most appropriate scaffold in `assets/templates/`

## Guardrails

- Do not invent keyword names, optional fields, or material parameters.
- Do not apply mass scaling only because the run is slow; justify it against physics fidelity and energy history.
- Do not treat hourglass energy, contact energy, or rigidwall work as noise; use them as diagnostic signals.
- Do not choose shell, solid, beam, or contact formulations independently of thickness, aspect ratio, loading mode, and expected deformation.
- Do not move an unstable explicit model to implicit as a shortcut if the physics is still dominated by high-speed impact or severe contact transitions.
- Do not assume a material or element is supported in implicit just because it exists in explicit.
- Do not reuse a dynaexamples deck blindly; map its assumptions, units, controls, and solver family to the current problem first.

## Reusable Assets

Use `assets/templates/` for starter decks and project scaffolds when a clean starting structure is needed:

- `explicit-impact-outline.k` - semi-runnable explicit shell-impact starter with baseline controls, outputs, material, and load ramp
- `implicit-static-outline.k` - semi-runnable implicit static starter with preload-ready controls and displacement-driven loading
- `bolt-preload-implicit-starter.k` - joint and clamp-load starter patterned after the Dynaexamples bolt/preload showcase family
- `icfd-tool-cooling-starter.k` - LS-DYNA ICFD starter for coolant/channel or tool-cooling workflows
- `thermal-coupled-starter.k` - coupled or thermal-only starter for thermal stress, heat transfer, thermal contact, shell heating, and welding thermal stages
- `sph-bird-impact-starter.k` - SPH starter for bird strike, SPH projectile impact, and free-surface adaptations
- `ale-explosion-starter.k` - ALE starter for underwater blast, sloshing, Eulerian transport, and short-time fluid-structure interaction
- `model-include-tree.txt` - suggested include partition for large projects

Use `assets/templates/examples/` when a minimal project directory is more useful than a single deck:

- `explicit-impact-minimal/`
- `implicit-static-minimal/`
- `bolt-preload-minimal/`
- `thermal-coupled-minimal/`
- `icfd-tool-cooling-minimal/`
- `sph-bird-impact-minimal/`
- `ale-explosion-minimal/`

## Outputs

Produce a short model summary that states:

- solver family and intended physics
- unit system and critical scales
- elements, sections, materials, and contacts touched
- timestep and stabilization strategy
- expected observability outputs
- leading risks and the next diagnostic step
