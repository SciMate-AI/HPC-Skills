---
name: hpc-spack
description: Build, review, debug, and stabilize Spack-based HPC software stacks. Use when working with Spack specs, variants, compilers, externals, environments, concretization, compiler or MPI matrices, site stacks, binary reuse, or Spack install and reuse failures.
---

# HPC Spack

Treat Spack as a stack manager, not just an install command. Decide the compiler, MPI, externals, concretization policy, and environment boundary before changing package-level variants.

## Start

1. Read `references/spec-and-variant-matrix.md` before writing or repairing a Spack spec.
2. Read `references/compilers-and-external-packages.md` when compiler registration, `packages.yaml`, or external software ownership is in scope.
3. Read `references/environments-and-concretization.md` when using `spack.yaml`, lockfiles, unified concretization, or multi-package environments.
4. Read `references/compiler-and-mpi-matrix.md` when the stack depends on compiler or MPI families and their combinations.
5. Read `references/modules-buildcaches-and-binary-reuse.md` when integrating site modules, buildcaches, mirrors, or binary reuse.
6. Read `references/site-stack-and-reproducibility.md` when the goal is a durable site stack, reproducible environment, or cluster handoff.
7. Read `references/error-recovery.md` when concretization, install, compiler detection, external-package, or reuse behavior fails.

## Work sequence

1. Decide the stack boundary first:
   - site-provided externals
   - project-local Spack environment
   - site-maintained Spack stack
2. Register compilers and externals before solving the dependency graph.
3. Write the minimal spec or environment that captures the intended compiler and MPI choices.
4. Concretize and inspect the solved graph before launching a long install.
5. Capture environment manifests, overrides, and reuse settings with the build record.

## Guardrails

- Do not mix ad hoc package installs and environment-managed installs casually.
- Do not force many variants at once before the compiler and external package model is coherent.
- Do not treat concretization policy as an afterthought when several packages must coexist.
- Do not hide site-provided MPI, CUDA, or math libraries from Spack if the cluster expects them to be reused as externals.

## Additional References

Load these on demand:

- `references/spec-and-variant-matrix.md` for spec syntax and variant selection patterns
- `references/compilers-and-external-packages.md` for compiler registration and external package ownership
- `references/environments-and-concretization.md` for `spack.yaml`, lockfiles, and concretization behavior
- `references/compiler-and-mpi-matrix.md` for compiler/MPI cross-product planning
- `references/modules-buildcaches-and-binary-reuse.md` for binary reuse and module integration
- `references/site-stack-and-reproducibility.md` for site-stack hygiene and durable reproducibility
- `references/error-pattern-dictionary.md` for fast matching of common Spack failure classes

## Reusable Templates

Use `assets/templates/` when a concrete starting point is faster than rebuilding the Spack workflow from scratch, especially:

- `spack-env-minimal.yaml`
- `packages-external-example.yaml`
- `compilers-example.yaml`
- `spack-create-env-and-install.sh`
- `spack-build-smoke-slurm.sh`

## Outputs

Summarize:

- chosen environment boundary
- compiler and MPI strategy
- external package assumptions
- concretization or binary-reuse choices
- the exact Spack failure class if the workflow is being repaired
