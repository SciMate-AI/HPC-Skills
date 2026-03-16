# CalculiX Mesh, Boundary, And Output

## Contents

- nodes, elements, and sets
- BC assignment logic
- output requests

## Nodes, elements, and sets

High-value rules:

- node IDs and element IDs must be stable and unique
- `*NSET` and `*ELSET` are the main selection surfaces
- later section, BC, load, and output keywords usually point at those sets

If the deck grows, set naming discipline matters more, not less.

## BC assignment logic

Apply supports and loads through:

- named node sets when possible
- clearly scoped set definitions

Do not spread the same physical support across many ad hoc singleton definitions unless the workflow requires it.

## Output requests

Result outputs should match the analysis question.

Typical intent:

- displacements for static structural response
- stresses and strains for strength or failure screening
- frequencies and mode shapes for vibration studies

Ask for the result class that the current step can actually produce.
