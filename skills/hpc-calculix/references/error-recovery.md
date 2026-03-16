# CalculiX Error Recovery

## Contents

- parse failures
- set and section mismatches
- step and load incompatibilities
- result interpretation failures

## Parse failures

If the deck fails to parse:

1. inspect keyword spelling and ordering
2. inspect comma-separated parameter syntax
3. inspect referenced set and material names

## Set and section mismatches

Typical failure class:

- section references a missing element set
- boundary references a missing node set
- material name is inconsistent

Fix naming coherence before altering step parameters.

## Step and load incompatibilities

If the solve fails or behaves nonsensically:

1. inspect the chosen step family
2. inspect whether the loads and BCs make sense for that step
3. inspect whether supports make the model singular

## Result interpretation failures

If output exists but looks wrong:

1. verify the requested output class
2. verify the correct set or region was targeted
3. verify the step type can produce the desired result
