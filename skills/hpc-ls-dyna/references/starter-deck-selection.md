# Starter Deck Selection

## Purpose

Use this file to choose the first starter deck before loading a more detailed example-reference file.

If the task will become a multi-file project immediately, prefer the matching directory under `assets/templates/examples/` instead of starting from a single `.k` file.

## Starter Map

- `assets/templates/explicit-impact-outline.k`
  Use for: generic crash, impact, crush, shell or solid explicit structural events, perforated-target impact, and explicit baselines before adding SPH or ALE
  Related references: `scenario-recipes.md`, `sph-example-recipes.md`, `showcase-contact-preload-recipes.md`
  Minimal project: `assets/templates/examples/explicit-impact-minimal/`

- `assets/templates/implicit-static-outline.k`
  Use for: static suspension loading, door sag, springback continuation, beam buckling, slow assembly load, and structural continuation after mapped thermal fields
  Related references: `implicit-example-recipes.md`, `thermal-example-recipes.md`
  Minimal project: `assets/templates/examples/implicit-static-minimal/`

- `assets/templates/bolt-preload-implicit-starter.k`
  Use for: bolt types A-D, clamp load, joint closure, pretension carryover, and preload-sensitive service loading
  Related references: `implicit-example-recipes.md`, `contact-and-constraints.md`
  Minimal project: `assets/templates/examples/bolt-preload-minimal/`

- `assets/templates/icfd-tool-cooling-starter.k`
  Use for: coolant channels, mold or tool cooling, conjugate-like flow-and-thermal transport, internal thermal-fluid problems
  Related references: `icfd-example-recipes.md`, `thermal-example-recipes.md`
  Minimal project: `assets/templates/examples/icfd-tool-cooling-minimal/`

- `assets/templates/thermal-coupled-starter.k`
  Use for: thermal stress, transient or steady heat transfer, radiation or convection, thermal contact, thick/thin thermal shells, and welding thermal stage setup
  Related references: `thermal-example-recipes.md`, `welding-example-recipes.md`
  Minimal project: `assets/templates/examples/thermal-coupled-minimal/`

- `assets/templates/sph-bird-impact-starter.k`
  Use for: bird strike, free particle impact, SPH fluid-like projectiles, Taylor-bar-style SPH impact, grease or gel media, and wave-impact SPH adaptations
  Related references: `sph-example-recipes.md`
  Minimal project: `assets/templates/examples/sph-bird-impact-minimal/`

- `assets/templates/ale-explosion-starter.k`
  Use for: underwater blast, ALE sloshing, Eulerian advection comparisons, ALE bird alternatives, and short-time ALE FSI baselines
  Related references: `ale-s-ale-example-recipes.md`
  Minimal project: `assets/templates/examples/ale-explosion-minimal/`

## Selection Rules

1. Choose the starter by dominant solver family, not by industry label.
2. If the case has a preload stage and a service stage, start from the preload-capable starter first.
3. If the case solves temperature as a field, prefer the thermal starter; if temperature is only an imported load, prefer the structural starter.
4. If the case uses SPH particles to model the impacting medium, prefer the SPH starter even if the target is a shell or solid structure.
5. If the case is truly flow-dominated with inlet or outlet physics, prefer the ICFD starter over the thermal starter.
6. If the medium lives on an Eulerian background mesh and advection accuracy is part of the problem, prefer the ALE starter over the SPH starter.

## Source-First Branches

These branches are intentionally not mapped to a fully generic local starter yet because the solver-specific keyword families are too specialized to template safely without a validated example deck:

- `references/dem-example-recipes.md`
  Use the upstream `Injection Analysis` example as the first scaffold, then reorganize it into the local include tree.

- `references/cese-example-recipes.md`
  Use the nearest upstream `CESE` or `DUAL-CESE` example as the first scaffold. Choose the exact benchmark by flow regime and coupling needs.

- `references/iga-example-recipes.md`
  Use the upstream `Tensile Test` example as the first scaffold because the IGA geometry and patch keywords are highly specialized.

- `references/efg-example-recipes.md`
  Use the upstream `Metal Cutting` example as the first scaffold because adaptive EFG setup is formulation-specific.
