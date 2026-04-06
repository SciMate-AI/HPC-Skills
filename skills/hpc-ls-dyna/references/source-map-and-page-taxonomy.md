# Source Map And Page Taxonomy

## Purpose

Use this reference when you need to know where a topic lives in the upstream sites, or when the task is to expand the skill further from the same source families.

## Dynasupport Coverage Map

The `dynasupport.com/sitemap` structure relevant to LS-DYNA work breaks down into:

- tutorial
  - getting started with LS-DYNA
- howtos/general
  - accuracy
  - consistent units
  - damping
  - double precision
  - equations of state
  - mass scaling
  - quasi-static simulation
  - recommendations for structural impact
- howtos/material
  - anisotropic plasticity models
  - cohesive material models
  - concrete models
  - composite materials and layups
  - Eulerian materials
  - material models for polymers
  - negative volume in soft materials
  - viscoelastic materials
  - viscoplastic materials
- howtos/element
  - beam formulations
  - discrete beams and springs
  - hourglass
  - shell formulations in LS-DYNA
  - shell thickness offset
  - shell output
  - strain measures
- howtos/contact
  - contact overview
  - contact stiffness and `SOFT`
  - contact thickness
  - contact timestep
  - edge-to-edge contact
  - tied contact
  - contacts for spot welds and bolts
- howtos/implicit
  - elements and material models available for implicit
  - implicit checklist
- faq/general
  - segmentation violation
  - instabilities in the simulation
  - reasons for long run times
  - what is mass scaling
- manuals, formulas, theoretical manual, and links into the extended LS-DYNA manual ecosystem

## Dynaexamples Coverage Map

The `dynaexamples.com/sitemap` structure relevant to LS-DYNA work breaks down into:

- introductory courses
- implicit
- thermal
- sph
- nvh
- icfd
  - basics examples
  - advanced examples
  - beta examples
- ale-s-ale
  - ALE
  - S-ALE
- em
- dem
- efg
- cese
  - CESE
  - dual-CESE
- showcases
- iga

Representative named examples exposed in the sitemap or example pages include:

- Yaris static suspension system loading
- thermal stress
- bird strike
- water impact
- cylinder flow
- tool cooling
- explosion
- contact overview
- preload
- metal cutting
- shock bubble interaction
- tensile test

## Retrieval Strategy

Use `dynasupport.com` first when the question is:

- which modeling choice is appropriate
- why a run is unstable
- how to choose materials, contact, or solver family
- what a control concept means

Use `dynaexamples.com` first when the question is:

- show me a similar case
- which solver family has precedent for this physics
- what a full applied workflow looks like
- how a coupled or advanced formulation is typically organized

## Expansion Guidance

If the skill needs more detail later, expand in this order:

1. add more named examples under the already-existing branches in `example-catalog.md`
2. add deeper per-physics recipe files only for branches that users actually request
3. add template decks only after the exact keyword syntax has been checked against the active manual or trusted in-repo precedent

