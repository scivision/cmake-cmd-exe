# execute_process(): vulnerable to local cmd.exe

This test should always pass, ignoring the fake cmd.exe in the WORKING_DIRECTORY.
However, as-is in CMake 3.27.1 and probably all priors this test fails, showing a possibly malicious cmd.exe in WORKING_DIRECTORY is preferred over system COMSPEC.
