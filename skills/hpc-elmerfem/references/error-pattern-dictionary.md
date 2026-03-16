# ElmerFEM Error Pattern Dictionary

## Contents

- Parse and syntax patterns
- ID-mapping patterns
- Solver-family patterns
- Output and interpretation patterns

## Parse and syntax patterns

### Pattern ID: `ELMER_SIF_KEY_OR_BLOCK_FAILURE`
- **Likely symptom**: ElmerSolver rejects the `.sif` before the solve begins
- **Root cause**: block name, key spelling, or value syntax is invalid
- **First checks**:
  - inspect block names
  - inspect key spelling
  - inspect numeric versus string syntax
- **Primary fix**: normalize syntax and block structure before changing solver settings

### Pattern ID: `ELMER_MESH_HEADER_PATH_FAILURE`
- **Likely symptom**: run cannot find or load the mesh database
- **Root cause**: `Header` mesh path is wrong or mesh conversion is incomplete
- **First checks**:
  - inspect `Mesh DB`
  - inspect converted mesh directory
- **Primary fix**: repair the mesh path or reconvert the mesh

## ID-mapping patterns

### Pattern ID: `ELMER_BODY_MATERIAL_EQUATION_MISMATCH`
- **Likely symptom**: run proceeds with missing or wrong physical assignment
- **Root cause**: `Body` links to the wrong `Material` or `Equation`
- **First checks**:
  - inspect `Body` references
  - inspect existence of the referenced IDs or names
- **Primary fix**: rebuild the body-to-material-to-equation mapping explicitly

### Pattern ID: `ELMER_BOUNDARY_ID_WRONG`
- **Likely symptom**: boundary condition appears ignored or applied to the wrong place
- **Root cause**: converted boundary IDs do not match the `.sif`
- **First checks**:
  - inspect converted mesh boundary numbering
  - inspect target `Boundary Condition` IDs
- **Primary fix**: remap BC IDs from the actual converted mesh

## Solver-family patterns

### Pattern ID: `ELMER_PHYSICS_SOLVER_MISMATCH`
- **Likely symptom**: run starts but solves the wrong field or yields meaningless results
- **Root cause**: chosen `Procedure` or solver family does not match the intended physics
- **First checks**:
  - inspect solver `Procedure`
  - inspect variable name and DOFs
  - inspect intended physics family
- **Primary fix**: replace the solver block with one coherent with the physics

### Pattern ID: `ELMER_LINEAR_SYSTEM_MISCONFIGURED`
- **Likely symptom**: poor convergence or non-robust algebraic behavior on an otherwise sensible case
- **Root cause**: direct versus iterative family or tolerances are poorly chosen
- **First checks**:
  - inspect `Linear System Solver`
  - inspect iterative or direct method choice
  - inspect convergence tolerance
- **Primary fix**: move to a simpler robust solver family first, then retune

## Output and interpretation patterns

### Pattern ID: `ELMER_TRANSIENT_CONTROL_MISSING`
- **Likely symptom**: transient problem behaves like a steady solve or outputs too little or too much
- **Root cause**: `Simulation` block does not contain coherent timestep controls
- **First checks**:
  - inspect `Simulation Type`
  - inspect `Timestep Sizes`, `Timestep Intervals`, `Output Intervals`
- **Primary fix**: move all time policy into a coherent `Simulation` block

### Pattern ID: `ELMER_RESULT_EXPECTATION_WRONG`
- **Likely symptom**: output exists but not the field or cadence the user expected
- **Root cause**: active solver family, body assignment, or output interval policy does not match the requested result
- **First checks**:
  - inspect active physics
  - inspect output cadence
  - inspect targeted bodies or boundaries
- **Primary fix**: align solve intent and output policy before changing mesh or material data
