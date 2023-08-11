set(CMAKE_CXX_STANDARD 20)

configure_file(naughty.cxx.in naughty.cxx @ONLY)

add_executable(naughty naughty.cxx)
