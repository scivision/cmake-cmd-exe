cmake_minimum_required(VERSION 3.20)

project(AddCustomFakeCmd LANGUAGES CXX)

include(${CMAKE_CURRENT_SOURCE_DIR}/../fake_cmd.cmake)

# specifying $ENV{COMSPEC} vs. "cmd" does not help Ninja
add_custom_command(TARGET fake_cmd POST_BUILD
COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:fake_cmd> ${CMAKE_CURRENT_BINARY_DIR}/cmd.exe
COMMAND cmd /c echo "Post build"
VERBATIM
)

# this didn't make Makefile fail
# WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
