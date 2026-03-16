# GROMACS `.mdp` Coupling And Constraints Matrix

## Contents

- stage-to-coupling matrix
- timestep and constraints matrix
- output-control matrix

## Stage-to-coupling matrix

| Stage | Typical coupling choice |
| --- | --- |
| energy minimization | no thermostat or barostat, minimization integrator |
| NVT | thermostat on, pressure coupling off |
| NPT | thermostat on, pressure coupling on |
| production | ensemble-specific, often inherited from equilibrated setup |

Do not leave pressure coupling enabled in a supposed NVT stage by accident.

## Timestep and constraints matrix

The official sample `.mdp` guidance notes that timestep choice depends on the force field and constraints.

Practical rules:

| Situation | Typical implication |
| --- | --- |
| constrained bonds to hydrogens | larger stable timestep may be acceptable |
| unconstrained fast motions | use more conservative timestep |
| heavy-hydrogen or specialized mass repartitioning workflow | verify force-field-specific guidance before increasing timestep |

If timestep was copied from another project, re-check it against the current constraints and model family.

## Output-control matrix

| Target | Typical `.mdp` keys |
| --- | --- |
| log cadence | `nstlog` |
| energy cadence | `nstenergy` |
| compressed trajectory cadence | `nstxout-compressed` |
| full coordinate or velocity outputs | `nstxout`, `nstvout` |

If the run is mainly for statistics, prefer compact and deliberate output cadence instead of maximal file dumping.
