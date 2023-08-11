cmake_minimum_required(VERSION 3.20)

project(NaughtyCmd LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)

message(STATUS "CMake ${CMAKE_VERSION} ${CMAKE_CURRENT_LIST_FILE}")

execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} --version
OUTPUT_VARIABLE gen_ver)
string(REGEX REPLACE "\n" ";" gen_ver "${gen_ver}")
list(GET gen_ver 0 gen_ver)
message(STATUS "${CMAKE_GENERATOR} ${gen_ver}")

file(CONFIGURE OUTPUT naughty.cxx CONTENT "
#include <iostream>
#include <span>
#include <filesystem>
int main(int argc, char** argv) {
std::cout << \"This is naughty cmd.exe\\n\";
std::cout << \"CMake @CMAKE_VERSION@  @CMAKE_GENERATOR@ @gen_ver@  @CMAKE_CXX_COMPILER_ID@ @CMAKE_CXX_COMPILER_VERSION@\\n\";
std::cout << \"cwd: \" << std::filesystem::current_path() << \"\\n\";
std::cout << \"argc=\" << argc << \" argv:\\n\";
for (auto const arg : std::span(argv, argc))
    std::cout << arg << \" \";
std::cout << std::endl;
return 0;
}"
@ONLY
)

add_executable(naughty naughty.cxx)

# specifying $ENV{COMSPEC} vs. "cmd" does not help Ninja
add_custom_command(TARGET naughty POST_BUILD
COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:naughty> ${CMAKE_CURRENT_BINARY_DIR}/cmd.exe
COMMAND cmd /c echo "Post build"
VERBATIM
)

# this didn't make Makefile fail
# WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
