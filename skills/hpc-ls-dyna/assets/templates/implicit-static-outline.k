$ Implicit static / preload starter deck.
$ Best fit: Yaris static suspension loading, Yaris door sag, buckling, springback
$ continuation, and structural stages after mapped thermal fields.
$ The structure is inspired by the implicit and preload examples on dynaexamples.com
$ but simplified into a reusable project starter.
*KEYWORD
*TITLE
implicit_static_preload_starter
$
$ Required include content:
$   - structural mesh with shell/solid/beam parts
$   - constrained node set 10
$   - loaded node set 20
$   - optional beam set 30 if bolt or pretension preload is used
$
*PARAMETER
R TEND      1.0
R DTPLOT    0.05
R DTSTAT    0.02
R DISPZ    -5.0
R DT0       0.02
R DTMIN     1.0e-5
R DTMAX     0.05
R PRELOAD   0.0
$
*CONTROL_IMPLICIT_GENERAL
1,0,1
*CONTROL_IMPLICIT_AUTO
1,&DT0,&DTMIN,&DTMAX
*CONTROL_IMPLICIT_SOLUTION
12,100,25
*CONTROL_TERMINATION
&TEND
$
*DATABASE_BINARY_D3PLOT
&DTPLOT
*DATABASE_GLSTAT
&DTSTAT
*DATABASE_MATSUM
&DTSTAT
*DATABASE_NODOUT
&DTSTAT
$
$ A conservative elastic-plastic steel baseline for brackets, links, or closure
$ studies. Replace with implicit-qualified material models for production work.
*SECTION_SHELL
100,16,1.0,5
1.50,1.50,1.50,1.50
*MAT_PIECEWISE_LINEAR_PLASTICITY
100,7.85e-9,210000.0,0.30,300.0,1200.0
*PART
implicit_shell_part
100,100,100
$
*BOUNDARY_SPC_SET
10,0,1,1,1,1,1,1
$
$ Use a displacement ramp for static loading. Keep it smooth to help convergence.
*DEFINE_CURVE
100
0.0,0.0
0.25,0.25
1.0,1.0
*BOUNDARY_PRESCRIBED_MOTION_SET
20,3,2,100,&DISPZ
$
$ Optional preload path for beam-based bolt idealization.
$ Activate only when set 30 exists and pretension is part of the problem.
*INITIAL_AXIAL_FORCE_BEAM
30,&PRELOAD
$
$ If contact is needed, start with the simplest implicit-capable interface.
*CONTACT_AUTOMATIC_SURFACE_TO_SURFACE
$
*INCLUDE
mesh_and_sets.k
*END
