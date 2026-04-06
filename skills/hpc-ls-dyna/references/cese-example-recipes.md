# CESE And Dual-CESE Example Recipes

## Source Focus

- `dynaexamples.com/cese`
- `dynaexamples.com/cese/oricese`
- `dynaexamples.com/cese/dualcese`
- `dynaexamples.com/cese/dualcese/shockbubble`
- `dynaexamples.com/cese/dualcese/shockbubblefsi`
- `dynaexamples.com/latest-examples`

## Use This Reference For

- deciding whether to use legacy `*CESE` or newer `*DUALCESE`
- choosing between single-phase, multiphase, and FSI CESE precedents
- identifying when source examples must be used directly because solver-specific cards are too specialized for a generic local starter

## Starter Deck Mapping

CESE and Dual-CESE are currently source-first branches in this skill.

- start from the nearest upstream CESE or Dual-CESE example
- use `assets/templates/model-include-tree.txt` only for project organization after the solver-specific deck already works

Do not start from the ICFD, ALE, or explicit structural starters for CESE. The governing keyword families and solver expectations are different.

## Dual-CESE Versus CESE

`dynaexamples.com/cese/dualcese` explicitly states:

- `*DUALCESE` is more accurate and stable than classic `*CESE`
- `*DUALCESE` is better for coarse and triangle/tetrahedron meshes
- multiphase capabilities appear in R13
- multiphase FSI requires R14 or newer

Practical rule:

- prefer `*DUALCESE` on recent LS-DYNA versions
- use legacy `*CESE` mainly when matching older example lineage or missing a feature in the current DUAL-CESE branch

## Common CESE Reuse Pattern

Copy these parts only after matching the problem:

- CESE or DUAL-CESE solver family selection
- shock-capturing and boundary-condition strategy
- embedded or immersed FSI setup when a structure is present
- multiphase or cavitation settings only when the target problem truly needs them
- benchmark-style output monitoring at shocks, interfaces, and immersed structures

Do not copy these blindly:

- Mach number
- EOS parameters
- reacting-material model parameters
- embedded-boundary assumptions
- coarse benchmark meshes

## Legacy CESE: Sod Shock Tube Example

Applicable problem:

- first 1D compressible-flow verification
- shock-capturing sanity check

Key solver family:

- legacy `*CESE`

Copy these controls:

- shock-tube verification workflow
- simple left-right state initialization pattern

Do not copy blindly:

- 1D simplifications into multidimensional production cases

Starter:

- start from the upstream `Sod shock tube example`

## Legacy CESE: Moving Shock Wave Diffraction

Applicable problem:

- 2D moving shock diffraction around a corner
- validation of inlet and boundary treatment for shock propagation

Key solver family:

- legacy `*CESE`

Copy these controls:

- moving-shock boundary setup
- geometry partitioning around corner diffraction

Do not copy blindly:

- the stated Mach 1.2 relation and 90 degree corner

Starter:

- start from the upstream `Moving shock wave diffraction` example

## Legacy CESE Additional Branches

The site and latest-examples page expose additional CESE examples:

- Piston example
- Oblique shock wave impact
- Transonic flow around NACA0012
- Axisymmetric cannon
- Blast wave
- Embedded FSI example
- Erosion example

Use these when the target is clearly aligned with one of those benchmark classes.

## Dual-CESE: Shock Bubble Interaction

Applicable problem:

- multiphase compressible-flow benchmark
- shock-interface deformation and vortex generation

Key solver family:

- `*DUALCESE` multiphase

The example description explicitly highlights:

- stiffened-gas medium
- stationary bubble
- two-phase multiphase flow solver

Copy these controls:

- multiphase interface tracking workflow
- benchmark monitoring of bubble deformation and downstream vortices

Do not copy blindly:

- stiffened-gas material parameters
- bubble radius and shock strength

Starter:

- start from the upstream `Shock Bubble interaction` example

## Dual-CESE: Shock Bubble Interaction (+FSI) (+3D)

Applicable problem:

- multiphase compressible FSI
- flexible baffle or panel loaded by shock-driven interface waves

Key solver family:

- `*DUALCESE` multiphase plus FSI

Copy these controls:

- 2D versus 3D branch comparison
- flexible-structure coupling pattern

Do not copy blindly:

- baffle stiffness and thickness
- choose 3D unless the added dimensionality is actually needed

Starter:

- start from the upstream `Shock Bubble interaction (+FSI) (+3D)` example

## Dual-CESE: Slab Of Explosive In A Stick Form

Applicable problem:

- reactive multiphase flow with JWL EOS
- confined explosive benchmark

Key solver family:

- `*DUALCESE` reactive multiphase

Copy these controls:

- reactive-material and inert-confiner partitioning
- benchmark-style detonation observability

Do not copy blindly:

- JWL constants
- hybrid formulation parameters

Starter:

- start from the upstream `Slab of explosive in a stick form`

## Dual-CESE: Slab Of Explosive Confined In 3D Cylinder

Applicable problem:

- detonation-driven confiner deformation
- reactive flow plus structural response

Key solver family:

- `*DUALCESE` with structural coupling

Copy these controls:

- booster initiation logic
- confiner-structure response monitoring

Do not copy blindly:

- LX-17 and Ignition-and-Growth parameters
- confiner thickness

Starter:

- start from the upstream `Slab of explosive confined in 3D cylinder`

## Dual-CESE: Cavitation In Nozzle

Applicable problem:

- cavitating high-speed flow in small geometry such as diesel injection systems

Key solver family:

- `*DUALCESE` cavitation model

The site explicitly states the example uses Schmidt's homogeneous equilibrium model.

Copy these controls:

- cavitation-model workflow
- 2D versus 3D comparison logic

Do not copy blindly:

- nozzle dimensions
- fluid properties

Starter:

- start from the upstream `Cavitation in nozzle`

## Dual-CESE: Supersonic Flow Over 15 Degree Ramp And Forward Facing Step

Applicable problem:

- shock-capture verification in compressible flow

Key solver family:

- `*DUALCESE` single-phase compressible

Copy these controls:

- standard shock-verification workflow
- wall-reflection observability

Do not copy blindly:

- inlet Mach 2.5
- benchmark geometry angles

Starter:

- start from the upstream `Supersonic Flow over 15° Ramp` or `Forward Facing Step`

## Dual-CESE: 2D Projectile, Moving Wedge, Folded Bag Deployment, Vacuum Tube, Embedded FSI, Traffic Sign Deflection, 2D Pole Deformation, 3D Piston Problem

Applicable problem:

- compressible-flow FSI with immersed or embedded structures

Key solver family:

- `*DUALCESE` with embedded-boundary or immersed FSI

Copy these controls:

- immersed-structure workflow
- fluid-dominant observability plus structural response outputs

Do not copy blindly:

- projectile speed, wedge motion, bag geometry, or structural properties

Starter:

- start from the nearest upstream DUAL-CESE example in this family

