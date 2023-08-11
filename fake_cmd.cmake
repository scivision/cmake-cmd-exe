include_guard()

if(TARGET fake_cmd)
  return()
endif()

set(CMAKE_CXX_STANDARD 20)

configure_file(${CMAKE_CURRENT_LIST_DIR}/fake_cmd.cxx.in fake_cmd.cxx @ONLY)

add_executable(fake_cmd fake_cmd.cxx)
