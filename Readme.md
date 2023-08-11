# CMake build generation vulnerability to local cmd.exe

For Windows systems, a similar proof of concept motivated a similar change in [Python 3.11.3](https://github.com/python/cpython/issues/101283) subprocess module.

Threat model ingredients:

1. other program periodically scans filesystem for CMakeCache.txt and drops malicious cmd.exe there, waiting for next time user executes CMake-generated build system to run "bad" cmd.exe.
2. user with signed source tarball that trusts their compiler & CMake assumes the binary doesn't need to be checked (not a good assumption!). The binary could be manipulated by bad cmd.exe that (1) copied in as generated from add_custom_command()

Categories of vulnerability to CMake users on Windows systems due to invocation of cmd.exe include:

1. [add_custom_command](./blob/main/add_custom_command/) that invokes cmd.exe
2. execute_process that invokes cmd.exe
3. [CTest test invoking cmd.exe](./blob/main/ctest/)
4. Ninja build generation

I tested this using the CMake executable downloaded from GitHub. Same symptoms with MSYS2-patched CMake.

I discuss each of these in a section below.

## add_custom_command that invokes cmd.exe

GNU Make despite having "SHELL = cmd.exe" set in the Makefiles as per CMake source code may be overriding "cmd.exe" with %COMSPEC%. I didn't check this in GNU Make source, but GNU Make seems to behave this way--GNU Make ignores "cmd.exe" in the working directory.

I made an [example](https://github.com/scivision/cmake-cmd-exe)
of Generators Visual Studio and Ninja failing--they use cmd.exe in the working directory, even if you try to tell them to use %COMSPEC%, they ignore that and use working directory cmd.exe

## execute_process() invoking cmd.exe

This test should always pass, ignoring the fake cmd.exe in the WORKING_DIRECTORY.
However, as-is in CMake 3.27.1 and probably all priors this test fails, showing a possibly malicious cmd.exe in WORKING_DIRECTORY is preferred over system COMSPEC.

Expected result is to twice print:

```
-- out: hello

err:
ret: 0
```

Instead, when a possibly malicious "cmd.exe" is in WORKING_DIRECTORY we get unexpected message below. If this were a malicious cmd.exe in the working_directory, anything bad could happen.

```
-- out:
err:
ret: %1 is not a valid Win32 application
```

```cmake
# arbitrary test dir
set(wd $ENV{TEMP})
set(fake_cmd ${wd}/cmd.exe)

function(test_cmd)
execute_process(COMMAND cmd /c echo "hello"
OUTPUT_VARIABLE out
ERROR_VARIABLE err
RESULT_VARIABLE ret
WORKING_DIRECTORY ${wd}
)

message(STATUS "out: ${out}
err: ${err}
ret: ${ret}
")
endfunction()

function(safer_cmd)
execute_process(COMMAND ${CMAKE_COMMAND} -E env NoDefaultCurrentDirectoryInExePath=1 cmd /c echo "hello"
OUTPUT_VARIABLE out
ERROR_VARIABLE err
RESULT_VARIABLE ret
WORKING_DIRECTORY ${wd}
)

message(STATUS "out: ${out}
err: ${err}
ret: ${ret}
")

endfunction()

file(REMOVE ${fake_cmd})
test_cmd()

file(TOUCH ${fake_cmd})
test_cmd()
# even an invalid (empty!) cmd.exe in the current directory is used over the system cmd.exe

safer_cmd()
# this works as expected, says "hello"
```

## Ninja build generation
Ninja uses "cmd.exe /c" extensively in build.ninja, as generated by CMake. Ninja build generated by CMake are therefore vulnerable to a possibly malicious "cmd.exe" placed in PROJECT_BINARY_DIR.

The "cmd.exe" for build.ninja comes from cmLocalNinjaGenerator::BuildCommandLine() in [Source/cmLocalNinjaGenerator.cxx](https://gitlab.kitware.com/cmake/cmake/-/blob/master/Source/cmLocalNinjaGenerator.cxx#L547).
If this line were changed to use %COMSPEC%\cmd.exe as in Python 3.11.3, the vulnerability is mitigated.

If CMake source were modified to use the full path to cmd.exe w.r.t. build.ninja generation, one would need to use care about possibly too long command lines vis https://gitlab.kitware.com/cmake/cmake/-/merge_requests/24 and [CMAKE_NINJA_FORCE_RESPONSE_FILE](https://gitlab.kitware.com/cmake/cmake/-/blob/master/Source/cmNinjaTargetGenerator.cxx#L1872)
