# GPU Build And Launch Workflow

## Build sequence

Portable build sequence:

1. choose the CUDA toolkit and supported host compiler
2. confirm the intended MPI integration model if the code is distributed
3. compile a minimal GPU smoke path
4. only then compile the full application

## Launch sequence

Portable launch sequence:

1. validate single-GPU execution
2. validate one-node multi-GPU execution
3. validate one-rank-per-GPU scheduler launch
4. only then scale to multi-node runs

## Reproducibility

Capture:

- CUDA toolkit version
- host compiler version
- MPI stack if any
- build command or CMake configure command
- launcher command and scheduler resource request

Without that record, GPU failures are hard to reproduce because many issues come from stack drift rather than source changes.
