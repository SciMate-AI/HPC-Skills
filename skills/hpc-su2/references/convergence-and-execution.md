# SU2 Convergence And Execution

## Contents

- Execution commands
- Convergence controls
- Monitoring outputs
- Multizone notes

## Execution commands

High-value official commands include:

- `SU2_CFD`
- `SU2_SOL`
- `SU2_DEF`
- `SU2_DOT`

Use the narrowest command that matches the current task instead of routing every step through one driver.

## Convergence controls

Treat residual and history output as first-class diagnostics.

Practical rules:

- pick iteration budgets that match the case difficulty
- monitor residual decrease, not just final iteration count
- if aerodynamic coefficients are the target, monitor them directly in addition to residuals

## Monitoring outputs

Use config-driven monitoring for:

- residual history
- aerodynamic coefficients
- surface outputs

If the user mostly needs coefficients, bias the config toward reliable monitored outputs rather than oversized field dumps.

## Multizone notes

The SU2 docs describe multizone workflows separately.

Inference for the skill:

- multizone is a dedicated workflow, not a small variation of a single-zone config
- if the case is partitioned by physics or region, check whether `SU2_CFD` single-zone assumptions still apply
