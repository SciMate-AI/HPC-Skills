# hypre Error Pattern Dictionary

## Pattern ID: `HYPRE_IJ_OWNERSHIP_MISMATCH`

- Likely symptom: setup fails or MPI behavior differs sharply from serial
- Root cause: row ownership or indexing inconsistency
- Primary fix: validate row ranges and matrix assembly on all ranks

## Pattern ID: `HYPRE_WRONG_INTERFACE_FAMILY`

- Likely symptom: code becomes awkward and brittle before the solve is even tuned
- Root cause: `Struct` or `SStruct` was chosen for a fundamentally unstructured matrix, or vice versa
- Primary fix: realign the hypre interface with the actual data model

## Pattern ID: `HYPRE_BOOMERAMG_OVERTUNED`

- Likely symptom: setup cost or memory blows up after parameter changes
- Root cause: too many AMG knobs changed before a baseline was validated
- Primary fix: back out to a baseline `BoomerAMG` configuration and retune one lever at a time

## Pattern ID: `HYPRE_INTEGRATION_BOUNDARY_CONFUSION`

- Likely symptom: expected hypre options are unavailable from the host code
- Root cause: the active integration layer does not expose the full native hypre interface
- Primary fix: confirm whether the workflow is direct hypre, PETSc-mediated, or another wrapped path
