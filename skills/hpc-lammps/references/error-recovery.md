# LAMMPS Error Recovery

## Contents

- Lost atoms
- Potential and path failures
- Neighbor overflows
- Non-numeric thermo output

## Lost atoms

Failure signatures:

- `Lost atoms`
- `Out of range atoms`

Recovery actions:

1. Insert an energy minimization before dynamics if the blow-up happens immediately.
2. Reduce the timestep.
3. Force frequent neighbor rebuilds.
4. Recheck boundary handling for non-periodic boxes.

Repeated lost atoms usually indicate a physically bad startup state, not just a logging problem.

## Potential and path failures

Failure signatures:

- cannot open the potential file
- incorrect args for `pair_coeff`

Recovery actions:

1. Verify the potential file path.
2. Rebuild the atom-type to element map explicitly.
3. Confirm the chosen `pair_style` matches the file family.

Do not keep editing syntax blindly when the underlying file is absent.

## Neighbor overflows

Failure signatures:

- `Neighbor list overflow`
- `Too many neighbor bins`

Recovery actions:

1. Check whether the skin distance is unreasonable for the chosen units.
2. Check whether the barostat is collapsing the box into an unphysical density.
3. Increase neighbor allocation only after the physics setup looks sane.

## Non-numeric thermo output

Failure signatures:

- `Non-numeric pressure`
- `Non-numeric temperature`
- `NaN`

Recovery actions:

1. Increase damping times if thermostat or barostat coupling is too aggressive.
2. Stage the run: minimize, then NVT, then NPT if needed.
3. Reduce the timestep during early equilibration.
4. Check for bad overlaps or unrealistic initial volume.
