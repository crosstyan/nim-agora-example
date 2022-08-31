import logger
import std/strformat
import agora



proc on_join_channel_success*(conn_id: connection_id_t; uid: uint32;
    elapsed_ms: cint) {.cdecl.} =
  system.setupForeignThreadGc()
  info "[Agora] ", "join channel success"

proc on_connection_lost*(conn_id: connection_id_t) {.cdecl.} =
  system.setupForeignThreadGc()
  error "[Agora] ", "connection lost"

proc on_rejoin_channel_success*(conn_id: connection_id_t; uid: uint32;
    elapsed_ms: cint) {.cdecl.} =
  system.setupForeignThreadGc()
  info "[Agora] ", "rejoin channel success"

proc on_error*(conn_id: connection_id_t; code: cint; msg: cstring) {.cdecl.} =
  system.setupForeignThreadGc()
  error fmt"[Agora] {$msg} ({$code})"

# https://ssalewski.de/nimprogramming.html#_allocating_objects
# Remember to dealloc it
# Error: 'sizeof' requires '.importc' types to be '.completeStruct'
# https://forum.nim-lang.org/t/7180
# https://github.com/nimterop/nimterop/issues/276
# isn't completeStruct the default?
# `incompleteStruct` has been deprecated, every object is now an
# `incompleteStruct` unless `completeStruct` is specified.

# invoke your callback from another thread needs to step up gc
# https://forum.nim-lang.org/t/702
# https://forum.nim-lang.org/t/7838
# https://forum.nim-lang.org/t/1488
# https://forum.nim-lang.org/t/6169
proc getDefaultHandler*(): ptr rtc_event_handler_t =
  result = create(rtc_event_handler_t)
  result.on_join_channel_success = on_join_channel_success
  result.on_connection_lost = on_connection_lost
  result.on_rejoin_channel_success = on_rejoin_channel_success
  result.on_error = on_error
  # other fields are nil
  return result
