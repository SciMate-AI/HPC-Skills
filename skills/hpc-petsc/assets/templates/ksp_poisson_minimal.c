#include <petscksp.h>

static PetscErrorCode FormRHS(Vec b)
{
  PetscFunctionBeginUser;
  PetscCall(VecSet(b, 1.0));
  PetscFunctionReturn(PETSC_SUCCESS);
}

int main(int argc, char **argv)
{
  Mat            A;
  Vec            x, b;
  KSP            ksp;
  PetscInt       N = 32, rstart, rend;

  PetscCall(PetscInitialize(&argc, &argv, NULL, NULL));
  PetscCall(PetscOptionsGetInt(NULL, NULL, "-n", &N, NULL));

  PetscCall(MatCreateAIJ(PETSC_COMM_WORLD, PETSC_DECIDE, PETSC_DECIDE, N, N, 3, NULL, 3, NULL, &A));
  PetscCall(MatGetOwnershipRange(A, &rstart, &rend));
  for (PetscInt row = rstart; row < rend; ++row) {
    if (row > 0) PetscCall(MatSetValue(A, row, row - 1, -1.0, INSERT_VALUES));
    PetscCall(MatSetValue(A, row, row, 2.0, INSERT_VALUES));
    if (row + 1 < N) PetscCall(MatSetValue(A, row, row + 1, -1.0, INSERT_VALUES));
  }
  PetscCall(MatAssemblyBegin(A, MAT_FINAL_ASSEMBLY));
  PetscCall(MatAssemblyEnd(A, MAT_FINAL_ASSEMBLY));

  PetscCall(MatCreateVecs(A, &x, &b));
  PetscCall(FormRHS(b));

  PetscCall(KSPCreate(PETSC_COMM_WORLD, &ksp));
  PetscCall(KSPSetOperators(ksp, A, A));
  PetscCall(KSPSetFromOptions(ksp));
  PetscCall(KSPSolve(ksp, b, x));

  PetscCall(KSPDestroy(&ksp));
  PetscCall(VecDestroy(&x));
  PetscCall(VecDestroy(&b));
  PetscCall(MatDestroy(&A));
  PetscCall(PetscFinalize());
  return 0;
}
