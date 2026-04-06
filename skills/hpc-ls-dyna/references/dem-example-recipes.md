# DEM Example Recipes

## Source Focus

- `dynaexamples.com/dem`
- `dynaexamples.com/dem/injection-analysis`

## Use This Reference For

- deciding whether a granular-flow problem belongs in DEM rather than ICFD, ALE, or a continuum constitutive model
- identifying which parts of the injection-analysis example are reusable and which are only demonstration geometry
- understanding when there is no safe generic local starter and the upstream example itself should be the starting scaffold

## Starter Deck Mapping

DEM is currently a source-first branch in this skill. Use the upstream `Injection Analysis` example as the base deck, then integrate project structure and observability conventions from:

- `assets/templates/model-include-tree.txt` for repository layout
- `references/workflow-and-keyword-architecture.md` for include-tree partitioning

Do not start from the structural, thermal, ICFD, or SPH starters for DEM. Their control families do not map cleanly to granular contact and bond logic.

## Common DEM Reuse Pattern

Copy these parts only after matching the granular problem:

- particle-generation or injection setup
- funnel, chute, or receptacle geometry partitioning
- granular contact and damping model family
- bond logic only when the material should behave as a bonded agglomerate rather than a free-flowing granular medium
- fill-level and discharge observability outputs

Do not copy these blindly:

- particle diameter distribution
- spring and damper constants
- friction coefficients
- bond parameters
- injection rate and total mass

## Injection Analysis

Applicable problem:

- granular injection into a funnel
- hopper filling, storage, discharge, or chute-fed handling
- first DEM learning deck

Key solver family:

- discrete element method for granular media

The branch overview states that DEM in LS-DYNA is intended for:

- mixing processes
- storage and discharge
- transportation on belts
- bonded-particle approximations when continuum-like behavior is needed

Copy these controls:

- source and sink partitioning around funnel geometry
- particle-flow observability
- contact-centric calibration mindset:
  friction, normal and tangential stiffness, and damping dominate outcome quality

Do not copy blindly:

- funnel angle
- particle count
- assume a free-flowing medium when the real problem needs cohesive agglomeration or bonded contacts

Starter:

- start from the upstream `Injection Analysis` example itself
- then re-structure into the local include tree from `assets/templates/model-include-tree.txt`

