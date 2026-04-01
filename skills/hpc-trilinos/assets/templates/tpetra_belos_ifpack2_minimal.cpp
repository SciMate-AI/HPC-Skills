#include <Tpetra_Core.hpp>
#include <Tpetra_CrsMatrix.hpp>
#include <Tpetra_Vector.hpp>
#include <BelosLinearProblem.hpp>
#include <BelosSolverFactory.hpp>
#include <Ifpack2_Factory.hpp>
#include <Teuchos_RCP.hpp>
#include <Teuchos_ParameterList.hpp>

int main(int argc, char **argv)
{
  Tpetra::ScopeGuard scope(&argc, &argv);
  using scalar_type = double;
  using local_ordinal_type = int;
  using global_ordinal_type = long long;
  using map_type = Tpetra::Map<local_ordinal_type, global_ordinal_type>;
  using crs_type = Tpetra::CrsMatrix<scalar_type, local_ordinal_type, global_ordinal_type>;
  using vec_type = Tpetra::Vector<scalar_type, local_ordinal_type, global_ordinal_type>;

  auto comm = Tpetra::getDefaultComm();
  const global_ordinal_type n = 32;
  auto map = Teuchos::rcp(new map_type(n, 0, comm));
  auto A = Teuchos::rcp(new crs_type(map, 3));

  auto local_rows = map->getLocalNumElements();
  auto global_rows = map->getMyGlobalIndices();
  for (size_t i = 0; i < local_rows; ++i) {
    global_ordinal_type row = global_rows[i];
    Teuchos::Array<global_ordinal_type> cols;
    Teuchos::Array<scalar_type> vals;
    if (row > 0) {
      cols.push_back(row - 1);
      vals.push_back(-1.0);
    }
    cols.push_back(row);
    vals.push_back(2.0);
    if (row + 1 < n) {
      cols.push_back(row + 1);
      vals.push_back(-1.0);
    }
    A->insertGlobalValues(row, cols(), vals());
  }
  A->fillComplete();

  auto x = Teuchos::rcp(new vec_type(map));
  auto b = Teuchos::rcp(new vec_type(map));
  b->putScalar(1.0);

  Belos::LinearProblem<scalar_type, vec_type, crs_type> problem(A, x, b);

  Ifpack2::Factory factory;
  auto prec = factory.create<crs_type>("RELAXATION", A);
  Teuchos::ParameterList prec_params;
  prec_params.set("relaxation: type", "Symmetric Gauss-Seidel");
  prec->setParameters(prec_params);
  prec->initialize();
  prec->compute();
  problem.setLeftPrec(prec);
  problem.setProblem();

  Belos::SolverFactory<scalar_type, vec_type, crs_type> solver_factory;
  auto solver = solver_factory.create("CG", Teuchos::parameterList());
  solver->setProblem(Teuchos::rcpFromRef(problem));
  solver->solve();
  return 0;
}
