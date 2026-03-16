---
name: hpc-paraview
description: Build, review, debug, and automate ParaView post-processing and visualization workflows. Use when working with ParaView readers, filters, color maps, screenshots, state files, pvpython or pvbatch scripts, remote pvserver sessions, or cluster-side batch visualization.
---

# HPC ParaView

Treat ParaView as a pipeline-driven post-processing and visualization stack with both GUI and scripted execution paths.

## Start

1. Read `references/workflow-manual.md` before creating or repairing a ParaView workflow.
2. Read `references/readers-filters-and-pipeline.md` when mapping datasets to readers, filters, and pipeline objects.
3. Read `references/color-maps-layout-and-views.md` when tuning representations, coloring, views, screenshots, or layout behavior.
4. Read `references/pvpython-pvbatch-and-traces.md` when choosing between GUI tracing, `pvpython`, and `pvbatch`.
5. Read `references/state-files-animation-and-extracts.md` when using `.pvsm`, Python state, screenshots, or saved data products.
6. Read `references/remote-and-parallel-visualization.md` when the workflow needs `pvserver`, reverse connections, SSH tunnels, or distributed rendering.
7. Read `references/cluster-execution-playbook.md` when staging a ParaView workflow for scheduler-backed cluster post-processing.
8. Read `references/error-recovery.md` when readers, filters, scripts, state files, or remote connections fail.

## Reusable Templates

Use `assets/templates/` when a concrete starting scaffold is needed, especially:

- `pvpython_screenshot.py`
- `pvbatch_slice_extract.py`
- `paraview-pvbatch-slurm.sh`
- `paraview-pvserver-slurm.sh`

## Guardrails

- Do not guess reader or filter semantics from file extensions alone when metadata is available.
- Do not use `pvbatch` and remote `Connect()` logic in the same script.
- Do not save brittle state files with absolute data paths unless that is intentional.
- Do not run heavy rendering or batch extraction on login nodes.

## Outputs

Summarize:

- input datasets and readers
- key filters and representations
- chosen execution path such as GUI, `pvpython`, `pvbatch`, or `pvserver`
- expected screenshots, extracts, animations, or saved data products
