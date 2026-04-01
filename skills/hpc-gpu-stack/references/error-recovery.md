# GPU Error Recovery

## Build failures

If the build fails:

1. reduce to one CUDA source file and a minimal compile command
2. confirm the CUDA toolkit and host compiler pair is supported by the site stack
3. confirm MPI wrappers are not silently changing the host-compiler story

## Launch failures

If the job launches but the application cannot use GPUs:

- inspect scheduler GPU requests
- inspect visible devices inside the batch step
- inspect rank-local device selection logic

## Runtime failures

If kernels launch but fail:

1. reduce to one GPU and one rank
2. capture the exact runtime error
3. inspect memory capacity, bounds, and synchronization assumptions
4. restore multi-rank or multi-node complexity only after the baseline is correct
