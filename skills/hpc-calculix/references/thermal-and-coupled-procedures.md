# CalculiX Thermal And Coupled Procedures

## Contents

- thermal workflow
- coupled temperature-displacement logic
- procedure selection matrix

## Thermal workflow

CalculiX supports thermal procedures through dedicated keywords such as heat-transfer-related blocks.

Use thermal workflows when:

- temperature is a solved field
- conductivity or thermal loading is part of the model

Do not fake a thermal solve with only structural load keywords.

## Coupled temperature-displacement logic

The CalculiX keyword documentation includes coupled procedures.

Use coupled logic when:

- thermal strain feeds structural deformation
- a staged sequential workflow is not enough

If the user only needs thermal preload followed by structure, decide whether a staged workflow is simpler and more robust than full coupling.

## Procedure selection matrix

| Goal | Typical direction |
| --- | --- |
| structural static response | `*STATIC` |
| modal information | `*FREQUENCY` |
| thermal field | heat-transfer procedure |
| thermal-structural coupling | coupled temperature-displacement family |

Choose the procedure family before writing output expectations and load definitions.
