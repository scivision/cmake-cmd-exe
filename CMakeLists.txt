cmake_minimum_required(VERSION 3.20)

project(FakeCmd LANGUAGES CXX)

enable_testing()

include(fake_cmd/fake_cmd.cmake)

add_subdirectory(ctest)
add_subdirectory(execute_process)
