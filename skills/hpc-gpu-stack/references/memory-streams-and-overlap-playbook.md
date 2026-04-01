# Memory, Streams, And Overlap Playbook

## Memory model

Get memory correctness and capacity under control before tuning overlap.

Useful distinctions:

- pageable host memory
- pinned host memory
- device memory
- unified or managed memory when the application deliberately uses it

Pinned memory can help transfer performance, but it is not a casual default if host memory pressure is already high.

## Streams

Use non-default streams only when the dependency structure is clear.

Practical rules:

- one correct default-stream baseline is better than many speculative streams
- overlapping transfers and compute only helps when the data dependencies truly permit it
- if kernel order matters, make synchronization points explicit while debugging

## Overlap assumptions

Do not assume that adding streams automatically creates overlap.

Confirm first:

- transfers are asynchronous where intended
- buffers and kernels use compatible streams
- the scheduler and MPI side are not already the dominant bottleneck
