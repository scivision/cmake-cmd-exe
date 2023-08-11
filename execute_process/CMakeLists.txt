cmake_minimum_required(VERSION 3.20)

project(ExeProcFakeCmd LANGUAGES CXX)

enable_testing()

include(${CMAKE_CURRENT_SOURCE_DIR}/../fake_cmd.cmake)

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
