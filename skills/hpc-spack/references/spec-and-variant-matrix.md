# Spack Spec And Variant Matrix

## Contents

- Spec-building blocks
- Variant discipline
- Dependency and compiler pinning

## Spec-building blocks

Use specs to express the intended build graph precisely enough that concretization has a stable target.

Core pieces:

- root package name
- version constraints when they matter
- variants such as `+mpi` or `~cuda`
- compiler selection through `%compiler`
- dependency overrides through `^dependency`

Practical rule: begin with the smallest spec that captures the real policy. Add extra overrides only when the solved graph is wrong or site policy requires them.

## Variant discipline

| Situation | First direction |
| --- | --- |
| package should use site MPI | enable the package MPI variant and pin the intended MPI provider |
| package should stay CPU-only | disable accelerator variants explicitly when ambiguity is risky |
| package needs debug symbols or sanity checking | use a debug-capable variant or a dedicated debug environment instead of mutating production builds |
| package has many optional features | start from the minimum viable feature set, then add one feature family at a time |

## Dependency and compiler pinning

Pin dependencies only when:

- the site requires a specific provider
- ABI or runtime compatibility matters
- concretization keeps choosing an unwanted provider

Over-pinning every dependency makes the environment harder to evolve and debug.
