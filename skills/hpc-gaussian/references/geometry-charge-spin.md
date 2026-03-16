# Gaussian Geometry Charge And Spin

## Purpose

Use this reference when the structure block, total charge, multiplicity, or fragment logic is the main uncertainty.

## Charge and multiplicity

The charge and multiplicity line is not optional metadata. It defines the electronic state the route section will solve.

Checklist:

- total charge matches the intended species
- multiplicity matches the intended spin state
- open-shell systems are treated deliberately, not by guesswork

## Geometry block

Keep the geometry block explicit and internally consistent:

- one element symbol per atom
- one coordinate triplet per atom
- one coordinate convention per input

If the structure source is uncertain, solve that first before touching SCF settings.

## Fragment-sensitive cases

For fragment-based or special spin constructions:

- define fragments deliberately
- keep per-fragment assumptions documented
- do not treat fragment charge and spin data as interchangeable with total system charge and multiplicity

## Restart-sensitive geometry

When continuing from a prior stage:

- confirm whether the new job should read geometry from a checkpoint
- do not keep stale geometry and stale checkpoint assumptions active together without intent

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| SCF never behaves sensibly | wrong charge or multiplicity | verify electronic state before tuning numerics |
| restart changes the structure unexpectedly | geometry and checkpoint sources disagree | choose one authoritative geometry source |
| fragment-based setup is inconsistent | fragment data not aligned with total system definition | restate the fragment and total-state assumptions clearly |
