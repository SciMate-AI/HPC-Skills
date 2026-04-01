# Configure And Build Matrix

## Build-system choice

| Situation | First choice |
| --- | --- |
| modern C or C++ package with dependency discovery | CMake |
| older project with stable handwritten rules | Make or Autotools workflow already used by the project |
| very large build where backend speed matters | CMake plus Ninja if the site supports it |
| wrapper-driven one-file smoke test | compiler wrapper directly |

## Selection rules

Prefer the build system the project already uses. Do not translate a healthy upstream build from Autotools to CMake just to match local preference.

Use wrapper compilers directly when:

- validating that MPI headers and libraries are visible
- running a one-file smoke test
- reducing the problem before restoring the full build system

Use CMake when:

- dependencies must be discovered reproducibly
- cache state and build directories need to be separated by toolchain
- the project exports imported targets or package config files

## Build-directory hygiene

Keep one build directory per:

- compiler family
- MPI family
- build type
- major dependency stack

Example naming direction:

- `build-gcc-openmpi-release`
- `build-gcc-openmpi-debug`
- `build-oneapi-intelmpi-release`
