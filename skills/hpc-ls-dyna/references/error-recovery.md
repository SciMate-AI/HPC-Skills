# Error Recovery

## Source Focus

- `dynasupport.com/faq/general/segmentation-violation-sigsegv`
- `dynasupport.com/faq/general/instabilities-in-the-simulation`
- `dynasupport.com/faq/general/reasons-for-long-run-times`
- `dynasupport.com/faq/general/what-is-mass-scaling`
- `dynasupport.com/howtos/contact/*`
- `dynasupport.com/howtos/material/negative-volume-in-soft-materials`
- `dynasupport.com/howtos/general/accuracy`

## Diagnostic Order

When the run fails, inspect in this order:

1. parser and include-tree issues
2. missing or conflicting IDs
3. first-time-step instability
4. contact-triggered instability
5. material or element distortion
6. performance bottleneck after the physics is already stable

## Segmentation Violation Or Abrupt Solver Crash

Treat a segmentation violation as a model or deck issue until proven otherwise. Check:

- broken include path or malformed keyword block
- duplicated IDs or corrupted imported data
- unsupported feature combinations
- contact or element definitions that trigger invalid internal state very early

Reproduce on the smallest failing window if possible.

## Instabilities

`dynasupport.com/faq/general/instabilities-in-the-simulation` frames instability as a symptom, not a diagnosis. Common roots:

- abrupt or unrealistic loading
- insufficient constraint or hidden rigid-body motion
- bad contact definitions or penetrations
- mesh distortion and negative volume
- inappropriate material calibration or units

Find the first bad frame and work backward to the responsible subsystem.

## Long Run Times

Slow runs usually come from one of four causes:

- tiny controlling elements
- expensive contact search across too many candidates
- unnecessarily fine output cadence
- excessive model complexity for the engineering question

Only after locating the bottleneck should you consider mass scaling, part simplification, or output reduction.

## Negative Volume And Element Collapse

If negative volume appears:

1. identify the element family and material
2. inspect the deformation mode in animation
3. check whether contact is driving impossible compression or inversion
4. review mesh density, aspect ratio, and whether the chosen formulation fits the strain state
5. in soft materials, review EOS and volumetric response assumptions

Do not mask negative volume with damping alone.

## Contact-Dominated Failure Pattern

Signals:

- timestep collapses on first touch
- severe force spikes or chatter
- unrealistic rebound or sticking
- parts eject without a plausible load path

Actions:

1. simplify to the minimum necessary contact set
2. inspect thickness and offset handling
3. inspect penetrations and normals
4. revisit contact stiffness only after geometry issues are cleared

## Mass-Scaling FAQ Logic

If the user asks whether mass scaling is acceptable, answer with evidence:

- why the timestep is small
- how much mass was added and where
- whether the event is quasi-static enough to tolerate it
- whether force, displacement, or timing changed materially

## Minimal Recovery Loop

1. cut the run to the first failure window
2. request the smallest set of histories needed to identify the offending part or interface
3. change one hypothesis at a time
4. promote the fix only after the failure mode is gone and the energy picture still makes sense

