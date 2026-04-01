# Gmsh CLI And Python API Playbook

## `.geo` versus Python API

Use `.geo` when:

- the geometry is compact
- a text-first declarative script is enough
- CLI-driven batch meshing is the main workflow

Use the Python API when:

- geometry generation depends on loops, parameters, or external data
- the workflow needs programmable inspection or export logic
- the model should be generated as part of a larger preprocessing pipeline

## CLI usage

The CLI is a strong default for deterministic batch meshing:

- select dimension explicitly
- select output path explicitly
- keep output format and version intentional

## API usage

For the Python API:

- initialize and finalize Gmsh cleanly
- synchronize geometry after construction when needed
- generate only the target dimension
- write the mesh after physical groups are in place

## Selection rule

Start with `.geo` for small stable cases and move to the API only when the model generation logic truly needs programmability.
