# CalculiX Error Pattern Dictionary

## Contents

- Parse and keyword patterns
- Set and section linkage patterns
- Step and singularity patterns
- Output and post-processing patterns

## Parse and keyword patterns

### Pattern ID: `CCX_KEYWORD_OR_ORDER_FAILURE`
- **Likely symptom**: parser rejects the deck or stops very early
- **Root cause**: keyword spelling, parameter syntax, or deck ordering is invalid
- **First checks**:
  - inspect keyword spelling
  - inspect commas and parameters on keyword lines
  - inspect whether referenced names are defined earlier
- **Primary fix**: normalize the deck structure before touching physics

### Pattern ID: `CCX_UNSUPPORTED_OR_MISUSED_KEYWORD`
- **Likely symptom**: deck resembles Abaqus syntax but CalculiX behavior is missing or incorrect
- **Root cause**: keyword or parameter variant is not supported as assumed
- **First checks**:
  - inspect the exact keyword variant
  - inspect whether the intended feature exists in CalculiX
- **Primary fix**: replace with a CalculiX-supported keyword pattern instead of forcing Abaqus parity

## Set and section linkage patterns

### Pattern ID: `CCX_SET_NAME_MISMATCH`
- **Likely symptom**: materials, sections, loads, or supports appear to target nothing
- **Root cause**: `*NSET` or `*ELSET` names are inconsistent across the deck
- **First checks**:
  - inspect every consumer keyword against declared set names
  - inspect node set versus element set usage
- **Primary fix**: rebuild the deck around a coherent set naming scheme

### Pattern ID: `CCX_SECTION_ELEMENT_FAMILY_MISMATCH`
- **Likely symptom**: element formulation behaves incorrectly or section assignment fails logically
- **Root cause**: section keyword does not match the element family
- **First checks**:
  - inspect element type
  - inspect section keyword
- **Primary fix**: align section keyword with element family before reviewing loads

## Step and singularity patterns

### Pattern ID: `CCX_STEP_LOAD_MISMATCH`
- **Likely symptom**: solve runs with nonsensical behavior or target result is not produced
- **Root cause**: procedure family does not match the applied loads or requested outputs
- **First checks**:
  - inspect active step keyword
  - inspect load type
  - inspect output request intent
- **Primary fix**: correct the procedure family first

### Pattern ID: `CCX_STRUCTURAL_SINGULARITY`
- **Likely symptom**: singular solve, rigid-body motion, or meaningless displacements
- **Root cause**: supports are incomplete or contradictory
- **First checks**:
  - inspect support sets
  - inspect whether rigid modes are constrained
  - inspect disconnected regions
- **Primary fix**: repair support and connectivity logic before altering material or solver assumptions

## Output and post-processing patterns

### Pattern ID: `CCX_EXPECTED_RESULT_FILE_MISSING`
- **Likely symptom**: user expects modal or field output that is not present
- **Root cause**: wrong procedure, wrong output request, or wrong downstream expectation
- **First checks**:
  - inspect whether `.frd`, `.dat`, or `.eig` should exist for the chosen workflow
  - inspect output request blocks
- **Primary fix**: align output expectations with the active step family

### Pattern ID: `CCX_POSTPROCESSING_TARGET_WRONG`
- **Likely symptom**: results exist but the wrong region or quantity is being interpreted
- **Root cause**: output requests or targeted sets do not match the analysis question
- **First checks**:
  - inspect requested quantities
  - inspect targeted region or set
- **Primary fix**: redefine output requests to match the active physical question
