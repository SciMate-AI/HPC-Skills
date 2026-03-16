# CalculiX Time Control And Amplitudes

## Contents

- step time semantics
- amplitude logic
- static loading defaults
- practical staged loading

## Step time semantics

The official CalculiX keyword docs state:

- each step has a local step time starting at zero
- the step time period is defined on the procedure keyword such as `*STATIC`
- total time accumulates across steps

Treat time as part of step design, not as an incidental number.

## Amplitude logic

`*AMPLITUDE` scales reference loading values from keywords such as:

- `*BOUNDARY`
- `*CLOAD`
- `*DLOAD`
- `*TEMPERATURE`

If an amplitude is absent in a static step, the official docs describe ramp loading from the previous value to the current reference value.

## Static loading defaults

For `*STATIC`:

- default load progression is ramped
- step time period controls the interpretation of amplitude progression

Do not assume an explicitly constant load history if the amplitude definition actually ramps or varies.

## Practical staged loading

Use staged loading when:

- preload then perturbation is needed
- a contact or nonlinear solve benefits from gradual load application
- modal or frequency steps depend on a preloaded state

If the user asks for preload-sensitive frequency work, keep the static reference state explicit.
