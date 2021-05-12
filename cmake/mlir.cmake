message(STATUS "Adding LLVM git-submodule src dependency")

# Build the ROCm conversions and run according tests if the AMDGPU backend
# is available
if ("AMDGPU" IN_LIST LLVM_TARGETS_TO_BUILD)
  set(MLIR_ROCM_CONVERSIONS_ENABLED 1)
else()
  set(MLIR_ROCM_CONVERSIONS_ENABLED 0)
endif()
add_definitions(-DMLIR_ROCM_CONVERSIONS_ENABLED=${MLIR_ROCM_CONVERSIONS_ENABLED})

# MIOpen dialect.
set(MLIR_MIOPEN_DRIVER_ENABLED 1 CACHE BOOL "Enable build MIOpen driver")
set(MLIR_MIOPEN_DRIVER_E2E_TEST_ENABLED 1 CACHE BOOL "Enable build E2E tests for MIOpen driver")
set(MLIR_MIOPEN_DRIVER_MISC_E2E_TEST_ENABLED 1 CACHE BOOL "Enable build miscellaneous E2E tests for MIOpen driver")
set(MLIR_MIOPEN_DRIVER_PR_E2E_TEST_ENABLED 1 CACHE BOOL "Enable build PR-triggered E2E tests for MIOpen driver")
set(MLIR_MIOPEN_DRIVER_RANDOM_DATA_SEED "none" CACHE STRING "Enable E2E tests using random data")
set(MLIR_MIOPEN_DRIVER_XDLOPS_TEST_ENABLED 1 CACHE BOOL "Enable build E2E tests for XDLops")
set(MLIR_MIOPEN_SQLITE_ENABLED 1 CACHE BOOL "Enable SQLite integration")


set(LLVM_ENABLE_PROJECTS "mlir;lld" CACHE INTERNAL "")
set(LLVM_BUILD_EXAMPLES ON CACHE INTERNAL "")
set(LLVM_TARGETS_TO_BUILD "X86;AMDGPU" CACHE INTERNAL "")
set(CMAKE_BUILD_TYPE Release CACHE INTERNAL "")
set(LLVM_ENABLE_ASSERTIONS ON CACHE INTERNAL "")
set(BUILD_SHARED_LIBS ON CACHE INTERNAL "")
set(LLVM_BUILD_LLVM_DYLIB ON CACHE INTERNAL "")
set(MLIR_ROCM_RUNNER_ENABLED 1 CACHE INTERNAL "")
set(MLIR_MIOPEN_DRIVER_ENABLED 1 CACHE INTERNAL "")
set(MLIR_ENABLE_SQLITE 1 CACHE INTERNAL "")
set(LLVM_INSTALL_UTILS ON CACHE INTERNAL "")

# Library type and linkage settings
#set(LLVM_BUILD_LLVM_DYLIB OFF CACHE INTERNAL "")
#set(LLVM_LINK_LLVM_DYLIB  OFF CACHE INTERNAL "")
#set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "")

set(MLIR_TABLEGEN_EXE mlir-tblgen)
set(LLVM_PROJ_SRC "${CMAKE_SOURCE_DIR}/external/llvm-project")

add_subdirectory("${LLVM_PROJ_SRC}/llvm" "external/llvm-project/llvm" EXCLUDE_FROM_ALL)

# Cmake module paths
list(APPEND CMAKE_MODULE_PATH
  "${CMAKE_CURRENT_BINARY_DIR}/lib/cmake/mlir"
)
list(APPEND CMAKE_MODULE_PATH
  "${CMAKE_CURRENT_BINARY_DIR}/external/llvm-project/llvm/lib/cmake/llvm/"
)

# Include dirs for MLIR and LLVM
list(APPEND MLIR_INCLUDE_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}/external/llvm-project/mlir/include
  ${CMAKE_CURRENT_BINARY_DIR}/external/llvm-project/llvm/tools/mlir/include
)
list(APPEND LLVM_INCLUDE_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}/external/llvm-project/llvm/include
  ${CMAKE_CURRENT_BINARY_DIR}/external/llvm-project/llvm/include
)

# Linker flags
list(APPEND CMAKE_EXE_LINKER_FLAGS
  " -Wl,-rpath -Wl,${CMAKE_CURRENT_BINARY_DIR}/external/llvm-project/llvm/lib"
)
