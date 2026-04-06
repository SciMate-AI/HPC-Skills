$ Implicit bolt / preload starter inspired by the Dynaexamples bolt showcase family.
$ Best fit: Bolt Types A-D, clamped joints, pretension carryover, and service-load
$ continuation after preload.
$ Use this when the engineering question is clamp load transfer, joint closure,
$ preload carryover, or bolt-contact sequencing.
*KEYWORD
*TITLE
bolt_preload_implicit_starter
$
$ Required include content:
$   - beam or solid bolt representation
$   - clamped components
$   - fixed support node set 10
$   - displacement or assembly node set 20
$   - beam set 30 for pretension
$   - contact surfaces for the joint stack
$
*PARAMETER
R TEND       1.0
R DTPLOT     0.05
R DTSTAT     0.02
R PRELOAD 15000.0
R SETTLE     0.20
R SERVICE   -0.50
$
*CONTROL_IMPLICIT_GENERAL
1,0,1
*CONTROL_IMPLICIT_AUTO
1,0.02,1.0e-5,0.05
*CONTROL_IMPLICIT_SOLUTION
12,120,30
*CONTROL_TERMINATION
&TEND
$
*DATABASE_BINARY_D3PLOT
&DTPLOT
*DATABASE_GLSTAT
&DTSTAT
*DATABASE_MATSUM
&DTSTAT
*DATABASE_RCFORC
&DTSTAT
$
$ Apply pretension first, then keep it while service load is ramped.
*INITIAL_AXIAL_FORCE_BEAM
30,&PRELOAD
$
*DEFINE_CURVE
100
0.0,0.0
0.20,0.0
1.0,1.0
*BOUNDARY_PRESCRIBED_MOTION_SET
20,3,2,100,&SERVICE
$
*BOUNDARY_SPC_SET
10,0,1,1,1,1,1,1
$
*CONTACT_AUTOMATIC_SURFACE_TO_SURFACE
*CONTACT_AUTOMATIC_SINGLE_SURFACE
$
*INCLUDE
bolt_joint_mesh_and_sets.k
*END
