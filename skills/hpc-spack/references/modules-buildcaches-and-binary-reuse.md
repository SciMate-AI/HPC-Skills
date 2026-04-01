# Spack Modules Buildcaches And Binary Reuse

## Modules

Spack can live beside site modules instead of replacing them.

Use modules to:

- expose a finished site stack
- seed external package configuration
- capture user-facing load paths for installed software

Keep module generation aligned with the actual environment boundary.

## Buildcaches and binary reuse

Use buildcaches or mirrors when:

- many users need the same stack
- rebuild cost is high
- CI or site automation should publish prebuilt binaries

Binary reuse is strongest when compiler, target architecture, and external package model are already stable.

## Practical rules

- do not enable binary reuse blindly across incompatible architectures
- keep mirror and buildcache policy explicit in the environment or site configuration
- record whether a package came from source or binary reuse when diagnosing runtime behavior
