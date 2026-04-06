$ Explicit shell-impact starter deck.
$ Best fit: generic explicit crash/impact and as a structural base for Sieve-like
$ SPH/target hybrids. For pure SPH impact, begin from `sph-bird-impact-starter.k`.
$ This is intentionally close to runnable, but still expects the mesh include and
$ set definitions listed below. Values assume a mm-ms-tonne-MPa style unit system.
*KEYWORD
*TITLE
explicit_shell_impact_starter
$
$ Required include content:
$   - nodes and elements for part 100
$   - support node set 10
$   - driven node set 20
$   - optional contact slave/master segment sets if part contact is not enough
$
*PARAMETER
R TEND     8.0
R DTPLOT   0.08
R DTOUT    0.02
R THK      1.50
R RHO      7.85e-9
R E        210000.0
R PR       0.30
R SIGY     350.0
R ETAN     1500.0
R VELZ    -8.0
R MASSLIM -5.0e-7
$
*CONTROL_TERMINATION
&TEND
*CONTROL_TIMESTEP
0.0,0.90,0,0.0,&MASSLIM
*CONTROL_BULK_VISCOSITY
1.50,0.06
*CONTROL_CONTACT
0,0,0,0,0,0,0,0
*CONTROL_ENERGY
2,2,2,2
*CONTROL_HOURGLASS
1,0.03
*CONTROL_SHELL
0,0,0,0,2
$
*DATABASE_BINARY_D3PLOT
&DTPLOT
*DATABASE_GLSTAT
&DTOUT
*DATABASE_MATSUM
&DTOUT
*DATABASE_RCFORC
&DTOUT
*DATABASE_NODOUT
&DTOUT
$
$ Material and section: conservative baseline for a thin steel coupon.
*SECTION_SHELL
100,2,0.833,5
&THK,&THK,&THK,&THK
*MAT_PIECEWISE_LINEAR_PLASTICITY
100,&RHO,&E,&PR,&SIGY,&ETAN
$
*PART
coupon_shell
100,100,100
$
$ Supports: lock one edge or fixture set.
*BOUNDARY_SPC_SET
10,0,1,1,1,1,1,1
$
$ Drive the impact set in global Z with a smooth ramp to reduce startup shock.
*DEFINE_CURVE
100
0.0,0.0
0.2,&VELZ
&TEND,&VELZ
*BOUNDARY_PRESCRIBED_MOTION_SET
20,3,2,100,1.0
$
$ Use automatic contact if the coupon can self-contact or hit additional tooling
$ included elsewhere. Replace with surface-to-surface if the interface is known.
*CONTACT_AUTOMATIC_SINGLE_SURFACE
$
$ Output note:
$ - review GLSTAT for kinetic/internal/hourglass balance
$ - review MATSUM by part if more parts are added
$ - review RCFORC only if rigidwall or contact interfaces feed it in your build
$
*INCLUDE
mesh_and_sets.k
*END
