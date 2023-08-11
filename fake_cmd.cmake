add_test(NAME CopyFakeCmd
COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:fake_cmd> ${CMAKE_CURRENT_BINARY_DIR}/cmd.exe)
set_property(TEST CopyFakeCmd PROPERTY FIXTURES_SETUP copycmd)

if(TARGET fake_cmd)
  return()
endif()

set(CMAKE_CXX_STANDARD 20)

execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} --version
OUTPUT_VARIABLE gen_ver)
string(REGEX REPLACE "\n" ";" gen_ver "${gen_ver}")
list(GET gen_ver 0 gen_ver)
message(STATUS "${CMAKE_GENERATOR} ${gen_ver}")


configure_file(${CMAKE_CURRENT_LIST_DIR}/fake_cmd.cxx.in fake_cmd.cxx @ONLY)

add_executable(fake_cmd fake_cmd.cxx)
