$ LS-DYNA SPH impact starter.
$ Best fit: bird strike, SPH projectile impact, grease or gel media, foam-like
$ SPH compression studies, and wave-impact adaptations that still use particles.
$ Intended for bird strike, SPH projectile impact, Taylor-bar-style SPH tests,
$ grease or gel media adaptations, and gravity-driven SPH free-surface variants.
$ See references/sph-example-recipes.md for case mapping.
*KEYWORD
*TITLE
sph_bird_impact_starter
$
$ Required include content:
$   - SPH particle nodes/elements for part 1
$   - target shell or solid mesh for part 2
$   - optional rigid support or rigidwall definitions
$
*PARAMETER
R TEND        2.0
R DTPLOT      0.01
R DTSTAT      0.002
R VELX      150.0
R RHO         1.0e-9
R C0        1480.0
R GAMMA       7.0
$
*CONTROL_SPH
1,1,1.0e20,3,500,15,0.0,200.0
0,0,0,1,0,1,1,100
0
*DEFINE_BOX
1,-200.0,200.0,-200.0,200.0,-200.0,200.0
*CONTROL_TIMESTEP
0.0,0.45,0,0.0,0.0
*CONTROL_TERMINATION
&TEND
*CONTROL_CONTACT
0,0,0,0,0,0,0,0
*CONTROL_ENERGY
2,2,2,2
*DATABASE_BINARY_D3PLOT
&DTPLOT
*DATABASE_GLSTAT
&DTSTAT
*DATABASE_MATSUM
&DTSTAT
*DATABASE_RCFORC
&DTSTAT
$
*SECTION_SPH
1
*MAT_NULL
1,&RHO
*EOS_GRUNEISEN
1,&C0,0.0,&GAMMA
$
*SECTION_SHELL
2,2,0.833,5
1.5,1.5,1.5,1.5
*MAT_PIECEWISE_LINEAR_PLASTICITY
2,7.85e-9,210000.0,0.30,350.0,1500.0
$
*PART
sph_projectile
1,1,1
*PART
target_structure
2,2,2
$
*INITIAL_VELOCITY_PART
1,&VELX,0.0,0.0
*CONTACT_AUTOMATIC_NODES_TO_SURFACE
$
*INCLUDE
sph_projectile_and_target.k
*END
