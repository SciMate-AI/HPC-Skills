# ParaView pvpython pvbatch And Traces

## Purpose

Use this reference when deciding between GUI trace generation, `pvpython`, and `pvbatch`.

## Tool selection

| Mode | Best fit |
| --- | --- |
| GUI trace | prototype a workflow from interactive actions |
| `pvpython` | interactive scripting or serial scripted execution |
| `pvbatch` | non-interactive batch processing, including MPI-capable builds |

## Practical rules

- start from GUI trace when the pipeline is easier to discover interactively
- use `pvpython` when you want an interactive Python-driven client
- use `pvbatch` for non-interactive scripted execution and cluster-side batch processing

## Critical distinction

`pvbatch` acts as its own server for the script it runs. Do not try to build a `pvbatch` script that also connects to another server with `Connect()`.

## Scripting baseline

Common baseline:

```python
from paraview.simple import *
```

Keep object handles explicit. Do not rely only on whatever happens to be active.

## Failure patterns

| Symptom | Likely cause | First repair |
| --- | --- | --- |
| traced script is noisy or brittle | too much GUI state captured | simplify the trace into a cleaner script |
| `pvbatch` script fails with remote-connect logic | wrong execution model | use `pvserver` with `pvpython` or remove the connect path |
| script works in GUI but not in batch | hidden interactive state | make readers, views, and outputs explicit |
