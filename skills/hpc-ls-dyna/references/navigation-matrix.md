# LS-DYNA Navigation Matrix

## Purpose

Use this page as the single-entry navigation table for the skill. It maps problem type to:

- upstream branch
- detailed reference file
- local starter or source-first starting point

## Matrix

| Problem type | Upstream branch | Detailed reference | First start |
| --- | --- | --- | --- |
| Generic explicit impact, crash, crush, drop test | `dynasupport` general/contact + `dynaexamples/show-cases` | `scenario-recipes.md`, `showcase-contact-preload-recipes.md` | `assets/templates/explicit-impact-outline.k` or `assets/templates/examples/explicit-impact-minimal/` |
| Implicit static suspension, door sag, buckling, springback | `dynaexamples/implicit` | `implicit-example-recipes.md` | `assets/templates/implicit-static-outline.k` or `assets/templates/examples/implicit-static-minimal/` |
| Bolt preload, clamp load, service load after pretension | `dynaexamples/show-cases/bolts`, `preload` | `implicit-example-recipes.md`, `showcase-contact-preload-recipes.md` | `assets/templates/bolt-preload-implicit-starter.k` or `assets/templates/examples/bolt-preload-minimal/` |
| Thermal stress, conduction, radiation, thermal contact | `dynaexamples/thermal` | `thermal-example-recipes.md` | `assets/templates/thermal-coupled-starter.k` or `assets/templates/examples/thermal-coupled-minimal/` |
| Welding, coupled or uncoupled | `dynaexamples/thermal/welding-new` | `welding-example-recipes.md` | `assets/templates/thermal-coupled-starter.k` or `assets/templates/examples/thermal-coupled-minimal/`, then structural continuation from `implicit-static` |
| SPH bird strike, SPH impact, grease/foam media, wave impact | `dynaexamples/sph` | `sph-example-recipes.md` | `assets/templates/sph-bird-impact-starter.k` or `assets/templates/examples/sph-bird-impact-minimal/` |
| ICFD internal flow, tool cooling, thermal-fluid transport | `dynaexamples/icfd` | `icfd-example-recipes.md` | `assets/templates/icfd-tool-cooling-starter.k` or `assets/templates/examples/icfd-tool-cooling-minimal/` |
| ALE explosion, ALE sloshing, Eulerian transport, ALE FSI | `dynaexamples/ale-s-ale` | `ale-s-ale-example-recipes.md` | `assets/templates/ale-explosion-starter.k` or `assets/templates/examples/ale-explosion-minimal/` |
| EM, inductive heating, EM forming, TEAM benchmarks | `dynaexamples/em` | `em-example-recipes.md` | local project structure plus nearest EM upstream example |
| NVH, FRF, PSD, SSD, BEM/FEM acoustics, response spectrum | `dynaexamples/nvh` | `nvh-example-recipes.md` | nearest NVH upstream example, optionally staged with `implicit-static` output conventions |
| DEM granular fill/discharge/injection | `dynaexamples/dem` | `dem-example-recipes.md` | source-first: upstream `Injection Analysis` example |
| CESE / DUAL-CESE shock flow, cavitation, compressible FSI | `dynaexamples/cese` | `cese-example-recipes.md` | source-first: nearest CESE or DUAL-CESE example |
| IGA trimmed-NURBS shells | `dynaexamples/iga` | `iga-example-recipes.md` | source-first: upstream `Tensile Test` example |
| EFG metal cutting and severe deformation | `dynaexamples/efg` | `efg-example-recipes.md` | source-first: upstream `Metal Cutting` example |

## Reading Order

1. identify the dominant solver family in the matrix
2. load the corresponding detailed reference file
3. choose the listed starter or source-first upstream example
4. then load topic-specific references such as `materials-and-sections.md`, `contact-and-constraints.md`, or `error-recovery.md`

## Related References

- `starter-deck-selection.md`
- `source-map-and-page-taxonomy.md`
- `workflow-and-keyword-architecture.md`
