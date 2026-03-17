Multiphase placeholder scaffold (not self-contained yet).

Use this directory as a checklist only. A runnable `interFoam` or
`foamRun -solver incompressibleVoF` case still requires:
- 0/U
- 0/p
- 0/p_rgh
- 0/alpha.water
- constant/g
- constant/transportProperties (or equivalent phase properties for your version)
- constant/turbulenceProperties
- system/blockMeshDict or imported mesh
- system/controlDict
- system/fvSchemes
- system/fvSolution

Recommended stable workflow:
1. Start from an official OpenFOAM multiphase tutorial.
2. Align patch names and physics with your geometry.
3. Run `checkMesh`.
4. Dry-start with conservative `maxCo` and `maxAlphaCo`.
