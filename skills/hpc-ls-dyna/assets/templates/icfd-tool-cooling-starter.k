$ LS-DYNA ICFD starter for a tool-cooling style problem.
$ Best fit: Tool cooling, thermal pipe, coolant manifold, and internal thermal-fluid
$ cases from the ICFD family. Do not use this as a thermal-only starter.
$ This starter is grounded in the tool-cooling and other ICFD example families on
$ dynaexamples.com, but simplified into a reusable template with placeholders.
$ Units below assume mm-ms-tonne-MPa-C.
*KEYWORD
*TITLE
icfd_tool_cooling_starter
$
$ Required include content:
$   - fluid volume mesh and boundary part IDs
$   - inlet part id 41
$   - outlet part id 42
$   - cooled wall / tool part id 43
$   - optional workpiece or conjugate solid part id 44
$
*PARAMETER
R TEND      200.0
R DTPLOT      5.0
R DTSTAT      1.0
R VIN         2.0
R TIN        20.0
R TTOOL      90.0
R TWORK      30.0
R HCONV       0.02
$
*CONTROL_TERMINATION
&TEND
*DATABASE_BINARY_D3PLOT
&DTPLOT
*DATABASE_GLSTAT
&DTSTAT
$
$ ICFD controls. Tighten or relax these after checking continuity and pressure.
*ICFD_CONTROL_TIME
0,1.0e-3,1.0e-6,1.0e-2
*ICFD_CONTROL_OUTPUT
1,&DTPLOT
*ICFD_CONTROL_SOLVER
1,1,1
*ICFD_CONTROL_TURBULENCE
0
$
$ Initial state and fluid properties. Replace with the coolant data actually used.
*ICFD_MAT
1,1.0e-9,1.0e-3
*ICFD_PART
fluid_domain
44,1
*ICFD_INITIAL
44,0.0,0.0,0.0,&TIN
$
$ Inlet velocity and temperature.
*DEFINE_CURVE
100
0.0,0.0
1.0,&VIN
*ICFD_BOUNDARY_PRESCRIBED_VEL
41,1,100
*ICFD_BOUNDARY_PRESCRIBED_TEMP
41,&TIN
$
$ Pressure outlet.
*ICFD_BOUNDARY_PRESCRIBED_PRE
42,0.0
$
$ Wall treatment for the cooled tool surface.
*ICFD_BOUNDARY_NONSLIP
43
*ICFD_BOUNDARY_PRESCRIBED_TEMP
43,&TTOOL
$
$ Optional conjugate solid placeholder. Activate only when the include provides it.
*MAT_THERMAL_ISOTROPIC
144,7.80e-9,45.0,4.60e-4,470.0
*PART
tool_insert
144,0,144
*INITIAL_TEMPERATURE_SET
44,&TWORK
$
*INCLUDE
icfd_mesh_and_bc.k
*END
