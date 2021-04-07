cmake_minimum_required(VERSION 2.8.4)

# set policy CMP0057 to support IN_LIST operators
cmake_policy(SET CMP0057 NEW)

include(cmake/mlir.cmake)

add_subdirectory(mlir-standalone-example)

#add_subdirectory(mlir)
