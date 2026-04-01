#include "HYPRE.h"
#include "HYPRE_parcsr_ls.h"
#include "HYPRE_IJ_mv.h"
#include "_hypre_utilities.h"

int main(int argc, char *argv[])
{
  MPI_Comm         comm = MPI_COMM_WORLD;
  HYPRE_Int        ilower, iupper, n = 32;
  HYPRE_IJMatrix   A;
  HYPRE_IJVector   b, x;
  HYPRE_ParCSRMatrix parA;
  HYPRE_ParVector  parb, parx;
  HYPRE_Solver     solver, precond;

  MPI_Init(&argc, &argv);
  HYPRE_Init();

  int rank, size;
  MPI_Comm_rank(comm, &rank);
  MPI_Comm_size(comm, &size);
  ilower = (n * rank) / size;
  iupper = (n * (rank + 1)) / size - 1;

  HYPRE_IJMatrixCreate(comm, ilower, iupper, ilower, iupper, &A);
  HYPRE_IJMatrixSetObjectType(A, HYPRE_PARCSR);
  HYPRE_IJMatrixInitialize(A);
  for (HYPRE_Int row = ilower; row <= iupper; ++row) {
    HYPRE_Int ncols = 0;
    HYPRE_Int cols[3];
    double    vals[3];
    if (row > 0) {
      cols[ncols] = row - 1;
      vals[ncols++] = -1.0;
    }
    cols[ncols] = row;
    vals[ncols++] = 2.0;
    if (row + 1 < n) {
      cols[ncols] = row + 1;
      vals[ncols++] = -1.0;
    }
    HYPRE_IJMatrixSetValues(A, 1, &ncols, &row, cols, vals);
  }
  HYPRE_IJMatrixAssemble(A);
  HYPRE_IJMatrixGetObject(A, (void **) &parA);

  HYPRE_IJVectorCreate(comm, ilower, iupper, &b);
  HYPRE_IJVectorSetObjectType(b, HYPRE_PARCSR);
  HYPRE_IJVectorInitialize(b);
  for (HYPRE_Int row = ilower; row <= iupper; ++row) {
    double one = 1.0;
    HYPRE_IJVectorSetValues(b, 1, &row, &one);
  }
  HYPRE_IJVectorAssemble(b);
  HYPRE_IJVectorGetObject(b, (void **) &parb);

  HYPRE_IJVectorCreate(comm, ilower, iupper, &x);
  HYPRE_IJVectorSetObjectType(x, HYPRE_PARCSR);
  HYPRE_IJVectorInitialize(x);
  HYPRE_IJVectorAssemble(x);
  HYPRE_IJVectorGetObject(x, (void **) &parx);

  HYPRE_ParCSRPCGCreate(comm, &solver);
  HYPRE_BoomerAMGCreate(&precond);
  HYPRE_ParCSRPCGSetPrecond(solver, HYPRE_BoomerAMGSolve, HYPRE_BoomerAMGSetup, precond);
  HYPRE_ParCSRPCGSetup(solver, parA, parb, parx);
  HYPRE_ParCSRPCGSolve(solver, parA, parb, parx);

  HYPRE_BoomerAMGDestroy(precond);
  HYPRE_ParCSRPCGDestroy(solver);
  HYPRE_IJVectorDestroy(x);
  HYPRE_IJVectorDestroy(b);
  HYPRE_IJMatrixDestroy(A);
  HYPRE_Finalize();
  MPI_Finalize();
  return 0;
}
