# Thermal Example Recipes

## Source Focus

- `dynaexamples.com/thermal`
- representative reduced-input pages such as:
  `thermal-stress/reduced-input`
  `metal-forming/reduced-input`
  `heat-transfer/steady-state/reduced-input`
  `heat-transfer/transient/reduced-input`
  `radiation-convection/reduced-input`
  `thick-thin-shells/reduced-input`
  `welding-new`
  `thermalcontact-heatflux/reduced-input`

## Use This Reference For

- deciding whether the case is thermal-only, coupled structural-thermal, or a staged uncoupled transfer problem
- selecting thermal timestep strategy and thermal boundary conditions
- determining whether to begin from a thermal starter, an ICFD starter, or a structural implicit starter with thermal additions

## Starter Deck Mapping

Use these starter decks first:

- `assets/templates/thermal-coupled-starter.k` for thermal-only, coupled thermal-structural, heat-transfer, roof, shell-heating, and thermal-contact examples
- `assets/templates/icfd-tool-cooling-starter.k` for coolant-channel, tool cooling, and fluid-mediated thermal transport
- `assets/templates/implicit-static-outline.k` when the thermal field is imported or applied as a load in a mainly structural implicit continuation
- `assets/templates/examples/thermal-coupled-minimal/` when the case should begin as a multi-file thermal or thermal-structural project
- `assets/templates/examples/icfd-tool-cooling-minimal/` when the cooling case already needs separated mesh and boundary files
- `assets/templates/examples/implicit-static-minimal/` when the thermal field is imported into a multi-file structural continuation

## Common Thermal Reuse Pattern

Copy these families only after matching the problem class:

- `*CONTROL_SOLUTION`
- `*CONTROL_THERMAL_SOLVER`
- `*CONTROL_THERMAL_TIMESTEP`
- `*CONTROL_THERMAL_NONLINEAR` for nonlinear thermal boundary conditions or strong radiation/convection coupling
- `*DATABASE_TPRINT`, `*DATABASE_BINARY_D3PLOT`, `*DATABASE_GLSTAT`, and `*DATABASE_MATSUM`
- thermal material cards and thermal section logic
- process-specific cards such as `*BOUNDARY_THERMAL_WELD_TRAJECTORY`, `*LOAD_THERMAL_BINOUT`, or `*LOAD_THERMAL_D3PLOT`

Do not copy these blindly:

- thermal time-step magnitudes
- fixed temperatures and heat-flux magnitudes
- emissivity, convection coefficient, and contact-conductance values
- the assumption that mechanical and thermal timescales can always be separated by the same factor as the example

## Thermal Stress

Applicable problem:

- unconstrained or lightly constrained thermal expansion
- first coupled structural-thermal sanity check

Key solver family:

- coupled structural-thermal with explicit structural integration and implicit thermal integration

The reduced input shows a compact but reusable baseline:

- `*CONTROL_SOLUTION` set to coupled mode
- `*CONTROL_THERMAL_SOLVER`
- `*CONTROL_TIMESTEP`
- `*CONTROL_THERMAL_TIMESTEP`
- `*DATABASE_BINARY_D3PLOT`
- `*DATABASE_GLSTAT`

Copy these controls:

- the separation of thermal and structural time integration
- simple volumetric heat generation pattern
- minimal thermal observability for a first-run coupled check

Do not copy blindly:

- the single-brick idealization
- the initial temperature of 10 or the exact thermal source

Starter:

- `assets/templates/thermal-coupled-starter.k`

## Metal Forming

Applicable problem:

- upsetting, compression, and forming with conversion of plastic work to heat

Key solver family:

- coupled thermal-structural explicit structure plus thermal solve

The reduced input shows:

- `*CONTROL_SOLUTION` in coupled mode
- `*CONTROL_TIMESTEP`
- `*CONTROL_THERMAL_SOLVER`
- `*CONTROL_THERMAL_TIMESTEP`
- `*CONTROL_HOURGLASS`
- `*DATABASE_TPRINT`

Copy these controls:

- mechanical timestep much smaller than thermal timestep
- plastic-work-to-heat workflow
- coupled output cadence for process evolution

Do not copy blindly:

- the example `1000x` mechanical/thermal scale split without checking deformation speed and heat diffusion
- quarter-symmetry assumptions

Starter:

- `assets/templates/thermal-coupled-starter.k`, then add tooling and contact from the forming model
- `assets/templates/examples/thermal-coupled-minimal/`, then add tooling and contact from the forming model

## Thermal Expansion

Applicable problem:

- thermal strain in structures
- comparison of structural-only thermal load versus coupled thermal-structural solution

Key solver family:

- either structural-only with thermal load or full coupled thermal-structural

The reduced-input variants show both:

- a structural-only thermal-load route
- a structure-thermal coupled route with `*CONTROL_ACCURACY`

Copy these controls:

- choose the correct route explicitly:
  coupled solve if the temperature field must be solved
  structural-only route if a temperature field is already known
- `*CONTROL_ACCURACY` for implicit-sensitive structural response when used

Do not copy blindly:

- the steel-frame assumptions
- a coupled solve when all you need is a mapped temperature field

Starter:

- `assets/templates/thermal-coupled-starter.k`
- `assets/templates/examples/thermal-coupled-minimal/`
- or `assets/templates/implicit-static-outline.k` if the temperature field is external and the job is mainly structural
- or `assets/templates/examples/implicit-static-minimal/` if the temperature field is external and the job is mainly structural

## Heat Transfer: Steady-State

Applicable problem:

- steady conduction through walls, blocks, or layered structures

Key solver family:

- thermal-only steady-state

The reduced input shows:

- `*CONTROL_SOLUTION` as thermal-only
- `*CONTROL_THERMAL_SOLVER` in steady-state mode
- simple output and part/thermal-material partitioning

Copy these controls:

- thermal-only mode
- steady-state solver selection
- layered-part modeling pattern

Do not copy blindly:

- wall thickness, conductivity, or boundary temperatures

Starter:

- `assets/templates/thermal-coupled-starter.k`, set it to thermal-only and steady-state
- `assets/templates/examples/thermal-coupled-minimal/`, set it to thermal-only and steady-state

## Heat Transfer: Transient

Applicable problem:

- heat soak, cooldown, or any time-dependent conduction case

Key solver family:

- thermal-only transient

The reduced input shows:

- `*CONTROL_THERMAL_SOLVER` in transient mode
- `*CONTROL_THERMAL_TIMESTEP` with explicit minimum and maximum thermal time bounds

Copy these controls:

- transient thermal timestep bounding
- output cadence tied to thermal transients rather than structural microsteps

Do not copy blindly:

- `tmin` and `tmax` from the concrete wall example

Starter:

- `assets/templates/thermal-coupled-starter.k`, set it to thermal-only and transient
- `assets/templates/examples/thermal-coupled-minimal/`, set it to thermal-only and transient

## Radiation And Convection

Applicable problem:

- environmental heating/cooling with surface exchange
- roof, enclosure, insulation, and panel problems

Key solver family:

- thermal-only transient with nonlinear thermal boundary conditions

The reduced input shows:

- `*CONTROL_THERMAL_NONLINEAR`
- long-duration thermal stepping
- explicit thermal output print interval selection

Copy these controls:

- nonlinear thermal boundary treatment
- long-step thermal solve logic
- multiple surface-treatment comparison structure

Do not copy blindly:

- roof-layer materials, emissivity, convection coefficients, or ambient temperatures

Starter:

- `assets/templates/thermal-coupled-starter.k`
- `assets/templates/examples/thermal-coupled-minimal/`

## Welding: Coupled Solids And Shells

Applicable problem:

- moving heat-source welding, seam generation, and weld-induced distortion

Key solver family:

- coupled thermal-structural welding

The welding pages explicitly show:

- `*BOUNDARY_THERMAL_WELD_TRAJECTORY`
- `*MAT_THERMAL_CWM`
- solid and shell variants

Copy these controls:

- moving heat-source trajectory pattern
- choose shell or solid thermal representation based on through-thickness gradient importance
- post-weld distortion monitoring

Do not copy blindly:

- the square-profile-on-plate geometry
- shell model when through-thickness gradient is actually needed
- weld material parameters

Starter:

- `assets/templates/thermal-coupled-starter.k`
- `assets/templates/examples/thermal-coupled-minimal/`

## Welding: Uncoupled Mapping

Applicable problem:

- when the temperature field is solved in one stage and then mapped into a structural solve

Key solver family:

- staged thermal then structural continuation

The welding pages explicitly mention:

- `*LOAD_THERMAL_BINOUT`
- `*LOAD_THERMAL_D3PLOT`

Copy these controls:

- two-stage workflow
- explicit identification of the thermal-result source file

Do not copy blindly:

- binout or d3plot mapping cadence if the thermal run uses a different output rate

Starter:

- `assets/templates/thermal-coupled-starter.k` for the thermal stage
- then `assets/templates/implicit-static-outline.k` for the structural stage
- `assets/templates/examples/thermal-coupled-minimal/` for the thermal stage
- then `assets/templates/examples/implicit-static-minimal/` for the structural stage

## Thermal Contact And Heat Flux

Applicable problem:

- conductive contact, near-contact radiative or convective exchange, and plate-heating problems

Key solver family:

- thermal-only transient with contact-mediated heat transfer

The reduced input shows:

- `*CONTROL_SOLUTION` as thermal-only
- `*CONTROL_THERMAL_SOLVER`
- `*CONTROL_THERMAL_TIMESTEP`

Copy these controls:

- heat-source part and receiver-part partitioning
- direct-contact versus near-contact exchange logic

Do not copy blindly:

- contact gap thresholds
- heat flux magnitudes

Starter:

- `assets/templates/thermal-coupled-starter.k`
- `assets/templates/examples/thermal-coupled-minimal/`

## Thermal Thick And Thin Shells

Applicable problem:

- deciding whether shell thermal gradients through thickness matter
- strip, panel, or shell heating where curvature from thermal gradient may appear

Key solver family:

- coupled structural-thermal shell analysis

The reduced input shows:

- `*CONTROL_SOLUTION` in coupled mode
- `*CONTROL_THERMAL_SOLVER`
- `*CONTROL_TIMESTEP`
- `*CONTROL_THERMAL_TIMESTEP`

Copy these controls:

- paired comparison mindset between thick and thin thermal shells
- shell-specific thermal-section choice

Do not copy blindly:

- thin-shell formulation if your part bends because of thickness gradient
- thick-shell choice if through-thickness temperature is negligible and efficiency matters

Starter:

- `assets/templates/thermal-coupled-starter.k`
- `assets/templates/examples/thermal-coupled-minimal/`
