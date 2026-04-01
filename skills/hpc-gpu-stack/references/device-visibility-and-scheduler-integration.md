# Device Visibility And Scheduler Integration

## Scheduler-owned visibility

On managed clusters, let the scheduler define the GPU allocation first.

Typical expectations:

- Slurm exposes the allocated device set and should stay the source of truth
- `CUDA_VISIBLE_DEVICES` is often rewritten per task or step
- manual overrides can hide the scheduler's placement decisions

## Practical rules

- verify the visible device list inside the batch step, not only in the login shell
- if one rank must own one GPU, request GPU resources in the scheduler and map ranks accordingly
- if MIG or partitioned devices are in play, inspect the actual visible logical devices before assuming full GPUs

## Failure signatures

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| all ranks select the same GPU | local-rank logic is missing or ignored | derive device choice from scheduler-visible devices and rank-local context |
| no GPU visible inside the job | scheduler request is wrong or environment propagation is broken | inspect the batch step environment and GPU request flags |
| interactive test works but batch fails | device visibility differs between shell and scheduler step | debug inside the actual scheduler-launched step |
