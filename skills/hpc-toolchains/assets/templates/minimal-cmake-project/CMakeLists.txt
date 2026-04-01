cmake_minimum_required(VERSION 3.18)
project(hpc_toolchain_smoke LANGUAGES C CXX)

find_package(MPI REQUIRED)

add_executable(hello_mpi main.cpp)
target_link_libraries(hello_mpi PRIVATE MPI::MPI_CXX)
target_compile_features(hello_mpi PRIVATE cxx_std_17)
