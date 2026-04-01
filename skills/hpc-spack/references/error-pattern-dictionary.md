# Spack Error Pattern Dictionary

## Pattern ID: `SPACK_CONCRETIZATION_PROVIDER_CONFLICT`

- Likely symptom: concretization fails with incompatible providers or unsatisfied variants
- Root cause: provider policy, externals, or variants disagree across roots
- Primary fix: simplify root specs, inspect provider choices, and separate environments if needed

## Pattern ID: `SPACK_COMPILER_NOT_REGISTERED`

- Likely symptom: Spack cannot find or use the intended compiler family
- Root cause: compiler entry is missing, stale, or inconsistent with the host environment
- Primary fix: refresh compiler definitions and verify the compiler is actually visible to the environment

## Pattern ID: `SPACK_EXTERNAL_PACKAGE_MODEL_WRONG`

- Likely symptom: Spack tries to rebuild software that should be site-owned, or links against an unexpected source build
- Root cause: external package boundary is not modeled explicitly
- Primary fix: encode site-owned packages in configuration instead of relying on shell state

## Pattern ID: `SPACK_REUSE_OR_BUILD_CACHE_MISMATCH`

- Likely symptom: reused binaries install but behave inconsistently at runtime, or reuse is skipped unexpectedly
- Root cause: architecture, compiler, or external-package assumptions do not match
- Primary fix: compare the binary provenance against the current environment policy before rebuilding or forcing reuse
