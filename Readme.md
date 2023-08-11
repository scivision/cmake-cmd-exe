# CMake build generation vulnerability to local cmd.exe

For Windows systems, a similar proof of concept motivated a similar change in [Python 3.11.3](https://github.com/python/cpython/issues/101283) subprocess module.

Threat model ingredients:

1. other program periodically [scans filesystem for CMakeCache.txt](./cmake_cache_find.cxx) and drops malicious cmd.exe there, waiting for next time user executes CMake-generated build system to run "bad" cmd.exe.
2. user with signed source tarball that trusts their compiler & CMake assumes the binary doesn't need to be checked (not a good assumption!). The binary could be manipulated by bad cmd.exe that (1) copied in as generated from add_custom_command()

Categories of vulnerability to CMake users on Windows systems due to invocation of cmd.exe include:

1. [add_custom_command](https://github.com/scivision/cmake-cmd-exe/tree/main/add_custom_command) that invokes cmd.exe
2. [execute_process](https://github.com/scivision/cmake-cmd-exe/tree/main/execute_process) that invokes cmd.exe
3. [add_test](https://github.com/scivision/cmake-cmd-exe/tree/main/add_test)

I tested this using the CMake executable downloaded from GitHub.
Same symptoms with MSYS2-patched CMake.
I give examples in each directory.
In a real-world malicious case, the "cmd.exe" would possibly NOT be generated by the same project, but would already be sitting there with the malicious CMakeCache.txt finder and copying cmd.exe to those directories and waiting for the user to make their next build to have the bad cmd.exe run.

## MinGW Makefiles

With mingw32-make.exe despite Makefile having "SHELL = cmd.exe" set in each Makefile as per CMake source code may be overriding "cmd.exe" with %COMSPEC%.
I didn't check this in GNU Make source, but GNU Make seems to behave this way.
GNU Make ignores "cmd.exe" in the working directory.

Still, CMake should put %COMSPEC% instead of cmd.exe for SHELL.

## Ninja and Visual Studio

Generators Visual Studio and Ninja fail--they use cmd.exe in the working directory, even if you try to tell them to use %COMSPEC%, they ignore that and use working directory cmd.exe.

Ninja uses "cmd.exe /c" extensively in build.ninja, as generated by CMake. Ninja build generated by CMake are therefore vulnerable to a possibly malicious "cmd.exe" placed in PROJECT_BINARY_DIR.

The "cmd.exe" for build.ninja comes from cmLocalNinjaGenerator::BuildCommandLine() in
[Source/cmLocalNinjaGenerator.cxx](https://gitlab.kitware.com/cmake/cmake/-/blob/master/Source/cmLocalNinjaGenerator.cxx#L547).
If this line were changed to use %COMSPEC%\cmd.exe as in Python 3.11.3, the vulnerability is mitigated.

If CMake source were modified to use the full path to cmd.exe w.r.t. build.ninja generation, one would need to use care about possibly
[too long command lines](https://gitlab.kitware.com/cmake/cmake/-/merge_requests/24)
and
[CMAKE_NINJA_FORCE_RESPONSE_FILE](https://gitlab.kitware.com/cmake/cmake/-/blob/master/Source/cmNinjaTargetGenerator.cxx#L1872)

## Testing

We use CTest to orchestrate the tests, though the failures also occur without using CTest.
These tests fail, but should pass if local cmd.exe were ignored as we request.

We tested with Visual Studio 2022, Intel oneAPI 2023.2, and MinGW GCC 13.2.0 and got the same results for each.

* FakeCmd
* FakeCmdEcho

These tests pass due to ignoring local cmd.exe:

* SaferCmdEcho  (sets environment variable `NoDefaultCurrentDirectoryInExePath=1`)

```sh
del /s /q build && cmake -Bbuild && cmake --build build && ctest --test-dir build -V
```
