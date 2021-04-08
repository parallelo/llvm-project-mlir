cmake_minimum_required(VERSION 2.8.4)

# Set policy CMP0057 to support IN_LIST operators
cmake_policy(SET CMP0057 NEW)

# Set up the build for the MLIR git-submodule
include(cmake/mlir.cmake)

# Set up the build for the official MLIR 'standalone' example
add_subdirectory(mlir-standalone-example)

# Set up the build for the MLIR MIOpen dialect
add_subdirectory(mlir)
