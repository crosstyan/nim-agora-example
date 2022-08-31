from agora import rtc_err_2_str
import gintro/[gst, gstapp, gobject, glib, gstbase]
import std/strformat
import logger
import posix

type
  StdSignal* = enum
    SIGHUP = 1       ##  1. Hangup
    SIGINT           ##  2. Terminal interrupt signal

# code from https://gist.github.com/dom96/908782
template onSignal*(sigs: varargs[StdSignal]; actions: untyped): untyped =
  # https://www.gnu.org/software/libc/manual/html_node/Sigaction-Function-Example.html#Sigaction-Function-Example
  proc newHandler(signum: cint) {.noconv.} =
    error "Standard signal " & $StdSignal(signum) & " detected"
    `actions`

  var newAction: SigAction
  newAction.sa_handler = newHandler
  discard sigemptyset(newAction.sa_mask)
  newAction.sa_flags = 0

  for sig in sigs:
    discard sigaction(cint(sig), newAction, nil)

# TODO: try https://github.com/pmunch/futhark
# DEBUG: https://nim-lang.org/blog/2017/10/02/documenting-profiling-and-debugging-nim-code.html
# Useful links
# https://internet-of-tomohiro.netlify.app/nim/gdb.en.html
# https://internet-of-tomohiro.netlify.app/nim/clibrary.en.html
# I have do it by hands...
type GDestroyNotify* = proc(instance: pointer): void {.cdecl.}

type GstAppSinkCallbacks* {.bycopy, completeStruct.} = object
    eos*: proc(appSink: ptr AppSink00, userData: pointer): void {.cdecl.}
    new_preroll*: proc(appSink: ptr AppSink00,
            userData: pointer): FlowReturn {.cdecl.}
    new_sample*: proc(appSink: ptr AppSink00,
            userData: pointer): FlowReturn {.cdecl.}
    new_event*: proc(appSink: ptr AppSink00, userData: pointer): bool {.cdecl.}
    gst_reserved {.importc: "_gst_reserved".}: pointer

proc gst_app_sink_set_callbacks*(sink: pointer,
    callbacks: ptr GstAppSinkCallbacks, userData: pointer,
    notify: GDestroyNotify) {.importc, dynlib: "libgstapp-1.0.so.0".}

# this is a macro in gobject/signal.h, so it can't be linked
# a string of the form "signal-name::detail"
# Returns: the handler ID (always greater than 0 for successful connections)
proc g_signal_connect*(instance: pointer; detailedSignal: cstring;
    cHandler: GCallback, data: pointer; ): culong =
    # https://nim-lang.org/docs/manual.html#types-set-type
    # whether the handler should be called before or after the default handler of the signal.
    return g_signal_connect_data(instance, detailedSignal, cHandler, data, nil,
            {})

# I have no IDEA why gintrop can't generate the bindings for pullSample
# If your pullSample works please delete this function
# Maybe relate to https://github.com/StefanSalewski/gintro/issues/108
proc gst_app_sink_pull_sample*(sink: pointer): ptr Sample00 {.importc,
    dynlib: "libgstapp-1.0.so.0".}

# code from https://github.com/StefanSalewski/gintro/blob/f4113ebab7b71c078e4ae57c380bcb8e9863abe9/examples/gtk3/celldatafunction.nim#L19
proc toBoolVal*(b: bool): Value =
    let gtype = gBooleanGetType() # typeFromName("gboolean")
    discard init(result, gtype)
    setBoolean(result, b)

proc pullSample*(self: AppSink): Sample =
    let pSample = gst_app_sink_pull_sample(self.impl)
    let sample = new(Sample)
    sample.impl = pSample
    return sample

proc panicWhenErr*(code: int, what: string): void =
    if code != 0:
        let explain = $rtc_err_2_str(code.cint)
        raise newException(Defect, fmt"{what} error with {code}: {explain}")
    else:
        debug fmt"{what} success"

proc logWhenErr*(code: int, what: string): void =
    if code != 0:
        let explain = $rtc_err_2_str(code.cint)
        error fmt"{what} error with {code}: {explain}"
