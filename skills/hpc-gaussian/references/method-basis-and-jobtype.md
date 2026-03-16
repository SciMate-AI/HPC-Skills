# Gaussian Method Basis And Job Type

## Purpose

Use this reference when choosing the electronic structure method, basis set, and high-level job type.

## Job types

Common job intents:

| Job type | Typical use |
| --- | --- |
| single point | energy and properties on a fixed structure |
| optimization | relax geometry to a stationary point |
| frequency | vibrational analysis and stationary-point check |
| opt plus freq | optimized geometry followed by frequencies |
| scan or IRC | controlled path or coordinate-following work |
| stability | wavefunction stability check |

Start from the smallest job type that answers the question.

## Method selection

Method choice should reflect:

- target accuracy
- system size
- open-shell versus closed-shell behavior
- whether the workflow is ground-state or excited-state oriented

Do not separate method choice from wavefunction type. Restricted, unrestricted, and restricted-open-shell choices change the meaning of the calculation.

## Basis-set selection

Basis choice should reflect:

- element coverage
- target accuracy
- whether polarization or diffuse functions are needed
- whether the job is exploratory or production

Changing the basis without reconsidering cost and convergence can produce impractical jobs.

## Practical workflow rules

- validate a small single-point setup before a long optimization when the method stack is uncertain
- use frequency analysis to verify the character of an optimized stationary point
- do not move to heavier methods or larger bases before the geometry workflow is stable

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| job is far slower than expected | basis or method cost too high | downshift for validation or benchmark first |
| open-shell job behaves oddly | wrong restricted or unrestricted choice | re-evaluate wavefunction type |
| optimization is unstable from the start | method stack and geometry quality both uncertain | validate with a simpler staging strategy |
