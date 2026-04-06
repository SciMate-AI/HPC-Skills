$ LS-DYNA ALE starter for underwater blast, sloshing, and short-time FSI baselines.
$ This is a semi-runnable scaffold for Eulerian or ALE-style fluid domains. It is
$ the preferred starting point for explosion, sloshing, advection, and structured
$ ALE adaptations. See references/ale-s-ale-example-recipes.md.
*KEYWORD
*TITLE
ale_explosion_starter
$
$ Required include content:
$   - ALE or Eulerian fluid mesh
$   - optional Lagrangian structure mesh
$   - fluid part id 1
$   - optional structure part id 2
$
*PARAMETER
R TEND       1.0
R DTPLOT     0.005
R DTSTAT     0.001
R GRAVY   -9810.0
$
*CONTROL_TERMINATION
&TEND
*CONTROL_TIMESTEP
0.0,0.60,0,0.0,0.0
*CONTROL_ENERGY
2,2,2,2
*DATABASE_BINARY_D3PLOT
&DTPLOT
*DATABASE_GLSTAT
&DTSTAT
*DATABASE_TRACER
&DTSTAT
*DATABASE_TRHIST
&DTSTAT
$
*SECTION_SOLID
1,1
*MAT_NULL
1,1.0e-9
*EOS_GRUNEISEN
1,1480.0,0.0,7.0
*PART
ale_fluid
1,1,1
$
$ Gravity/body loading for sloshing-style initialization. Remove when not needed.
*LOAD_BODY_Y
1,&GRAVY
$
$ Optional structure side, activate only when the include provides it.
*SECTION_SHELL
2,2,0.833,5
1.5,1.5,1.5,1.5
*MAT_PIECEWISE_LINEAR_PLASTICITY
2,7.85e-9,210000.0,0.30,350.0,1500.0
*PART
ale_structure
2,2,2
$
*INCLUDE
ale_mesh_and_parts.k
*END

