# CTest add_test(): vulnerable to local cmd.exe

Despite other issues with [cmd.exe escaping](https://gitlab.kitware.com/cmake/cmake/-/issues/16321), if cmd.exe is used, local cmd.exe is preferred over %COMSPEC%.
