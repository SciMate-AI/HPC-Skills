$ LS-DYNA thermal / thermo-mechanical starter.
$ Best fit: thermal stress, transient or steady heat transfer, thermal contact,
$ thick/thin thermal shells, and welding thermal stages.
$ This starter is intended for thermal stress, transient heat transfer, thermal
$ contact, shell thermal-thickness comparisons, and as the thermal stage for
$ uncoupled welding or mapped-temperature workflows.
$ See references/thermal-example-recipes.md for case mapping.
*KEYWORD
*TITLE
thermal_coupled_starter
$
$ Required include content:
$   - thermal mesh and boundary sets
$   - thermal support or fixture set 10 if structural coupling is active
$   - heat-flux surface set 20 or prescribed-temperature surface set 21
$
*PARAMETER
R TEND        10.0
R DTPLOT       0.1
R DTSTAT       0.1
R DTMECH       1.0e-4
R DTTHERM      0.1
R TINIT       20.0
R TFIX        20.0
R QFLUX      0.005
R SOLN         2
R THERMODE     1
$
$ SOLN=1 for thermal-only, SOLN=2 for coupled thermal-structural
$ THERMODE=0 for steady-state thermal, THERMODE=1 for transient thermal
*CONTROL_SOLUTION
&SOLN
*CONTROL_THERMAL_SOLVER
&THERMODE,1,11
*CONTROL_TIMESTEP
0.0,0.9,0,0.0,&DTMECH
*CONTROL_THERMAL_TIMESTEP
&DTTHERM,1.0,10,1.0e-5,1.0
*CONTROL_TERMINATION
&TEND
*DATABASE_BINARY_D3PLOT
&DTPLOT
*DATABASE_GLSTAT
&DTSTAT
*DATABASE_MATSUM
&DTSTAT
*DATABASE_TPRINT
&DTSTAT
$
*PART
thermal_part
1,1,1,0,0,0,0,1
*SECTION_SOLID
1,1
*MAT_ELASTIC
1,7.85e-9,210000.0,0.30
*MAT_THERMAL_ISOTROPIC
1,7.85e-9,45.0,1.20e-5,470.0
$
*INITIAL_TEMPERATURE_SET
1,&TINIT
*BOUNDARY_THERMAL_SET
21,&TFIX
*LOAD_HEAT_FLUX_SET
20,&QFLUX
$
$ Structural support, used only when coupled mechanics is active.
*BOUNDARY_SPC_SET
10,0,1,1,1,1,1,1
$
*INCLUDE
thermal_mesh_and_sets.k
*END
