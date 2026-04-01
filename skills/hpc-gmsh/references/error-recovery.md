# Gmsh Error Recovery

## Geometry failures

If geometry construction fails or entities seem to disappear:

1. verify the chosen kernel matches the operations being used
2. reduce the model to the smallest failing geometry
3. inspect topology before changing mesh options

## Tagging failures

If downstream boundaries or regions are wrong:

- verify physical groups were defined explicitly
- verify the correct entity dimension was grouped
- verify export happened after the intended groups were created

## Meshing failures

If meshing fails or element quality is poor:

1. remove nonessential transfinite or recombine constraints
2. simplify size fields
3. inspect geometry defects and tiny features
4. reintroduce advanced controls only after a baseline mesh exists

## Reporting

A useful repair report includes:

- chosen kernel
- geometry and physical-group summary
- meshing dimension
- advanced controls such as fields or recombine
- exact failure signature
