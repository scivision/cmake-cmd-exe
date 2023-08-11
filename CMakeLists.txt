cmake_minimum_required(VERSION 3.20)

project(FakeCmd LANGUAGES CXX)

enable_testing()

add_subdirectory(add_custom_command)
add_subdirectory(ctest)
add_subdirectory(execute_process)
