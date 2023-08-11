execute_process(COMMAND cmd /c echo "hello"
OUTPUT_VARIABLE out
ERROR_VARIABLE err
RESULT_VARIABLE ret
WORKING_DIRECTORY ${wd}
# COMMAND_ECHO STDOUT
)

message(STATUS "out: ${out}
err: ${err}
ret: ${ret}")
