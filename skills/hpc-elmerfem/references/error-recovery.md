# ElmerFEM Error Recovery

## Contents

- parsing failures
- ID mapping failures
- solver and equation mismatches
- output interpretation failures

## Parsing failures

If ElmerSolver rejects the `.sif`:

1. inspect block names and key spelling
2. inspect ID references
3. inspect string versus numeric value syntax

## ID mapping failures

Typical failure class:

- body uses missing material or equation IDs
- boundary condition references the wrong boundary ID
- initial condition is attached to the wrong body

Fix the mapping graph before altering solver tolerances.

## Solver and equation mismatches

If the solve runs but behaves nonsensically:

1. inspect whether the chosen solver family matches the physics
2. inspect body-to-equation assignment
3. inspect material completeness

## Output interpretation failures

If results exist but look wrong:

1. verify the correct body or boundary IDs were targeted
2. verify the expected field is actually solved by the active equation set
3. verify the output was requested for the current workflow
