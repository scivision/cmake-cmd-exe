cmake_minimum_required(VERSION 3.20)

project(AddCustomFakeCmd LANGUAGES CXX)

include(${CMAKE_CURRENT_LIST_DIR}/../fake_cmd/fake_cmd.cmake)

execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} --version
OUTPUT_VARIABLE gen_ver)
string(REGEX REPLACE "\n" ";" gen_ver "${gen_ver}")
list(GET gen_ver 0 gen_ver)
message(STATUS "${CMAKE_GENERATOR} ${gen_ver}")

# specifying $ENV{COMSPEC} vs. "cmd" does not help Ninja
add_custom_command(TARGET fake_cmd POST_BUILD
COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:fake_cmd> ${CMAKE_CURRENT_BINARY_DIR}/cmd.exe
COMMAND cmd /c echo "Post build"
VERBATIM
)

# this didn't make Makefile fail
# WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
