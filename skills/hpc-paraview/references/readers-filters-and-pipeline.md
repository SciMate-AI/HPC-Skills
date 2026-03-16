# ParaView Readers Filters And Pipeline

## Purpose

Use this reference when selecting readers, applying filters, or repairing pipeline structure.

## Core pipeline chain

Typical chain:

1. reader
2. optional data selection or cleanup
3. one or more analysis or transformation filters
4. representation setup
5. export or render step

## Reader discipline

Rules:

- use a reader compatible with the real dataset type, not only the filename
- inspect available arrays and time steps before building a heavy pipeline
- keep one clear source object per dataset branch

## Filter discipline

Common filter families:

- clipping and slicing
- thresholding and contouring
- resampling and probing
- plotting or data extraction

Do not stack filters blindly. Each filter changes the data model and the next filter’s valid options.

## Pipeline checks

Before exporting or rendering:

- confirm the active arrays are the intended ones
- confirm the view is showing the intended object
- confirm the filter output type supports the downstream writer or representation

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| data opens but looks wrong | wrong reader or wrong active arrays | inspect the reader output and array selection |
| a filter is unavailable or fails | upstream data type is incompatible | verify the pipeline object type before adding the filter |
| export format is missing | current data model is incompatible with the writer | adjust the pipeline to the target output type |
