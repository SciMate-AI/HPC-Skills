# Toolchain Files And Presets

## When To Use Them

Use a CMake toolchain file or preset when:

- the site requires a repeated compiler and MPI configuration
- cross-node or cluster-specific dependency paths must be applied consistently
- many projects must share one validated build recipe

## Toolchain-file responsibilities

A toolchain file is a good place for:

- compiler commands
- sysroot or prefix roots
- MPI wrapper selection
- site-wide dependency roots

A toolchain file is not the best place for application-specific warning lists or ad hoc feature toggles.

## Preset responsibilities

Use presets when the project already supports them and the goal is:

- reproducible build-directory naming
- repeatable configure arguments
- easy switching between debug and release or between MPI stacks

## Guardrails

- keep the toolchain file generic enough to reuse across related projects
- keep application-specific package options in the project or preset layer
- do not hide a broken dependency stack behind a complicated toolchain file
