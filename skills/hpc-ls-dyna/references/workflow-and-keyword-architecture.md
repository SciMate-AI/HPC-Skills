# LS-DYNA Workflow And Keyword Architecture

## Source Focus

- `dynasupport.com/tutorial/getting-started-with-ls-dyna`
- `dynasupport.com/howtos/general/consistent-units`
- `dynasupport.com/howtos/general/accuracy`
- `dynasupport.com/howtos/general/recommendations-for-structural-impact`
- `dynaexamples.com` category and example pages

## Use This Reference For

- first-pass deck construction
- include-tree refactors
- unit-system audits
- planning output cards and validation checkpoints

## Related References

- `navigation-matrix.md`
- `starter-deck-selection.md`
- `terminology-and-branch-glossary.md`

## Canonical Build Order

Organize the model so the top deck is readable and the include tree mirrors engineering ownership:

1. Header and run identity: `*KEYWORD`, `*TITLE`, include list, revision comments.
2. Global controls: termination, timestep, output cadence, precision-sensitive controls, memory-sensitive controls.
3. Databases and observability: `d3plot`, `glstat`, `matsum`, contact/interface outputs, history outputs for key sets and parts.
4. Geometry and topology: nodes, elements, sets, part sets, segment sets, contact sets.
5. Sections and materials: define formulation and constitutive behavior before part assignment.
6. Parts: bind each part to a section and a material, keep naming stable and descriptive.
7. Loads and constraints: initial velocity, SPCs, prescribed motion, load curves, rigidwalls, joints, pretension logic.
8. Contacts and tied interfaces: keep contact definitions centralized unless the model is extremely modular.
9. Optional coupled solvers: thermal, ALE, ICFD, EM, SPH, DEM, CESE, or IGA blocks.

## Model Classification Before Editing

Classify the problem before touching keyword values:

- explicit structural dynamics: crash, impact, drop, crush, blast, bird strike, forming, fast contact transitions
- implicit structural: static preload, slow large deformation, springback, quasi-static loading, modal or NVH-style tasks
- thermal or coupled thermal-structural: heat-up, thermal stress, conduction-driven preload shift
- fluid or multiphysics: ALE, S-ALE, SPH, ICFD, EM, DEM, CESE, and FSI-style workflows

The classification decides which controls are legitimate. Do not copy an explicit control block into an implicit deck or vice versa.

## Unit-System Discipline

`dynasupport.com` emphasizes that LS-DYNA does not carry units internally. Consistency is entirely on the user. Treat the unit system as a hard contract across:

- geometry
- density
- elastic modulus and strength
- time
- load and energy
- thermal properties if present

Recommended practice:

1. Write the chosen unit system in the deck header and in every review summary.
2. Sanity-check characteristic wave speed, gravity magnitude, expected velocity, and timestep scale.
3. Reject imported material cards until density, modulus, and failure parameters are re-scaled into the active system.

## Include-Tree Pattern For Large Projects

Prefer a top-level structure like:

- `00_main_control.k`
- `10_geometry/`
- `20_sets/`
- `30_sections_materials/`
- `40_parts/`
- `50_loads_bc/`
- `60_contact_constraints/`
- `70_output/`
- `80_coupling_optional/`

This keeps frequent edits isolated and reduces ID-collision risk when many people contribute.

## First-Pass Validation Checklist

Before solver launch, inspect:

- duplicate or missing IDs
- orphan parts or unreferenced materials
- shell normals, offsets, and thickness data
- solid Jacobian quality and element distortion risk
- free-flying components caused by missing constraints or tied interfaces
- contact coverage on every expected interface
- database requests sufficient to debug the first run

## Output Strategy

Always request enough observability for model qualification:

- global energy and timestep history
- part or material energy summaries for major subsystems
- contact summaries if contact drives the event
- displacement, force, or acceleration histories at engineering decision points

The first run is a diagnostic run. Optimize output size only after the model is physically credible.

## Accuracy Baseline

`dynasupport.com/howtos/general/accuracy` frames accuracy as a modeling-system problem rather than a single keyword issue. Audit:

- mesh density and aspect ratio
- contact representation and penetrations
- material calibration range
- timestep and mass scaling impact
- hourglass energy and deformation mode quality
- whether the example lineage matches the intended physics

If the model disagrees with expected behavior, trace the discrepancy through geometry, material, contact, boundary conditions, and controls in that order.
