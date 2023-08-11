include_guard()

if(TARGET fake_cmd)
  return()
endif()

set(CMAKE_CXX_STANDARD 20)

configure_file(${CMAKE_CURRENT_LIST_DIR}/fake_cmd.cxx.in fake_cmd.cxx @ONLY)

add_executable(fake_cmd fake_cmd.cxx)

add_test(NAME CopyFakeCmd
COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:fake_cmd> ${CMAKE_CURRENT_BINARY_DIR}/cmd.exe)
set_property(TEST CopyFakeCmd PROPERTY FIXTURES_SETUP copycmd)
