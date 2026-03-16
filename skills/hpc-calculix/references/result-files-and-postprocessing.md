# CalculiX Result Files And Post-Processing

## Contents

- core output files
- frequency artifacts
- post-processing with cgx

## Core output files

The official input-deck format docs state that a CalculiX run typically produces:

- `jobname.dat`
- `jobname.frd`

Treat:

- `.dat` as text summary output
- `.frd` as the main field-result file for post-processing

## Frequency artifacts

The official docs note:

- frequency-type workflows with storage can produce `jobname.eig`
- later modal dynamic or steady-state dynamics workflows may require that binary artifact

If a downstream modal workflow fails, check whether the expected `.eig` file exists.

## Post-processing with cgx

The official docs reference `cgx` as the natural viewer for `.frd`.

If the user asks for visual inspection:

1. ensure the right output class was requested
2. ensure `.frd` exists
3. inspect in cgx or an equivalent compatible viewer
