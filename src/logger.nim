import std/logging

let logger* = newConsoleLogger(fmtStr="[$time] - $levelname: ")
proc info* (args: varargs[string]):void = logger.log lvlInfo, args
proc debug* (args: varargs[string]):void = logger.log lvlDebug, args
proc error* (args: varargs[string]):void = logger.log lvlError, args
