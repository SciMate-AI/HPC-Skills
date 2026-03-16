# Gaussian Error Pattern Dictionary

## Pattern ID: `GAUSSIAN_PARSE_INPUT_FAILURE`
- **Likely symptom**: the job exits before meaningful computation starts
- **Root cause**: malformed input structure, keyword, or block ordering
- **First checks**:
  - inspect Link 0 and route formatting
  - inspect charge, multiplicity, and geometry block
- **Primary fix**: restore a valid input deck structure before tuning chemistry

## Pattern ID: `GAUSSIAN_SCRATCH_PATH_FAILURE`
- **Likely symptom**: the batch job dies with file or scratch errors
- **Root cause**: `GAUSS_SCRDIR` or scratch placement is invalid
- **First checks**:
  - inspect writable scratch path
  - inspect quota and free space
- **Primary fix**: move scratch to a valid high-space directory

## Pattern ID: `GAUSSIAN_SCF_NONCONVERGENCE`
- **Likely symptom**: SCF iterations stall or exhaust limits
- **Root cause**: electronic-state, geometry, or SCF setup is unstable
- **First checks**:
  - inspect charge and multiplicity
  - inspect structure reasonableness
- **Primary fix**: validate the physical setup before escalating SCF recovery tactics

## Pattern ID: `GAUSSIAN_RESTART_DRIFT`
- **Likely symptom**: restarted behavior differs unexpectedly from the intended job
- **Root cause**: stale checkpoint or incorrect `%OldChk` handoff
- **First checks**:
  - inspect actual checkpoint source
  - inspect route changes between stages
- **Primary fix**: re-establish one authoritative checkpoint path and stage policy
