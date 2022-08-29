import agora
import gintro/gst
import gintro/gstapp
import gintro/gobject
import std/os
import std/parsecfg as cfg
import std/[strutils, streams]
import std/strformat
import logger
import callbacks

proc panicWhenErr(code: int, what: string):void = 
  if code != 0: 
    let explain = $agora.rtc_err_2_str(code.cint)
    raise newException(Defect, fmt"{what} error with {code}: {explain}")
  else:
    debug fmt"{what} success"


# I guess I don't have to release the memory called with C library?
# https://forum.nim-lang.org/t/6216
proc main = 
  const appId = "3759fd9101e04094869e7e69b9b3fe64"
  const appToken = "007eJxTYNCS+S8xfY2HooNatUuQ0ozOxTdupP4+JWRyrHtF7PpnWb8UGIzNTS3TUiwNDQxTDUwMLE0szCxTzVPNLJMsk4zTUs1Mri3jSQ79wZu8KDmYiZEBAkF8FoaS1OISBgYAPssg7A=="
  const channelName = "test"
  const uid:uint32 = 1234
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
  let appSink = cast[Bin](pipe).getByName("agora")
  proc newSampleCallback(sink: ptr AppSink00; xdata: pointer): gst.FlowReturn {.cdecl.} = return gst.FlowReturn.ok
  # https://nim-lang.org/docs/manual.html#types-set-type
  # whether the handler should be called before or after the default handler of the signal.
  discard cast[AppSink](appSink).scNewSample(newSampleCallback, nil, {ConnectFlag.after})

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
  defer: dealloc(handlers)
  let logCfg = new(agora.log_config_t)
  logCfg.log_disable = false
  logCfg.log_disable_desensitize = false
  logCfg.log_level = agora.RTC_LOG_INFO
  logCfg.log_path = logPath.cstring
  let serviceOption = create(agora.rtc_service_option_t)
  defer: dealloc(serviceOption)

  serviceOption.area_code = AREA_CODE_CN.uint32
  # `[]` is dereference operator (what?)
  serviceOption.log_cfg = logCfg[]
  err = agora.rtc_init(appId.cstring, handlers, serviceOption)
  panicWhenErr err, "init"
  defer: 
    err = agora.rtc_fini()
    panicWhenErr err, "fini"

  let pConnId:ptr uint32 = create(uint32)
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
  err = agora.rtc_join_channel(connId, channelName.cstring, uid, appToken.cstring, chanOpts)
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



when isMainModule:
  main()

