import gmsh


def main():
    gmsh.initialize()
    gmsh.model.add("occ_box")

    box = gmsh.model.occ.addBox(0.0, 0.0, 0.0, 1.0, 0.5, 0.25)
    gmsh.model.occ.synchronize()

    gmsh.model.addPhysicalGroup(3, [box], 1)
    gmsh.model.setPhysicalName(3, 1, "solid")

    boundary = gmsh.model.getBoundary([(3, box)], oriented=False)
    surface_tags = [tag for dim, tag in boundary if dim == 2]
    gmsh.model.addPhysicalGroup(2, surface_tags, 2)
    gmsh.model.setPhysicalName(2, 2, "boundary")

    gmsh.model.mesh.generate(3)
    gmsh.write("occ_box.msh")
    gmsh.finalize()


if __name__ == "__main__":
    main()
