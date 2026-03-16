# CalculiX Element, Section, And Material Matrix

## Contents

- Element-to-section matrix
- Material-definition matrix
- Set-link matrix

## Element-to-section matrix

| Element family | Typical section keyword |
| --- | --- |
| solid continuum | `*SOLID SECTION` |
| beam family | `*BEAM SECTION` |
| shell family | shell-style section keyword when supported in the chosen formulation |

If the element family and section keyword do not match, fix that before checking loads.

## Material-definition matrix

| Material behavior | Typical keywords |
| --- | --- |
| linear elasticity | `*MATERIAL`, `*ELASTIC` |
| inertia or modal density | `*DENSITY` |
| thermal conductivity | `*CONDUCTIVITY` |

Material blocks are only useful if the later section assignment points at the right material name.

## Set-link matrix

| Consumer keyword | Expected set type |
| --- | --- |
| `*SOLID SECTION` | element set |
| `*BEAM SECTION` | element set |
| `*BOUNDARY` | node set or node range |
| `*CLOAD` | node set or node |

If a keyword expects an element set and is given a node set, fix that linkage first.
