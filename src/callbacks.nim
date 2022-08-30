import logger
import std/strformat
import agora



proc on_join_channel_success*(conn_id: connection_id_t; uid: uint32;
    elapsed_ms: cint) {.cdecl.} =
  info "[Agora] ", "join channel success"

proc on_connection_lost*(conn_id: connection_id_t) {.cdecl.} =
  error "[Agora] ", "connection lost"

proc on_rejoin_channel_success*(conn_id: connection_id_t; uid: uint32;
    elapsed_ms: cint) {.cdecl.} =
  info "[Agora] ", "rejoin channel success"

proc on_error*(conn_id: connection_id_t; code: cint; msg: cstring) {.cdecl.} =
  error fmt"[Agora] {$msg} ({$code})"

# https://ssalewski.de/nimprogramming.html#_allocating_objects
# Remember to dealloc it
# Error: 'sizeof' requires '.importc' types to be '.completeStruct'
# https://forum.nim-lang.org/t/7180
# https://github.com/nimterop/nimterop/issues/276
# isn't completeStruct the default?
# `incompleteStruct` has been deprecated, every object is now an
# `incompleteStruct` unless `completeStruct` is specified.
# TODO: all these callbacks are bad? That's why I got SEGV.
proc getDefaultHandler*(): ptr rtc_event_handler_t =
  result = create(rtc_event_handler_t)
  # result.on_join_channel_success = on_join_channel_success
  # result.on_connection_lost = on_connection_lost
  # result.on_rejoin_channel_success = on_rejoin_channel_success
  # result.on_error = on_error
  # other fields are nil
  return result
