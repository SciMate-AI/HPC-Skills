# Gmsh Physical Groups And Entity Tagging

## Why physical groups matter

Downstream solvers usually care about physical groups, not raw entity IDs.

Use physical groups to encode:

- boundary names
- material regions
- subdomains
- interface surfaces

## Tagging rules

Good habits:

- define physical groups after the geometry is stable enough to inspect
- name groups with solver-facing meaning, not temporary geometry intent
- keep one clear mapping between dimension and meaning

## Stability rule

Raw entity tags can change after geometry edits or booleans.

If a downstream code needs stable IDs:

- define physical groups explicitly
- record which dimension each group belongs to
- verify the exported mesh contains the intended groups before handoff

## Common dimensions

| Meaning | Typical dimension |
| --- | --- |
| point marker | 0 |
| edge or curve boundary | 1 |
| surface boundary or 2D region | 2 |
| volume region | 3 |
