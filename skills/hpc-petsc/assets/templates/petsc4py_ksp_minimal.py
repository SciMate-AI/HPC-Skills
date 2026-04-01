from petsc4py import PETSc


def main():
    n = 32
    A = PETSc.Mat().createAIJ([n, n], nnz=3, comm=PETSc.COMM_WORLD)
    A.setUp()
    rstart, rend = A.getOwnershipRange()
    for row in range(rstart, rend):
        if row > 0:
            A[row, row - 1] = -1.0
        A[row, row] = 2.0
        if row + 1 < n:
            A[row, row + 1] = -1.0
    A.assemble()

    b = PETSc.Vec().createMPI(n, comm=PETSc.COMM_WORLD)
    x = b.duplicate()
    b.set(1.0)

    ksp = PETSc.KSP().create(PETSc.COMM_WORLD)
    ksp.setOperators(A)
    ksp.setFromOptions()
    ksp.solve(b, x)


if __name__ == "__main__":
    main()
