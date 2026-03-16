# CalculiX Step, Load, And Output Matrix

## Contents

- Procedure-to-load matrix
- Procedure-to-output matrix
- Stability and singularity checklist

## Procedure-to-load matrix

| Step family | Typical compatible load logic |
| --- | --- |
| `*STATIC` | supports, nodal loads, distributed loads, amplitudes as needed |
| `*FREQUENCY` | preload-compatible setup if modal analysis depends on prior state |
| heat-transfer family | temperature or heat-flux style conditions |
| coupled temperature-displacement family | thermal and structural loading together |

If the procedure family and load type do not match, fix that before reworking the mesh.

## Procedure-to-output matrix

| Step family | Typical outputs of interest |
| --- | --- |
| static structural | displacement, stress, strain, reaction behavior |
| frequency | eigenfrequencies, mode shapes, `.eig` when applicable |
| thermal | temperature fields, thermal gradients or flux-related outputs |
| coupled thermal-structural | both thermal and structural responses |

Request outputs that the active step can actually produce.

## Stability and singularity checklist

| Symptom | First things to inspect |
| --- | --- |
| singular model | missing supports, contradictory BCs, disconnected sets |
| wrong modal behavior | preload state, density, frequency setup |
| thermal response missing | wrong procedure family, wrong BC field, missing conductivity |

Do not treat singularity as a post-processing issue. It is usually a support or step-definition problem.
