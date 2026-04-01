# Spack Compilers And External Packages

## Compilers

Register compilers before solving large environments.

Good habits:

- detect or define the compilers the site actually supports
- keep compiler entries stable across related project environments
- prefer one compiler family per environment unless there is a clear reason not to

Treat compiler registration as part of the stack contract, not a one-off local convenience.

## External packages

Use externals when the site already owns software that should not be rebuilt casually, such as:

- MPI stacks
- CUDA toolkits
- vendor math libraries
- centrally managed HDF5 or NetCDF builds

Record external packages in `packages.yaml` or the appropriate Spack configuration scope instead of hiding them behind shell variables alone.

## Ownership rules

| Situation | First direction |
| --- | --- |
| site publishes validated MPI modules | model MPI as externals first |
| site forbids user rebuild of CUDA or vendor compilers | use externals |
| project needs isolated experimental dependencies | let Spack build them inside the environment |
| cluster stack mixes user-built and site-built software | make the boundary explicit in configuration files |

Ambiguous ownership is a common source of concretization drift.
