# CalculiX Keyword And Step Matrix

## Contents

- analysis-step matrix
- material and section matrix
- load and BC matrix

## Analysis-step matrix

| Goal | Typical step keywords |
| --- | --- |
| linear or nonlinear static | `*STEP`, `*STATIC` |
| eigenfrequency extraction | `*STEP`, `*FREQUENCY` |
| dynamic or thermal variants | dedicated step and procedure keywords as supported |

Choose the step family before placing loads and output assumptions.

## Material and section matrix

| Concern | Typical keywords |
| --- | --- |
| isotropic elasticity | `*MATERIAL`, `*ELASTIC` |
| density | `*DENSITY` |
| solid element section assignment | `*SOLID SECTION` |

Material definitions and section assignments must meet at the right element set.

## Load and BC matrix

| Goal | Typical keywords |
| --- | --- |
| fixed displacement or support | `*BOUNDARY` |
| nodal force | `*CLOAD` |
| distributed or pressure-like loading | dedicated load keyword as supported |

If the step type and loading type are mismatched, fix the procedure definition before chasing mesh issues.
