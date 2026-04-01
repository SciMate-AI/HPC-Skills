# Gmsh Transfinite And Recombine Playbook

## Transfinite meshing

Use transfinite settings when the topology supports a mapped or structured discretization.

Good fit:

- rectangles, blocks, and sweep-like topologies
- cases where node counts along edges should be explicit
- meshes that should align with solver expectations for structured spacing

## Recombine

Use recombination when:

- quads in 2D or hex-dominant volume workflows are preferred
- the underlying topology is suitable for recombined elements

Recombine is not a universal cleanup button. It depends on geometry quality and meshing path.

## Guardrails

- do not assign transfinite constraints to arbitrary unstructured topology
- do not expect recombine to rescue poor geometry
- if the mapped structure is central to the workflow, design the geometry around that constraint from the start

## Practical sequence

1. validate geometry
2. set transfinite counts where appropriate
3. apply recombine only on compatible entities
4. inspect element type and quality after meshing
