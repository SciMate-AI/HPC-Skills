# Terminology And Branch Glossary

## Purpose

Use this file to keep terms stable across the skill. Prefer these names in new references, starter notes, and user-facing summaries.

## Preferred Terms

- explicit structural
  Meaning: standard LS-DYNA explicit structural dynamics for crash, impact, crush, forming, and contact-rich transient events

- implicit structural
  Meaning: static, quasi-static, or transient implicit structural solves

- preload stage
  Meaning: the stage that establishes bolt force, clamp load, gravity-settled contact, or assembly closure before service loading

- service stage
  Meaning: the stage after preload where the actual use-case load is applied

- thermal-only
  Meaning: the run solves temperature but not structural response in the same stage

- coupled thermal-structural
  Meaning: the run solves temperature and structural response in the same stage

- mapped thermal continuation
  Meaning: a structural run that imports temperature fields from `binout` or `d3plot`

- source-first branch
  Meaning: a solver family where the local skill intentionally recommends starting from the upstream validated example rather than a generic local starter

- starter deck
  Meaning: a single-file semi-runnable scaffold in `assets/templates/`

- minimal project
  Meaning: a directory under `assets/templates/examples/` containing `main.k` plus local include placeholders

- detailed reference
  Meaning: a branch-specific file such as `icfd-example-recipes.md` or `thermal-example-recipes.md`

- upstream branch
  Meaning: the source family on `dynaexamples.com` or `dynasupport.com`

## Branch Naming

Use these branch names consistently:

- ICFD
- ALE and S-ALE
- SPH
- EM
- NVH
- DEM
- CESE and DUAL-CESE
- IGA
- EFG
- showcases

Avoid mixing:

- `thermo-mechanical` and `thermal-structural`
  Prefer: `thermal-structural`

- `starter` and `template directory`
  Prefer:
  `starter deck` for a single `.k` file
  `minimal project` for a directory scaffold

- `source example`, `upstream example`, and `reference example`
  Prefer: `upstream example`

## Related References

- `navigation-matrix.md`
- `starter-deck-selection.md`
- `workflow-and-keyword-architecture.md`

