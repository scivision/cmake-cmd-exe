# add_custom_command(): vulnerable to local cmd.exe

add_custom_command() can use POST_BUILD on a target that if cmd.exe is used, if present will use a local cmd.exe instead of %COMSPEC%.
