"""Gmsh Python API: periodic channel mesh template.

Creates a 3D rectangular channel with periodic boundary conditions
on the streamwise (x) and spanwise (z) directions.
Top and bottom walls are no-slip boundaries.

Produces a structured hex mesh suitable for DNS/LES channel flow.
"""
import gmsh

# ── CONFIGURATION ──────────────────────────────────────────────────────────
Lx = 6.283185         # streamwise length (2*pi)
Ly = 2.0              # wall-normal height (channel half-height = 1)
Lz = 3.141593         # spanwise width (pi)
Nx = 64               # nodes in x
Ny = 65               # nodes in y (graded toward walls)
Nz = 32               # nodes in z
grading_y = 1.15      # geometric grading toward walls in y
# ───────────────────────────────────────────────────────────────────────────

gmsh.initialize()
gmsh.model.add("periodic_channel")

# --- Geometry ---
gmsh.model.occ.addBox(0, 0, 0, Lx, Ly, Lz, tag=1)
gmsh.model.occ.synchronize()

# --- Identify surfaces by position ---
surfs = gmsh.model.getEntities(2)
bottom, top, inlet, outlet, front, back = [], [], [], [], [], []
for dim, tag in surfs:
    com = gmsh.model.occ.getCenterOfMass(dim, tag)
    if abs(com[1]) < 1e-10:
        bottom.append(tag)
    elif abs(com[1] - Ly) < 1e-10:
        top.append(tag)
    elif abs(com[0]) < 1e-10:
        inlet.append(tag)
    elif abs(com[0] - Lx) < 1e-10:
        outlet.append(tag)
    elif abs(com[2]) < 1e-10:
        front.append(tag)
    elif abs(com[2] - Lz) < 1e-10:
        back.append(tag)

# --- Physical groups ---
gmsh.model.addPhysicalGroup(3, [1], 1, "fluid")
gmsh.model.addPhysicalGroup(2, bottom, 2, "bottom_wall")
gmsh.model.addPhysicalGroup(2, top, 3, "top_wall")
gmsh.model.addPhysicalGroup(2, inlet, 4, "inlet")
gmsh.model.addPhysicalGroup(2, outlet, 5, "outlet")
gmsh.model.addPhysicalGroup(2, front, 6, "front")
gmsh.model.addPhysicalGroup(2, back, 7, "back")

# --- Structured mesh ---
# Transfinite on all curves, with grading on y-direction curves
for dim, tag in gmsh.model.getEntities(1):
    p1, p2 = [t for _, t in gmsh.model.getBoundary([(dim, tag)])]
    c1 = gmsh.model.getValue(0, abs(p1), [])
    c2 = gmsh.model.getValue(0, abs(p2), [])
    dy = abs(c2[1] - c1[1])
    dx = abs(c2[0] - c1[0])
    dz = abs(c2[2] - c1[2])

    if dy > max(dx, dz):
        # y-direction curve: graded toward walls
        gmsh.model.mesh.setTransfiniteCurve(tag, Ny, "Bump", grading_y)
    elif dx > max(dy, dz):
        gmsh.model.mesh.setTransfiniteCurve(tag, Nx)
    else:
        gmsh.model.mesh.setTransfiniteCurve(tag, Nz)

for dim, tag in gmsh.model.getEntities(2):
    gmsh.model.mesh.setTransfiniteSurface(tag)
    gmsh.model.mesh.setRecombine(dim, tag)

gmsh.model.mesh.setTransfiniteVolume(1)

# --- Periodic boundary conditions ---
# x-periodicity: outlet = inlet + translate(Lx, 0, 0)
gmsh.model.mesh.setPeriodic(2, outlet, inlet,
    [1, 0, 0, Lx, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1])

# z-periodicity: back = front + translate(0, 0, Lz)
gmsh.model.mesh.setPeriodic(2, back, front,
    [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, Lz, 0, 0, 0, 1])

# --- Generate ---
gmsh.model.mesh.generate(3)
gmsh.write("periodic_channel.msh")

print(f"Channel mesh: {Nx}x{Ny}x{Nz} = {(Nx-1)*(Ny-1)*(Nz-1)} hex elements")
print(f"  Periodic in x (inlet↔outlet) and z (front↔back)")
print(f"  Walls: bottom, top")

gmsh.finalize()
