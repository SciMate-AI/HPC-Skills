# ParaView State Files Animation And Extracts

## Purpose

Use this reference when the workflow depends on state files, screenshots, animations, or extracted data products.

## State files

Common state forms:

- `.pvsm` state files
- Python state files

Practical rules:

- use `.pvsm` when robust state persistence matters
- use Python state or trace when manual editing is part of the workflow
- avoid committing brittle absolute data paths into shared state unless intentional

## Screenshot and animation logic

Before generating image products:

- pick the exact view or layout
- set target resolution intentionally
- confirm time step and coloring are the intended ones

## Save data and extracts

Use saved-data exports when the downstream task needs reduced datasets, tables, or geometry.

Do not treat screenshots as substitutes for extracted data when quantitative downstream analysis is needed.

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| loading state cannot find files | saved paths are stale or machine-specific | remap data paths or rebuild a portable state |
| exported image is inconsistent | view, layout, or timestep was implicit | make the saved target explicit |
| output data is missing fields | wrong pipeline object was exported | export from the intended source or filter |
