# Gaussian SCF Optimization Frequency And Solvation

## Purpose

Use this reference when the main decision is how to stabilize SCF behavior, structure an optimization, add frequencies, or include solvent treatment.

## SCF staging

Portable sequence:

1. validate that the input and electronic state are coherent
2. run the simplest meaningful SCF setup
3. only then add heavier convergence or restart tactics

Do not use aggressive recovery keywords as a substitute for a broken molecular or electronic-state definition.

## Optimization logic

Optimization runs should start only after:

- the structure is reasonable
- the method stack is intentional
- checkpoint policy is defined

For fragile systems, keep optimization and follow-on analysis in separate, clearly named stages.

## Frequency logic

Frequency calculations are commonly used to:

- verify stationary-point character
- obtain thermochemical data
- inspect vibrational behavior

Do not assume an optimization result is trustworthy until the frequency stage agrees with the intended stationary-point type.

## Solvation logic

Solvent models should be treated as part of the route intent, not decoration.

Checklist:

- solvent model is explicit
- solvent identity is explicit when relevant
- any required read sections are present when the chosen route needs them

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| SCF is unstable from the first iterations | electronic setup or geometry is inconsistent | verify charge, multiplicity, and structure before changing SCF controls |
| optimization stalls or oscillates | geometry path is fragile | separate geometry cleanup from high-accuracy production |
| frequency results are not physically useful | optimization did not reach the intended point | return to the geometry stage |
| solvent run behaves unexpectedly | route or additional-input assumptions are incomplete | restate model and solvent choices explicitly |
