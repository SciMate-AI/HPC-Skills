"""Gmsh Python API: STEP import, meshing, and export template.

Imports a STEP file, defines physical groups, meshes with size fields,
and exports for a downstream solver.

Replace 'model.step' with your actual STEP file path.
"""
import gmsh
import sys

# ── CONFIGURATION ──────────────────────────────────────────────────────────
step_file = "model.step"                # input STEP file
output_file = "mesh.msh"               # output mesh file
mesh_size_min = 0.5                     # minimum element size
mesh_size_max = 10.0                    # maximum element size
curvature_elements = 20                 # elements per 2*pi radians
num_threads = 4                         # parallel threads
optimize = True                         # run tet optimization
element_order = 1                       # 1 = linear, 2 = quadratic
# ───────────────────────────────────────────────────────────────────────────

gmsh.initialize()
gmsh.model.add("step_import")

# --- Import STEP ---
gmsh.option.setNumber("Geometry.OCCFixDegenerated", 1)
gmsh.option.setNumber("Geometry.OCCFixSmallEdges", 1)
gmsh.option.setNumber("Geometry.OCCFixSmallFaces", 1)
gmsh.option.setNumber("Geometry.OCCSewFaces", 1)

try:
    gmsh.model.occ.importShapes(step_file)
except Exception as e:
    print(f"Failed to import {step_file}: {e}")
    gmsh.finalize()
    sys.exit(1)

gmsh.model.occ.synchronize()

# --- Inspect imported geometry ---
volumes = gmsh.model.getEntities(3)
surfaces = gmsh.model.getEntities(2)
curves = gmsh.model.getEntities(1)
print(f"Imported: {len(volumes)} volumes, {len(surfaces)} surfaces, {len(curves)} curves")

# --- Physical groups ---
# Option A: tag everything (customize as needed)
vol_tags = [tag for _, tag in volumes]
surf_tags = [tag for _, tag in surfaces]
gmsh.model.addPhysicalGroup(3, vol_tags, 1, "solid")
gmsh.model.addPhysicalGroup(2, surf_tags, 2, "boundary")

# Option B: identify surfaces by bounding box (example: find surfaces near z=0)
# eps = 0.1
# bottom_surfs = []
# for dim, tag in surfaces:
#     bbox = gmsh.model.getBoundingBox(dim, tag)
#     if bbox[2] < eps and bbox[5] < eps:  # zmin and zmax near 0
#         bottom_surfs.append(tag)
# gmsh.model.addPhysicalGroup(2, bottom_surfs, 3, "bottom")

# --- Mesh size ---
gmsh.option.setNumber("Mesh.MeshSizeMin", mesh_size_min)
gmsh.option.setNumber("Mesh.MeshSizeMax", mesh_size_max)
gmsh.option.setNumber("Mesh.MeshSizeFromCurvature", curvature_elements)

# --- Parallel and algorithm ---
gmsh.option.setNumber("General.NumThreads", num_threads)
gmsh.option.setNumber("Mesh.Algorithm3D", 10)   # HXT for parallel speed

# --- Generate mesh ---
gmsh.model.mesh.generate(3)

if optimize:
    gmsh.model.mesh.optimize("Netgen")

if element_order > 1:
    gmsh.model.mesh.setOrder(element_order)
    gmsh.model.mesh.optimize("HighOrder")

# --- Export ---
gmsh.write(output_file)

# --- Summary ---
gmsh.logger.start()
types = gmsh.model.mesh.getElementTypes()
total = 0
for t in types:
    name, dim, order, nv, _, _ = gmsh.model.mesh.getElementProperties(t)
    tags, _ = gmsh.model.mesh.getElementsByType(t)
    total += len(tags)
    print(f"  {name}: {len(tags)} elements")
print(f"Total: {total} elements → {output_file}")
gmsh.logger.stop()

gmsh.finalize()
