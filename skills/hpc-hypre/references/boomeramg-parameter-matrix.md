# hypre BoomerAMG Parameter Matrix

## Contents

- First knobs to touch
- When to change them
- What not to change first

## First knobs to touch

| Goal | Tuning direction |
| --- | --- |
| get a stable first baseline | stay close to default `BoomerAMG` settings |
| setup cost is too high | review coarsening or interpolation choices one at a time |
| solve is stagnating on an elliptic problem | inspect smoother choice and cycle behavior after matrix correctness is confirmed |
| memory is too high | reduce aggressive tuning and inspect hierarchy growth before deeper changes |

## When to change them

Change AMG internals only after:

1. interface selection is correct
2. row ownership and matrix assembly are correct
3. the Krylov outer solver matches the operator class

## What not to change first

Avoid this sequence:

- changing coarsening, interpolation, smoothing, and cycle settings all at once
- compensating for a malformed matrix by ever-more-aggressive AMG tuning
- blaming AMG for nullspace or boundary-condition mistakes
