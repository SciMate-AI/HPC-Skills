# Spack Site Stack And Reproducibility

## Site stack mindset

For site or lab stacks, optimize for repeatability over short-term install speed.

Capture:

- `spack.yaml`
- lockfile when used
- compiler definitions
- external package definitions
- mirror or buildcache policy
- module generation policy

## Reproducibility boundary

Choose the smallest boundary that still captures the stack:

- single environment for one project
- family of environments sharing a site configuration
- published buildcache and modules for broader reuse

The broader the boundary, the more important it is to separate experimental and production stacks.

## Change management

When evolving a stable stack:

1. branch or clone the environment
2. change one policy family at a time
3. reconcretize and inspect
4. publish only after the new stack is validated

Do not mutate a production environment in place when users depend on it.
