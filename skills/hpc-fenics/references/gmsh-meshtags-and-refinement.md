# DOLFINx Gmsh, MeshTags, And Refinement Manual

## Contents

- Gmsh import workflow
- Physical groups and tags
- MeshTags usage
- Refinement and tag transfer
- Parallel caveats

## Gmsh import workflow

The official DOLFINx Gmsh demo uses the Gmsh Python API plus `dolfinx.io.gmsh`.

Practical workflow:

1. build geometry in Gmsh
2. synchronize the CAD model
3. add physical groups after synchronization
4. generate the mesh
5. convert it into a DOLFINx mesh and associated tags

If physical groups are missing or added at the wrong stage, downstream markers are unreliable.

## Physical groups and tags

Use physical groups to encode semantic meaning:

- cells for material regions
- facets for boundaries
- optionally lower-dimensional entities when the workflow needs them

Treat those tags as the canonical source for:

- boundary conditions
- source terms by region
- subdomain-specific material coefficients

Do not rediscover region meaning later from coordinates if the mesh already contains physical groups.

## MeshTags usage

The DOLFINx mesh API exposes:

- `meshtags`
- `meshtags_from_entities`
- `find(value)`

Important documented rules:

- tagged entity arrays must be sorted
- tagged entity arrays must not contain duplicates
- tag dimension must match the target entity dimension

Use `MeshTags` when you need stable, queryable markers instead of one-off geometric predicates.

## Refinement and tag transfer

The DOLFINx mesh API supports:

- `refine`
- `uniform_refine`
- `transfer_meshtag`

Important documented point:

- tag transfer is supported for cells and facets when parent-cell information is available

Use transfer rather than rebuilding all tags from scratch when refinement is part of the workflow.

## Parallel caveats

Refinement and boundary discovery have ownership implications.

The official docs note that boundary-entity detection and refined-mesh ghosting need care in parallel.

Inference for the skill:

- after refinement, re-check assumptions about tag ownership and boundary discovery
- if marker logic becomes inconsistent after refinement, inspect tag transfer before blaming the variational form
