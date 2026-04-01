# hypre Krylov And Preconditioner Matrix

## Operator-class mapping

| Operator class | First baseline |
| --- | --- |
| SPD-like sparse operator | `PCG` with `BoomerAMG` |
| mildly nonsymmetric sparse operator | `GMRES` with `BoomerAMG` |
| stronger nonsymmetry or preconditioner variability | `FlexGMRES` with `BoomerAMG` |
| debugging through a host code with direct-solve support | use the host direct baseline first, then return to hypre |

## Preconditioner role

Treat `BoomerAMG` primarily as:

- a full solver for some elliptic baselines
- a preconditioner for Krylov methods when the outer iteration still matters

Choose the role explicitly. Do not let the host application's defaults hide whether AMG is the main solver or only the preconditioner.

## Switching rules

Switch away from the default baseline only when:

- the operator is clearly not SPD-like
- monitor output shows outer-iteration behavior that the baseline cannot handle
- the host application constrains the available Krylov choices
