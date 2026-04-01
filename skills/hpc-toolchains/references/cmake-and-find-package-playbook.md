# CMake And Find Package Playbook

## Contents

- Imported-target discipline
- Discovery order
- Cache variables
- Repair sequence

## Imported-target discipline

Prefer imported targets over raw include and library variables whenever the package exports them.

Why:

- transitive include paths propagate correctly
- compile definitions propagate correctly
- link order is less fragile

Raw `${FOO_LIBRARIES}` and `${FOO_INCLUDE_DIRS}` are a fallback, not the first choice.

## Discovery order

High-confidence order:

1. package config files or imported targets from the intended install
2. site-validated module stack that sets discovery variables cleanly
3. toolchain file or preset that points CMake at the intended stack
4. manual cache-variable overrides only when necessary

## Cache variables

If a build depends on a non-default stack, capture it through:

- `CMAKE_PREFIX_PATH`
- package-specific `_DIR` variables
- `CMAKE_TOOLCHAIN_FILE`
- CMake presets when the project already uses them

Do not scatter absolute include and library paths across many custom variables unless the project gives no better hook.

## Repair sequence

When `find_package` fails or finds the wrong install:

1. inspect the active module or environment stack
2. inspect `CMAKE_PREFIX_PATH` and package `_DIR` variables
3. verify the intended package actually exports CMake metadata
4. clear or isolate the build cache before changing more variables
