cmake_minimum_required(VERSION 2.8.4)

# Set policy CMP0057 to support IN_LIST operators
cmake_policy(SET CMP0057 NEW)

#set (git_cmd "git")
#set (git_arg "status" "--help")
#message(STATUS "git cmd: ${git_cmd}")
#execute_process(COMMAND ${git_cmd} ${git_arg})

# Python's diff_match_patch package is currently required to
# patch external/llvm-project
execute_process(
  COMMAND pip show diff_match_patch
  RESULT_VARIABLE EXIT_CODE
  OUTPUT_QUIET
)

# Python's pathlib2 package is currently required to
# patch external/llvm-project
execute_process(
  COMMAND pip show pathlib2
  RESULT_VARIABLE EXIT_CODE
  OUTPUT_QUIET
)

if (NOT ${EXIT_CODE} EQUAL 0)
  message(
    FATAL_ERROR
      "The \"diff_match_patch\" python package is not installed. \
       The following command can be used to install it: \
       \"pip install diff_match_patch\""
  )
endif()

# Patch 'external/llvm-project/mlir' with mods in 'mlir-patch'
# FIXME: multi-line cmd + args...
#set(PY_CMD "python utils/src-tree-patcher/patcher.py ")
#set(PY_ARG1 "--infile utils/src-tree-patcher/filelist.txt ")
#set(PY_ARG2 "--srcdir mlir-patch ")
#set(PY_ARG3 "--dstdir external/llvm-project/mlir")
#set(PY_ARGS ${PY_ARG1} ${PY_ARG2} ${PY_ARG3})
#execute_process(COMMAND ${PY_CMD} ${PY_ARGS}
execute_process(COMMAND python utils/src-tree-patcher/patcher.py --infile utils/src-tree-patcher/filelist.txt --srcdir mlir-patch --dstdir external/llvm-project/mlir
  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})

# Set up the build for the MLIR git-submodule
include(cmake/mlir.cmake)

# Set up the build for the official MLIR 'standalone' example
#add_subdirectory(mlir-standalone-example)

# Set up the build for the MLIR MIOpen dialect
add_subdirectory(mlir)
