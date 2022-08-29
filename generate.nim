import os
import strutils
import nimterop/[build, cimport]

static:
  cDebug()

# Several C libraries also use leading and/or trailing _ in identifiers and
# since Nim does not allow this, the cPlugin() macro can be used to modify such
# symbols or cSkipSymbol() them altogether. Instead of a full cPlugin() section,
# it might also be preferred to set flags = "-E_ -F_" to the cImport() call to
# trim out such characters.

# https://nim-lang.org/docs/system.html#currentSourcePath.t
const baseDir = currentSourcePath.parentDir()
# https://github.com/nimterop/nimterop/blob/master/nimterop/cimport.nim
# Pass dynlib if not static link
# By default, generated wrappers will assume that the user will link the library implementation themselves.
cImport(baseDir/"agora_sdk"/"include"/"agora_rtc_api.h", recurse = true,
        flags="-E_ -F_ -E__ -F__ -Eagora_ -EAGORA_ ", # the flags passed to `toast`
        dynlib = baseDir/"agora_sdk"/"lib"/"aarch64"/"libagora-rtc-sdk.so",
        nimFile = baseDir/"src"/"agora.nim"
  )
