# Gaussian Error Recovery

## Purpose

Use this reference when Gaussian input parsing, SCF behavior, optimization, frequency, or restart logic is failing.

## Recovery sequence

1. classify whether the failure is structural, electronic, runtime, or restart-related
2. inspect the smallest authoritative artifact: input deck, scheduler script, checkpoint policy, or scratch placement
3. repair one layer at a time
4. rerun a small validation case before resubmitting a long production job

## Structural failures

Typical causes:

- malformed Link 0 or route section
- broken charge or multiplicity line
- geometry block mismatch

Repair:

- rebuild the input in canonical block order
- simplify the route to the minimum meaningful job

## Runtime failures

Typical causes:

- missing environment setup
- bad scratch path
- oversized or mismatched shared-memory request

Repair:

- make `g16root` and `GAUSS_SCRDIR` explicit in the batch script
- align `%NProcShared` with the scheduler allocation

## Electronic and optimization failures

Typical causes:

- wrong charge or multiplicity
- fragile starting geometry
- route too ambitious for first-pass validation

Repair:

- validate the physical setup first
- simplify to a smaller or less coupled stage if needed

## Restart failures

Typical causes:

- stale `%OldChk`
- checkpoint from the wrong stage
- incompatible stage change during restart

Repair:

- identify the authoritative checkpoint
- separate restart debugging from method-stack changes
