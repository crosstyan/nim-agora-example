import agora
import gintro/[gtk4, gst, gstapp, gobject, glib, gstbase]
import std/os
import std/parsecfg as cfg
import std/[strutils, streams]
import std/strformat
import logger
import callbacks

# TODO: try https://github.com/pmunch/futhark
# DEBUG: https://nim-lang.org/blog/2017/10/02/documenting-profiling-and-debugging-nim-code.html
# I have do it by hands...
type GDestroyNotify = proc(instance: pointer): void {.cdecl.}

type GstAppSinkCallbacks {.bycopy, completeStruct.} = object
  eos*: proc(appSink: ptr AppSink00, userData: pointer): void {.cdecl.}
  new_preroll*: proc(appSink: ptr AppSink00;
      userData: pointer): FlowReturn {.cdecl.}
  new_sample*: proc(appSink: ptr AppSink00;
      userData: pointer): FlowReturn {.cdecl.}
  new_event*: proc(appSink: ptr AppSink00, userData: pointer): bool {.cdecl.}
  gst_reserved {.importc: "_gst_reserved".}: pointer

proc gst_app_sink_set_callbacks*(sink: pointer,
    callbacks: ptr GstAppSinkCallbacks, userData: pointer,
    notify: GDestroyNotify) {.importc, dynlib: "libgstapp-1.0.so.0".}

# I have no IDEA why gintrop can't generate the bindings for pullSample
# If your pullSample works please delete this function
# Maybe relate to https://github.com/StefanSalewski/gintro/issues/108
proc gst_app_sink_pull_sample*(sink: pointer): ptr Sample00 {.importc, dynlib: "libgstapp-1.0.so.0".}

proc pullSample*(self: AppSink): Sample =
  let pSample = gst_app_sink_pull_sample(self.impl)
  let sample = new(Sample)
  sample.impl = pSample
  return sample

proc panicWhenErr(code: int, what: string): void =
  if code != 0:
    let explain = $agora.rtc_err_2_str(code.cint)
    raise newException(Defect, fmt"{what} error with {code}: {explain}")
  else:
    debug fmt"{what} success"

proc logWhenErr(code: int, what: string): void =
  if code != 0:
    let explain = $agora.rtc_err_2_str(code.cint)
    error fmt"{what} error with {code}: {explain}"

type
  NewSampleParams = object
    connId: uint32
    videoInfo: ptr video_frame_info_t

# This callback is never called?
# https://forum.nim-lang.org/t/702
# https://forum.nim-lang.org/t/7838
# invoke your callback from another thread needs to step up gc
# https://forum.nim-lang.org/t/1488
# https://forum.nim-lang.org/t/6169
proc newSampleCallback(sink: ptr AppSink00;
    xdata: pointer): gst.FlowReturn {.cdecl.} =
  system.setupForeignThreadGc()
  let param = cast[ptr NewSampleParams](xdata)[]
  let sinkObj = new(AppSink)
  sinkObj.impl = sink
  # I don't have `connect` and `pullSample` function
  # Why? Because I don't have GTK?
  # Just import dummygtk and you'll be right
  let sample = sinkObj.pullSample()
  let buf = sample.getBuffer().copy()
  let mem = buf.getAllMemory()
  var info = new(MapInfo)
  let success = mem.map(info[], {gst.MapFlag.read})
  defer:
    if success: mem.unmap(info[])
  if success:
    let code = agora.rtc_send_video_data(param.connId.connection_id_t,
        info.data, info.size.uint, param.videoInfo)
    logWhenErr code, "send video data"
    if code != 0:
      stdout.write "*"
      stdout.flushFile()
  return gst.FlowReturn.ok

# See also
# https://github.com/StefanSalewski/gintro/blob/f4113ebab7b71c078e4ae57c380bcb8e9863abe9/examples/gtk3/appsink_src.nim
# I guess I don't have to release the memory called with C library?
# https://forum.nim-lang.org/t/6216
proc main =
  const appId = "3759fd9101e04094869e7e69b9b3fe64"
  const appToken = "007eJxTYNCS+S8xfY2HooNatUuQ0ozOxTdupP4+JWRyrHtF7PpnWb8UGIzNTS3TUiwNDQxTDUwMLE0szCxTzVPNLJMsk4zTUs1Mri3jSQ79wZu8KDmYiZEBAkF8FoaS1OISBgYAPssg7A=="
  const channelName = "test"
  const uid: uint32 = 1234
  const logPath = "logs"
  const pipeline = """
        videotestsrc name=src is-live=true ! 
        clockoverlay ! 
        videoconvert ! 
        x264enc ! 
        appsink name=agora
  """
  let version = $agora.rtc_get_version()
  let gstVersion = gst.versionString()
  info "Agora version ", version
  info gstVersion

  # I'm not sure whether this need to deinit
  # seems not
  gst.init()
  let pipe = gst.parseLaunch(pipeline)

  # https://nim-lang.org/docs/manual.html#types-set-type
  # whether the handler should be called before or after the default handler of the signal.

  let home = os.getHomeDir()
  let certPath = os.joinPath(home, "certificate.bin")
  debug "certification is located in ", certPath
  let certFile = open(certPath, fmRead)
  let certContent = readAll(certFile)
  debug "Cert length: ", $certContent.len

  var err = 0;
  # The syntax for type conversions is destination_type(expression_to_convert)
  err = agora.rtc_license_verify(certContent.cstring, certContent.len.cint, nil, 0)
  panicWhenErr err, "license verify"

  let handlers = getDefaultHandler()
  let logCfg = create(agora.log_config_t)

  logCfg.log_disable = false
  logCfg.log_disable_desensitize = true
  logCfg.log_level = agora.RTC_LOG_DEBUG
  logCfg.log_path = logPath.cstring

  let serviceOption = create(agora.rtc_service_option_t)
  serviceOption.area_code = AREA_CODE_CN.uint32
  # `[]` is dereference operator (what?)
  serviceOption.log_cfg = logCfg[]

  err = agora.rtc_init(appId.cstring, handlers, serviceOption)
  panicWhenErr err, "init"
  defer:
    err = agora.rtc_fini()
    panicWhenErr err, "fini"

  let pConnId: ptr uint32 = create(uint32)
  err = agora.rtc_create_connection(pConnId)
  panicWhenErr err, "create connection"
  let connId: uint32 = pConnId[]
  defer:
    err = agora.rtc_destroy_connection(connId)
    panicWhenErr err, "destroy connection"

  let codecOpts = create(agora.audio_codec_option_t)
  codecOpts.audio_codec_type = agora.AUDIO_CODEC_DISABLED
  codecOpts.pcm_sample_rate = 0
  codecOpts.pcm_channel_num = 0
  let chanOpts = create(agora.rtc_channel_options_t)
  chanOpts.auto_subscribe_audio = false
  chanOpts.auto_subscribe_video = false
  chanOpts.subscribe_local_user = false
  chanOpts.enable_audio_jitter_buffer = false
  chanOpts.enable_audio_mixer = false
  chanOpts.audio_codec_opt = codecOpts[]
  chanOpts.enable_aut_encryption = false
  # the problem is this line with join channel
  err = agora.rtc_join_channel(connId, channelName.cstring, uid,
      appToken.cstring, chanOpts)
  panicWhenErr err, "join channel"
  defer:
    err = agora.rtc_leave_channel(connId)
    panicWhenErr err, "leave channel"

  let videoInfo = create(agora.video_frame_info_t)
  videoInfo.data_type = agora.VIDEO_DATA_TYPE_H264
  videoInfo.stream_type = agora.VIDEO_STREAM_LOW
  videoInfo.frame_type = agora.VIDEO_FRAME_AUTO_DETECT
  # 0 means auto detect which is not defined in the header
  videoInfo.frame_rate = (0).video_frame_rate_e

  let params = create(NewSampleParams)
  params.connId = connId
  params.videoInfo = videoInfo

  let appSink = cast[Bin](pipe).getByName("agora")
  # In theory signal should work as well but it doesn't
  let appSinkCb = create(GstAppSinkCallbacks)
  appSinkCb.new_sample = newSampleCallback
  # https://stackoverflow.com/questions/66008157/how-to-get-h264-frames-via-gstreamer
  # connect(appSink, "new-sample", newSampleCallback, params)
  # discard cast[AppSink](appSink).scNewSample(newSampleCallback, params, {ConnectFlag.after})
  # https://gstreamer.freedesktop.org/documentation/tutorials/basic/debugging-tools.html?gi-language=c
  # discard g_signal_connect_data(appSink.impl, "new-sample", cast[GCallback](
  #     newSampleCallback), params, nil, {ConnectFlag.after})
  gst_app_sink_set_callbacks(appSink.impl, appSinkCb, params, nil)
  discard pipe.setState(State.playing)
  defer:
    discard pipe.setState(State.null)
  # I have to handle Ctrl+C to exit loop
  let loop = glib.newMainLoop(nil, false)
  glib.run(loop)

when isMainModule:
  main()

