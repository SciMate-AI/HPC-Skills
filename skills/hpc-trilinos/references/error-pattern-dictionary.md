# Trilinos Error Pattern Dictionary

## Pattern ID: `TRILINOS_MAP_INCONSISTENT`

- Likely symptom: solver fails before meaningful iteration or vectors cannot be combined safely
- Root cause: row, domain, or range maps do not align
- Primary fix: validate map construction before touching solver parameters

## Pattern ID: `TRILINOS_PACKAGE_NOT_ENABLED`

- Likely symptom: missing headers, symbols, or factory paths for a package the code expects
- Root cause: the required package was not enabled in the Trilinos build
- Primary fix: inspect CMake enables and rebuild the minimal coherent package set

## Pattern ID: `TRILINOS_TYPE_INSTANTIATION_MISMATCH`

- Likely symptom: link failure for a specific scalar or ordinal combination
- Root cause: the build and the application disagree on template instantiations
- Primary fix: align scalar and ordinal choices and confirm the build instantiates them

## Pattern ID: `TRILINOS_PARAMETER_PATH_WRONG`

- Likely symptom: changing a parameter list has no effect
- Root cause: parameters are being set on the wrong package or sublist path
- Primary fix: trace the active `Teuchos::ParameterList` routing into the solver stack
