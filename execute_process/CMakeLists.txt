cmake_minimum_required(VERSION 3.20)

project(ExeProcFakeCmd LANGUAGES CXX)

enable_testing()

# arbitrary test dir
set(wd $ENV{TEMP})
set(fake_cmd ${wd}/cmd.exe)

include(${CMAKE_CURRENT_LIST_DIR}/../fake_cmd/fake_cmd.cmake)

add_test(NAME CopyFakeCmd
COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:fake_cmd> ${CMAKE_CURRENT_BINARY_DIR}/cmd.exe)
set_property(TEST CopyFakeCmd PROPERTY FIXTURES_SETUP copycmd)

add_test(NAME FakeCmdEcho
COMMAND ${CMAKE_COMMAND} -Dwd:PATH=${CMAKE_CURRENT_BINARY_DIR}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/test_cmd.cmake
)

add_test(NAME SaferCmdEcho
COMMAND ${CMAKE_COMMAND} -Dwd:PATH=${CMAKE_CURRENT_BINARY_DIR}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/safer_cmd.cmake
)

set_property(TEST FakeCmdEcho SaferCmdEcho PROPERTY PASS_REGULAR_EXPRESSION "out: hello")
set_property(TEST FakeCmdEcho SaferCmdEcho PROPERTY FIXTURES_REQUIRED copycmd)
