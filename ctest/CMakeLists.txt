cmake_minimum_required(VERSION 3.20)

project(CTestFakeCmd LANGUAGES CXX)

enable_testing()

include(${CMAKE_CURRENT_SOURCE_DIR}/../fake_cmd.cmake)

add_test(NAME FakeCmd COMMAND cmd /?)
set_property(TEST FakeCmd PROPERTY PASS_REGULAR_EXPRESSION "Starts a new instance of the Windows command interpreter")
set_property(TEST FakeCmd PROPERTY FIXTURES_REQUIRED copycmd)
# known to fail due to https://gitlab.kitware.com/cmake/cmake/-/issues/16321
