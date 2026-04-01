# GPU Error Pattern Dictionary

## Pattern ID: `GPU_UNSUPPORTED_HOST_COMPILER`

- Likely symptom: `nvcc` rejects the host compiler or fails during host-side compilation
- Root cause: the active CUDA toolkit and host compiler are not a validated pair
- Primary fix: reduce to a supported CUDA-plus-host-compiler combination first

## Pattern ID: `GPU_ALL_RANKS_SAME_DEVICE`

- Likely symptom: every MPI rank reports the same GPU
- Root cause: device selection ignores local-rank context or scheduler-visible device mapping
- Primary fix: derive device choice from rank-local mapping within the scheduler-exposed device set

## Pattern ID: `GPU_NO_DEVICE_VISIBLE_IN_BATCH`

- Likely symptom: interactive tests see GPUs but the batch job does not
- Root cause: scheduler resource request or batch-step environment propagation is wrong
- Primary fix: inspect GPU request flags and the in-job visible-device environment

## Pattern ID: `GPU_MEMORY_CAPACITY_OR_ILLEGAL_ACCESS`

- Likely symptom: allocation failure, illegal memory access, or crash under load
- Root cause: memory-capacity issue, indexing bug, or missing synchronization assumption
- Primary fix: reduce to a minimal one-GPU reproduction and validate capacity and access patterns
