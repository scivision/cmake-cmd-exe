execute_process(COMMAND ${CMAKE_COMMAND} -E env NoDefaultCurrentDirectoryInExePath=1 cmd /c cd
OUTPUT_VARIABLE out
ERROR_VARIABLE err
RESULT_VARIABLE ret
WORKING_DIRECTORY ${wd}
# COMMAND_ECHO STDOUT
)

message(STATUS "out: ${out}
err: ${err}
ret: ${ret}")
