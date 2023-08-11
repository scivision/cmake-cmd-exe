cmake_minimum_required(VERSION 3.20)

project(FakeCmd LANGUAGES CXX)

enable_testing()

set(CMAKE_CXX_STANDARD 20)

add_executable(cmake_cache_find cmake_cache_find.cxx)

add_subdirectory(add_custom_command)
add_subdirectory(add_test)
add_subdirectory(execute_process)

if(NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  file(GENERATE OUTPUT .gitignore CONTENT "*")
endif()
