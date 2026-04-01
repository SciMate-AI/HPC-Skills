# Gmsh Error Pattern Dictionary

## Pattern ID: `GMSH_WRONG_KERNEL_FOR_OPERATION`

- Likely symptom: booleans or CAD-like operations behave inconsistently or are unavailable
- Root cause: GEO-style workflow was used where OpenCASCADE was the right kernel
- Primary fix: move the geometry path to OpenCASCADE and rebuild topology cleanly

## Pattern ID: `GMSH_PHYSICAL_GROUPS_MISSING_OR_WRONG`

- Likely symptom: downstream solver sees missing or misassigned boundaries or regions
- Root cause: physical groups were omitted, assigned on the wrong dimension, or defined too early
- Primary fix: rebuild physical groups after inspecting stable topology and verify export contents

## Pattern ID: `GMSH_TRANSFINITE_ON_INCOMPATIBLE_TOPOLOGY`

- Likely symptom: mapped meshing or recombine settings fail or produce invalid structure
- Root cause: structured constraints were forced onto topology that does not support them
- Primary fix: remove those constraints, recover a valid mesh, then redesign geometry if structure is required

## Pattern ID: `GMSH_SIZE_FIELDS_OVERCONSTRAINED`

- Likely symptom: element count explodes or meshing becomes unstable after refinement changes
- Root cause: too many competing local size controls or fields
- Primary fix: return to a simpler baseline and add one refinement rule at a time
