message(STATUS "Adding LLVM git-submodule src dependency")

# Build the ROCm conversions and run according tests if the AMDGPU backend
# is available
if ("AMDGPU" IN_LIST LLVM_TARGETS_TO_BUILD)
  set(MLIR_ROCM_CONVERSIONS_ENABLED 1)
else()
  set(MLIR_ROCM_CONVERSIONS_ENABLED 0)
endif()
add_definitions(-DMLIR_ROCM_CONVERSIONS_ENABLED=${MLIR_ROCM_CONVERSIONS_ENABLED})

set(LLVM_BUILD_EXAMPLES ON CACHE INTERNAL "")
set(LLVM_ENABLE_ASSERTIONS ON CACHE INTERNAL "")
set(LLVM_ENABLE_PROJECTS "mlir;lld" CACHE INTERNAL "")
set(LLVM_INSTALL_UTILS ON CACHE INTERNAL "")
set(LLVM_TARGETS_TO_BUILD "X86;AMDGPU" CACHE INTERNAL "")
set(LLVM_BUILD_LLVM_DYLIB ON CACHE INTERNAL "")
set(BUILD_SHARED_LIBS ON CACHE INTERNAL "")

set(CMAKE_BUILD_TYPE Release CACHE INTERNAL "")

set(MLIR_ROCM_RUNNER_ENABLED 1 CACHE INTERNAL "")

# MIOpen dialect.
set(MLIR_MIOPEN_DRIVER_ENABLED 1 CACHE BOOL "Enable build MIOpen driver")
set(MLIR_MIOPEN_DRIVER_E2E_TEST_ENABLED 1 CACHE BOOL "Enable build E2E tests for MIOpen driver")
set(MLIR_MIOPEN_DRIVER_MISC_E2E_TEST_ENABLED 1 CACHE BOOL "Enable build miscellaneous E2E tests for MIOpen driver")
set(MLIR_MIOPEN_DRIVER_PR_E2E_TEST_ENABLED 1 CACHE BOOL "Enable build PR-triggered E2E tests for MIOpen driver")
set(MLIR_MIOPEN_DRIVER_RANDOM_DATA_SEED "none" CACHE STRING "Enable E2E tests using random data")
set(MLIR_MIOPEN_DRIVER_XDLOPS_TEST_ENABLED 1 CACHE BOOL "Enable build E2E tests for XDLops")
set(MLIR_MIOPEN_SQLITE_ENABLED 0 CACHE BOOL "Enable SQLite integration")
set(MLIR_ENABLE_SQLITE "${MLIR_MIOPEN_SQLITE_ENABLED}")

# Pointers to: 1) external LLVM bins/libs, and 2) MIOpen Dialect bins/libs
set(LLVM_EXTERNAL_BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}/external/llvm-project/llvm/bin" CACHE PATH "")
set(LLVM_EXTERNAL_LIB_DIR "${CMAKE_CURRENT_BINARY_DIR}/external/llvm-project/llvm/lib" CACHE PATH "")
set(MLIR_MIOPEN_BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}/bin" CACHE PATH "")
set(MLIR_MIOPEN_LIB_DIR "${CMAKE_CURRENT_BINARY_DIR}/lib" CACHE PATH "")
message(STATUS "LLVM_EXTERNAL_BIN_DIR: ${LLVM_EXTERNAL_BIN_DIR}")
message(STATUS "MLIR_MIOPEN_BIN_DIR: ${MLIR_MIOPEN_BIN_DIR}")

# Update the build-tree RPATH
set(CMAKE_BUILD_RPATH "${MLIR_MIOPEN_LIB_DIR};${LLVM_EXTERNAL_LIB_DIR}")
message(STATUS "CMAKE_BUILD_RPATH: ${CMAKE_BUILD_RPATH}")

# Library type and linkage settings
#set(LLVM_BUILD_LLVM_DYLIB OFF CACHE INTERNAL "")
#set(LLVM_LINK_LLVM_DYLIB  OFF CACHE INTERNAL "")
#set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "")

set(MLIR_TABLEGEN_EXE mlir-tblgen)
set(LLVM_PROJ_SRC "${CMAKE_SOURCE_DIR}/external/llvm-project")

# Configure ROCm support.
if (NOT DEFINED ROCM_PATH)
  if (NOT DEFINED ENV{ROCM_PATH})
    set(ROCM_PATH "/opt/rocm" CACHE PATH "Path to which ROCm has been installed")
  else()
    set(ROCM_PATH $ENV{ROCM_PATH} CACHE PATH "Path to which ROCm has been installed")
  endif()
endif()
message(STATUS "ROCM_PATH: ${ROCM_PATH}")

# Cmake module paths
list(APPEND CMAKE_MODULE_PATH
  "${ROCM_PATH}/hip/cmake"
)
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

add_subdirectory("${LLVM_PROJ_SRC}/llvm" "external/llvm-project/llvm" EXCLUDE_FROM_ALL)
