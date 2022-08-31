import agora
import gintro/[gst, gstapp, gobject, glib, gstbase]
import std/os
import std/parsecfg as cfg
import std/[strutils, streams]
import std/strformat
import logger
import callbacks
import utils

let loop = glib.newMainLoop(nil, false)
const UseSignal = false

type
    NewSampleParams = object
        connId: uint32
        videoInfo: ptr video_frame_info_t

# invoke your callback from another thread needs to step up gc
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
        if code == 0:
            stdout.write "*"
            stdout.flushFile()
    return gst.FlowReturn.ok

# See also
# https://github.com/StefanSalewski/gintro/blob/f4113ebab7b71c078e4ae57c380bcb8e9863abe9/examples/gtk3/appsink_src.nim
# I guess I don't have to release the memory called with C library?
# https://forum.nim-lang.org/t/6216
proc main =
    const appId = "3759fd9101e04094869e7e69b9b3fe64"
    const appToken = "007eJxTYPA8KzadSeC0+CrpH1yXHySdE0m/32bVImTOtrjr+52l9ywVGIzNTS3TUiwNDQxTDUwMLE0szCxTzVPNLJMsk4zTUs1MFm/mS1ZiFUiefa2TiZEBAkF8FoaS1OISBgYA7AEeWQ=="
    const channelName = "test"
    const uid: uint32 = 1234
    const logPath = "logs"
    # I don't know why but if `tune=zerolatency` is not set the video will be
    # teared
    const pipeline = """
        videotestsrc name=src is-live=true ! 
        clockoverlay ! 
        videoconvert ! 
        x264enc speed-preset=ultrafast tune=zerolatency ! 
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

    let home = os.getHomeDir()
    let certPath = os.joinPath(home, "certificate.bin")
    debug "certification is located in ", certPath
    let certFile = open(certPath, fmRead)
    let certContent = readAll(certFile)
    debug "Cert length: ", $certContent.len

    var err = 0;
    # The syntax for type conversions is destination_type(expression_to_convert)
    err = agora.rtc_license_verify(certContent.cstring, certContent.len.cint,
            nil, 0)
    panicWhenErr err, "license verify"

    # https://en.wikipedia.org/wiki/Hungarian_notation
    # I know it's bad but what's the alternative without IDE?
    # https://nim-lang.org/docs/manual.html#types-reference-and-pointer-types
    # TODO: use destructor like in C++ instead of manual release
    # https://nim-lang.org/docs/destructors.html
    # More explanation on ref:
    # https://www.reddit.com/r/nim/comments/q46sc5/whats_the_point_in_ref_object/
    # https://forum.nim-lang.org/t/1207
    let pHandlers = getDefaultHandler()
    defer: dealloc(pHandlers)
    # a ref in Nim is a reference (a managed pointer), and a "ref object" is a
    # reference to an object.
    # now the object is in stack
    let logCfg = agora.log_config_t(
      log_disable:  false,
      log_disable_desensitize: true,
      log_level: agora.RTC_LOG_DEBUG,
      log_path: logPath.cstring,
    )

    let serviceOption = agora.rtc_service_option_t(
      area_code : AREA_CODE_CN.uint32,
      log_cfg : logCfg,
    )
    # `[]` is dereference operator (what?)

    err = agora.rtc_init(appId.cstring, pHandlers, serviceOption.addr)
    panicWhenErr err, "init"
    defer:
        err = agora.rtc_fini()
        panicWhenErr err, "fini"

    let pConnId: ptr uint32 = create(uint32)
    defer: dealloc(pConnId)
    err = agora.rtc_create_connection(pConnId)
    panicWhenErr err, "create connection"
    let connId: uint32 = pConnId[]
    defer:
        err = agora.rtc_destroy_connection(connId)
        panicWhenErr err, "destroy connection"

    let codecOpts = agora.audio_codec_option_t(
      audio_codec_type: agora.AUDIO_CODEC_DISABLED,
      pcm_sample_rate: 0,
      pcm_channel_num: 0,
    )
    let chanOpts = agora.rtc_channel_options_t(
      auto_subscribe_audio : false,
      auto_subscribe_video : false,
      subscribe_local_user : false,
      enable_audio_jitter_buffer : false,
      enable_audio_mixer : false,
      audio_codec_opt : codecOpts,
      enable_aut_encryption : false,
    )
    # the problem is this line with join channel
    err = agora.rtc_join_channel(connId, channelName.cstring, uid,
        appToken.cstring, chanOpts.addr)
    panicWhenErr err, "join channel"
    defer:
        err = agora.rtc_leave_channel(connId)
        panicWhenErr err, "leave channel"

    let videoInfo = agora.video_frame_info_t(
      data_type : agora.VIDEO_DATA_TYPE_H264,
      stream_type : agora.VIDEO_STREAM_LOW,
      frame_type : agora.VIDEO_FRAME_AUTO_DETECT,
      # 0 means auto detect which is not defined in the header
      frame_rate: (0).video_frame_rate_e,
    )
    let pParams = create(NewSampleParams)
    defer: dealloc(pParams)
    pParams.connId = connId
    pParams.videoInfo = videoInfo.addr

    let appSink = cast[Bin](pipe).getByName("agora")
    let pAppSinkCb = create(GstAppSinkCallbacks)
    defer: dealloc(pAppSinkCb)
    pAppSinkCb.new_sample = newSampleCallback
    # GstAppSink and appsink are different object?
    # https://gstreamer.freedesktop.org/documentation/app/appsink.html?gi-language=c
    # https://gstreamer.freedesktop.org/documentation/applib/gstappsink.html?gi-language=c
    # Debug Gstreamer
    # https://gstreamer.freedesktop.org/documentation/tutorials/basic/debugging-tools.html?gi-language=c
    # https://gstreamer.freedesktop.org/documentation/tutorials/basic/short-cutting-the-pipeline.html?gi-language=c#walkthrough
    if UseSignal:
      # This signal is emitted from the streaming thread and only when the
      # "emit-signals" property is TRUE!!!!!!!!!
      appSink.setProperty("emit-signals", toBoolVal(true))
      # these should be the same
      # connect(appSink, "new-sample", newSampleCallback, params)
      # discard cast[AppSink](appSink).scNewSample(newSampleCallback, params, {})
      let handlerId = g_signal_connect(appSink.impl, "new-sample", cast[GCallback](
          newSampleCallback), pParams)
      if handlerId <= 0:
          error "Failed to connect signal"
    else:
      # It's more efficient to use the callback instead of the signal
      gst_app_sink_set_callbacks(appSink.impl, pAppSinkCb, pParams, nil)
    discard pipe.setState(State.playing)
    defer:
        discard pipe.setState(State.null)
    # I have to handle Ctrl+C to exit loop
    onSignal(SIGINT):
      loop.quit()
    glib.run(loop)

when isMainModule:
    main()

