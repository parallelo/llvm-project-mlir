llvm_canonicalize_cmake_booleans(
  MLIR_BINDINGS_PYTHON_ENABLED
  LLVM_BUILD_EXAMPLES
  MLIR_CUDA_CONVERSIONS_ENABLED
  MLIR_CUDA_RUNNER_ENABLED
  MLIR_ROCM_CONVERSIONS_ENABLED
  MLIR_ROCM_RUNNER_ENABLED
  MLIR_SPIRV_CPU_RUNNER_ENABLED
  MLIR_VULKAN_RUNNER_ENABLED
  )

# Passed to lit.site.cfg.py.in to set up the path where to find the libraries
# for linalg integration tests.
set(MLIR_DIALECT_LINALG_INTEGRATION_TEST_LIB_DIR ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
set(MLIR_RUNNER_UTILS_DIR ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

# Passed to lit.site.cfg.py.in to set up the path where to find the libraries
# for the mlir cuda / rocm / spirv / vulkan runner tests.
set(MLIR_ROCM_WRAPPER_LIBRARY_DIR ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

message(STATUS "LLVM_EXTERNAL_BIN_DIR: ${LLVM_EXTERNAL_BIN_DIR}")
message(STATUS "MLIR_MIOPEN_BIN_DIR: ${MLIR_MIOPEN_BIN_DIR}")
message(STATUS "MLIR_ROCM_WRAPPER_LIBRARY_DIR: ${MLIR_ROCM_WRAPPER_LIBRARY_DIR}")

set(LLVM_LIT_TOOLS_DIR ${LLVM_EXTERNAL_BIN_DIR})
set(LLVM_TOOLS_DIR ${LLVM_EXTERNAL_BIN_DIR})
set(MLIR_TOOLS_DIR ${LLVM_EXTERNAL_BIN_DIR})
set(MLIR_MIOPEN_TOOLS_DIR ${MLIR_MIOPEN_BIN_DIR})

configure_lit_site_cfg(
  ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
  ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py
  MAIN_CONFIG
  ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py
  )

set(MLIR_TEST_DEPENDS
  FileCheck count not
  mlir-opt
  mlir-opt-miopen
  mlir-reduce
  mlir-translate
  mlir-translate-miopen
  mlir_runner_utils
  mlir_c_runner_utils
  mlir_async_runtime
  )

if(TARGET gtest)
  list(APPEND MLIR_TEST_DEPENDS MLIRUnitTests)
endif()

if(MLIR_ROCM_RUNNER_ENABLED)
  list(APPEND MLIR_TEST_DEPENDS
    mlir-rocm-runner
  )
endif()

if(MLIR_BINDINGS_PYTHON_ENABLED)
  list(APPEND MLIR_TEST_DEPENDS
    MLIRBindingsPythonExtension
    MLIRBindingsPythonTestOps
    MLIRTransformsBindingsPythonExtension
  )
endif()
  
# MIOpen dialect tools.
if(MLIR_MIOPEN_DRIVER_ENABLED)
  list(APPEND MLIR_TEST_DEPENDS
    mlir-miopen-driver
    mlir-miopen-lib-test
    mlir-translate
    opt
    llc
    )
endif()

add_lit_testsuite(check-mlir-miopen "Running the MLIR-MIOpen regression tests"
  ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS ${MLIR_TEST_DEPENDS}
  )
set_target_properties(check-mlir-miopen PROPERTIES FOLDER "Tests")

add_lit_testsuites(MLIR-MIOPEN ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS ${MLIR_TEST_DEPENDS}
)
