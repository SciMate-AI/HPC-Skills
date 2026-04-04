"""Gmsh Python API: 2D airfoil boundary layer mesh template.

Creates a NACA-style rectangular domain with boundary layer, wake refinement,
and solver-ready physical groups.

Adjust the parameters in the CONFIGURATION section to match your case.
"""
import gmsh
import math

# ── CONFIGURATION ──────────────────────────────────────────────────────────
chord = 1.0                    # airfoil chord length (geometry scale)
domain_radius = 20 * chord     # far-field distance
bl_first_layer = 5e-5 * chord  # first BL cell height (target y+ ~ 1)
bl_ratio = 1.15                # BL geometric growth ratio
bl_thickness = 0.05 * chord    # total BL thickness
bl_fan_elements = 15           # fan elements at trailing edge
wake_size = 0.005 * chord      # element size in near-wake
far_field_size = 2.0 * chord   # element size at far-field
near_field_size = 0.01 * chord # element size near airfoil
# ───────────────────────────────────────────────────────────────────────────

gmsh.initialize()
gmsh.model.add("airfoil_bl")

# --- Geometry (placeholder: ellipse approximating an airfoil) ---
# Replace this block with actual airfoil point/spline geometry
gmsh.model.occ.addDisk(0, 0, 0, chord, 0.06 * chord, tag=1)  # ellipse as proxy
gmsh.model.occ.addDisk(0, 0, 0, domain_radius, domain_radius, tag=2)
gmsh.model.occ.cut([(2, 2)], [(2, 1)], tag=3, removeObject=True, removeTool=False)
gmsh.model.occ.synchronize()

# --- Physical groups ---
# Identify boundary curves (inspect after synchronize)
all_curves = gmsh.model.getEntities(1)
airfoil_curves = []
farfield_curves = []
for dim, tag in all_curves:
    com = gmsh.model.occ.getCenterOfMass(dim, tag)
    dist = math.sqrt(com[0]**2 + com[1]**2)
    if dist < 2 * chord:
        airfoil_curves.append(tag)
    else:
        farfield_curves.append(tag)

all_surfs = [tag for _, tag in gmsh.model.getEntities(2)]

gmsh.model.addPhysicalGroup(2, all_surfs, 1, "fluid")
gmsh.model.addPhysicalGroup(1, airfoil_curves, 2, "airfoil")
gmsh.model.addPhysicalGroup(1, farfield_curves, 3, "farfield")

# --- Boundary layer field ---
f_bl = gmsh.model.mesh.field.add("BoundaryLayer")
gmsh.model.mesh.field.setNumbers(f_bl, "CurvesList", airfoil_curves)
gmsh.model.mesh.field.setNumber(f_bl, "Size", bl_first_layer)
gmsh.model.mesh.field.setNumber(f_bl, "Ratio", bl_ratio)
gmsh.model.mesh.field.setNumber(f_bl, "Thickness", bl_thickness)
gmsh.model.mesh.field.setNumber(f_bl, "Quads", 1)
gmsh.model.mesh.field.setAsBoundaryLayer(f_bl)

# --- Wake and near-field refinement ---
f_dist = gmsh.model.mesh.field.add("Distance")
gmsh.model.mesh.field.setNumbers(f_dist, "CurvesList", airfoil_curves)
gmsh.model.mesh.field.setNumber(f_dist, "Sampling", 200)

f_thresh = gmsh.model.mesh.field.add("Threshold")
gmsh.model.mesh.field.setNumber(f_thresh, "InField", f_dist)
gmsh.model.mesh.field.setNumber(f_thresh, "SizeMin", near_field_size)
gmsh.model.mesh.field.setNumber(f_thresh, "SizeMax", far_field_size)
gmsh.model.mesh.field.setNumber(f_thresh, "DistMin", bl_thickness)
gmsh.model.mesh.field.setNumber(f_thresh, "DistMax", 5 * chord)

f_min = gmsh.model.mesh.field.add("Min")
gmsh.model.mesh.field.setNumbers(f_min, "FieldsList", [f_thresh])
gmsh.model.mesh.field.setAsBackgroundMesh(f_min)

# --- Mesh options ---
gmsh.option.setNumber("Mesh.MeshSizeFromPoints", 0)
gmsh.option.setNumber("Mesh.MeshSizeFromCurvature", 0)
gmsh.option.setNumber("Mesh.MeshSizeExtendFromBoundary", 0)
gmsh.option.setNumber("Mesh.MeshSizeMax", far_field_size)
gmsh.option.setNumber("Mesh.Algorithm", 6)  # Frontal-Delaunay

# --- Generate and export ---
gmsh.model.mesh.generate(2)
gmsh.write("airfoil_bl.msh")

print("Mesh generated: airfoil_bl.msh")
print(f"  BL first layer: {bl_first_layer}")
print(f"  BL ratio: {bl_ratio}")
print(f"  BL thickness: {bl_thickness}")

gmsh.finalize()
