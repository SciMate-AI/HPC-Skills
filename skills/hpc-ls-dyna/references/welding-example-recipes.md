# Welding Example Recipes

## Source Focus

- `dynaexamples.com/thermal/welding-new`
- coupled solids, coupled shells, uncoupled binout, and uncoupled d3plot welding pages

## Use This Reference For

- choosing between coupled and uncoupled welding
- deciding between shell and solid thermal representation
- mapping welding examples to thermal-stage and structural-stage starters

## Starter Deck Mapping

Use these starter decks first:

- `assets/templates/thermal-coupled-starter.k` for coupled welding thermal and thermal-structural stages
- `assets/templates/implicit-static-outline.k` for the structural continuation stage after mapped temperatures
- `assets/templates/examples/thermal-coupled-minimal/` when the thermal stage should start as a multi-file project
- `assets/templates/examples/implicit-static-minimal/` for multi-file structural continuation after mapped temperatures

## Common Welding Reuse Pattern

Copy these families only after matching the process:

- `*BOUNDARY_THERMAL_WELD_TRAJECTORY`
- `*MAT_THERMAL_CWM`
- thermal solver and timestep controls
- structural supports and distortion-monitoring outputs
- `*LOAD_THERMAL_BINOUT` or `*LOAD_THERMAL_D3PLOT` for uncoupled mapping

Do not copy these blindly:

- weld path, travel speed, and heat input
- choose shells when through-thickness temperature gradient matters
- mapping cadence if the thermal-stage output interval changed

## Coupled Welding With Solids

Applicable problem:

- through-thickness weld pool and distortion where solid thermal gradients matter

Key solver family:

- coupled thermal-structural welding with solid mesh

Copy these controls:

- `*BOUNDARY_THERMAL_WELD_TRAJECTORY`
- `*MAT_THERMAL_CWM`
- coupled thermal-structural control logic
- solid-based thermal seam representation

Do not copy blindly:

- square-profile geometry
- weld material constants
- solid mesh density without heat-affected-zone resolution checks

Starter:

- `assets/templates/thermal-coupled-starter.k`
- `assets/templates/examples/thermal-coupled-minimal/`

## Coupled Welding With Shells

Applicable problem:

- thin welded structures where thermal thin-shell assumptions are acceptable

Key solver family:

- coupled thermal-structural welding with shells

Copy these controls:

- moving heat-source trajectory logic
- shell-based thermal representation

Do not copy blindly:

- use thin thermal shells when the curvature is caused by through-thickness temperature gradient

Starter:

- `assets/templates/thermal-coupled-starter.k`
- `assets/templates/examples/thermal-coupled-minimal/`

## Uncoupled Welding Linked With Binout

Applicable problem:

- thermal stage solved first, structural distortion solved second using mapped temperatures from `binout`

Key solver family:

- two-stage welding workflow

Copy these controls:

- `*LOAD_THERMAL_BINOUT`
- explicit thermal-to-structural handoff

Do not copy blindly:

- assume `binout` exists with the same path and output cadence
- use this mapping route on pre-R12.0 versions when the page explicitly calls out version availability

Starter:

- `assets/templates/thermal-coupled-starter.k` for stage 1
- `assets/templates/implicit-static-outline.k` for stage 2
- `assets/templates/examples/thermal-coupled-minimal/` for stage 1
- `assets/templates/examples/implicit-static-minimal/` for stage 2

## Uncoupled Welding Linked With D3PLOT

Applicable problem:

- structural continuation driven by mapped temperatures from `d3plot`

Key solver family:

- two-stage thermal then structure workflow

Copy these controls:

- `*LOAD_THERMAL_D3PLOT`
- output cadence chosen to support stable mapping

Do not copy blindly:

- `d3plot` mapping if the thermal stage did not write sufficient states for the structural continuation

Starter:

- `assets/templates/thermal-coupled-starter.k` for stage 1
- `assets/templates/implicit-static-outline.k` for stage 2
- `assets/templates/examples/thermal-coupled-minimal/` for stage 1
- `assets/templates/examples/implicit-static-minimal/` for stage 2
