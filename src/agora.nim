# Generated @ 2022-08-29T04:32:08+00:00
# Command line:
#   /root/Code/nimterop/nimterop/toast --preprocess -m:c --recurse -E_ -F_ -E__ -F__ -Eagora_ -EAGORA_ --pnim --dynlib=/root/Code/nim_agora/agora_sdk/lib/aarch64/libagora-rtc-sdk.so --nim:/root/Code/Nim/bin/nim /root/Code/nim_agora/agora_sdk/include/agora_rtc_api.h -o /root/Code/nim_agora/src/agora.nim

# const 'CONNECTION_ID_INVALID' has unsupported value '((connection_id_t)-1)'
{.push hint[ConvFromXtoItselfNotNeeded]: off.}
import macros

macro defineEnum(typ: untyped): untyped =
  result = newNimNode(nnkStmtList)

  # Enum mapped to distinct cint
  result.add quote do:
    type `typ`* = distinct cint

  for i in ["+", "-", "*", "div", "mod", "shl", "shr", "or", "and", "xor", "<", "<=", "==", ">", ">="]:
    let
      ni = newIdentNode(i)
      typout = if i[0] in "<=>": newIdentNode("bool") else: typ # comparisons return bool
    if i[0] == '>': # cannot borrow `>` and `>=` from templates
      let
        nopp = if i.len == 2: newIdentNode("<=") else: newIdentNode("<")
      result.add quote do:
        proc `ni`*(x: `typ`, y: cint): `typout` = `nopp`(y, x)
        proc `ni`*(x: cint, y: `typ`): `typout` = `nopp`(y, x)
        proc `ni`*(x, y: `typ`): `typout` = `nopp`(y, x)
    else:
      result.add quote do:
        proc `ni`*(x: `typ`, y: cint): `typout` {.borrow.}
        proc `ni`*(x: cint, y: `typ`): `typout` {.borrow.}
        proc `ni`*(x, y: `typ`): `typout` {.borrow.}
    result.add quote do:
      proc `ni`*(x: `typ`, y: int): `typout` = `ni`(x, y.cint)
      proc `ni`*(x: int, y: `typ`): `typout` = `ni`(x.cint, y)

  let
    divop = newIdentNode("/")   # `/`()
    dlrop = newIdentNode("$")   # `$`()
    notop = newIdentNode("not") # `not`()
  result.add quote do:
    proc `divop`*(x, y: `typ`): `typ` = `typ`((x.float / y.float).cint)
    proc `divop`*(x: `typ`, y: cint): `typ` = `divop`(x, `typ`(y))
    proc `divop`*(x: cint, y: `typ`): `typ` = `divop`(`typ`(x), y)
    proc `divop`*(x: `typ`, y: int): `typ` = `divop`(x, y.cint)
    proc `divop`*(x: int, y: `typ`): `typ` = `divop`(x.cint, y)

    proc `dlrop`*(x: `typ`): string {.borrow.}
    proc `notop`*(x: `typ`): `typ` {.borrow.}


{.pragma: impagora_rtc_apiHdr,
  header: "/root/Code/nim_agora/agora_sdk/include/agora_rtc_api.h".}
{.pragma: impagora_rtc_apiDyn,
  dynlib: "/root/Code/nim_agora/agora_sdk/lib/aarch64/libagora-rtc-sdk.so".}
{.experimental: "codeReordering".}
defineEnum(err_code_e)       ## ```
                             ##   Error code.
                             ## ```
defineEnum(user_offline_reason_e) ## ```
                                  ##   The definition of the user_offline_reason_e enum.
                                  ## ```
defineEnum(video_data_type_e) ## ```
                              ##   The definition of the video_data_type_e enum.
                              ## ```
defineEnum(video_frame_type_e) ## ```
                               ##   The definition of the video_frame_type_e enum.
                               ## ```
defineEnum(video_frame_rate_e) ## ```
                               ##   The definition of the video_frame_rate_e enum.
                               ## ```
defineEnum(video_stream_type_e) ## ```
                                ##   Video stream types.
                                ## ```
defineEnum(audio_codec_type_e) ## ```
                               ##   Audio codec type list.
                               ## ```
defineEnum(audio_data_type_e) ## ```
                              ##   Audio data type list.
                              ## ```
defineEnum(rtc_log_level_e)  ## ```
                             ##   The definition of log level enum
                             ## ```
defineEnum(area_code_e)      ## ```
                             ##   IP areas.
                             ## ```
defineEnum(cloud_proxy_type_e)
defineEnum(network_event_type_e) ## ```
                                 ##   Network event type enum
                                 ## ```
defineEnum(rtm_event_type_e) ## ```
                             ##   RTM 
                             ##     
                             ##    RTM event type list
                             ## ```
defineEnum(rtm_err_code_e)
const
  RTC_CHANNEL_NAME_MAX_LEN* = (64)
  RTC_USER_ID_MAX_LEN* = (255)
  RTC_PRODUCT_ID_MAX_LEN* = (63)
  RTM_UID_MAX_LEN* = 64
  RTM_DATA_MAX_LEN* = (32 * typeof(32)(1024))
  CREDENTIAL_MAX_LEN* = 256
  CERTIFICATE_MAX_LEN* = 1024
  LICENSE_VALUE_LEN* = 32
  ERR_OKAY* = (0).err_code_e ## ```
                             ##   No error.
                             ## ```
  ERR_FAILED* = (1).err_code_e ## ```
                               ##   General error
                               ## ```
  ERR_NET_DOWN* = (14).err_code_e ## ```
                                  ##   Network is unavailable
                                  ## ```
  ERR_JOIN_CHANNEL_REJECTED* = (17).err_code_e ## ```
                                               ##   Request to join channel is rejected.
                                               ##      It occurs when local user is already in channel and try to join the same channel again.
                                               ## ```
  ERR_INVALID_APP_ID* = (101).err_code_e ## ```
                                         ##   App ID is invalid.
                                         ## ```
  ERR_INVALID_CHANNEL_NAME* = (102).err_code_e ## ```
                                               ##   Channel is invalid.
                                               ## ```
  ERR_NO_SERVER_RESOURCES* = (103).err_code_e ## ```
                                              ##   Fails to get server resources in the specified region.
                                              ## ```
  ERR_LOOKUP_CHANNEL_REJECTED* = (105).err_code_e ## ```
                                                  ##   Server rejected request to look up channel.
                                                  ## ```
  ERR_OPEN_CHANNEL_REJECTED* = (107).err_code_e ## ```
                                                ##   Server rejected request to open channel.
                                                ## ```
  ERR_TOKEN_EXPIRED* = (109).err_code_e ## ```
                                        ##   Token expired due to reasons belows:
                                        ##      - Authorized Timestamp expired:      The timestamp is represented by the number of
                                        ##                                           seconds elapsed since 1/1/1970. The user can use
                                        ##                                           the Token to access the Agora service within five
                                        ##                                           minutes after the Token is generated. If the user
                                        ##                                           does not access the Agora service after five minutes,
                                        ##                                           this Token will no longer be valid.
                                        ##      - Call Expiration Timestamp expired: The timestamp indicates the exact time when a
                                        ##                                           user can no longer use the Agora service (for example,
                                        ##                                           when a user is forced to leave an ongoing call).
                                        ##                                           When the value is set for the Call Expiration Timestamp,
                                        ##                                           it does not mean that the Token will be expired,
                                        ##                                           but that the user will be kicked out of the channel.
                                        ## ```
  ERR_INVALID_TOKEN* = (110).err_code_e ## ```
                                        ##   Token is invalid due to reasons belows:
                                        ##     - If application certificate is enabled on the Dashboard,
                                        ##       valid token SHOULD be set when invoke.
                                        ##    
                                        ##     - If uid field is mandatory, users must specify the same uid as the one used to generate the token,
                                        ##       when calling agora_rtc_join_channel.
                                        ## ```
  ERR_DYNAMIC_TOKEN_BUT_USE_STATIC_KEY* = (115).err_code_e ## ```
                                                           ##   Dynamic token has been enabled, but is not provided when joining the channel.
                                                           ##       Please specify the valid token when calling agora_rtc_join_channel.
                                                           ## ```
  ERR_SET_CLIENT_ROLE_NOT_AUTHORIZED* = (119).err_code_e ## ```
                                                         ##   Switching roles failed.
                                                         ##       Please try to rejoin the channel.
                                                         ## ```
  ERR_DECRYPTION_FAILED* = (120).err_code_e ## ```
                                            ##   Decryption fails. The user may have used a different encryption password to join the channel.
                                            ##       Check your settings or try rejoining the channel.
                                            ## ```
  ERR_OPEN_CHANNEL_INVALID_TICKET* = (121).err_code_e ## ```
                                                      ##   Ticket to open channel is invalid
                                                      ## ```
  ERR_OPEN_CHANNEL_TRY_NEXT_VOS* = (122).err_code_e ## ```
                                                    ##   Try another server.
                                                    ## ```
  ERR_CLIENT_IS_BANNED_BY_SERVER* = (123).err_code_e ## ```
                                                     ##   Client is banned by the server
                                                     ## ```
  ERR_SEND_VIDEO_OVER_BANDWIDTH_LIMIT* = (200).err_code_e ## ```
                                                          ##   Sending video data too fast and over the bandwidth limit.
                                                          ##       Very likely that packet loss occurs with this sending speed.
                                                          ## ```
  ERR_AUDIO_DECODER_NOT_MATCH_AUDIO_FRAME* = (201).err_code_e ## ```
                                                              ##   Audio decoder does not match incoming audio data type.
                                                              ##       Currently SDK built-in audio codec only supports G722 and OPUS.
                                                              ## ```
  ERR_NO_AUDIO_DECODER_TO_HANDLE_AUDIO_FRAME* = (202).err_code_e ## ```
                                                                 ##   Audio decoder does not match incoming audio data type.
                                                                 ##       Currently SDK built-in audio codec only supports G722 and OPUS.
                                                                 ## ```
  USER_OFFLINE_QUIT* = (0).user_offline_reason_e ## ```
                                                 ##   0: Remote user leaves channel actively
                                                 ## ```
  USER_OFFLINE_DROPPED* = (1).user_offline_reason_e ## ```
                                                    ##   1: Remote user is dropped due to timeout
                                                    ## ```
  VIDEO_DATA_TYPE_YUV420* = (0).video_data_type_e ## ```
                                                  ##   0: YUV420
                                                  ## ```
  VIDEO_DATA_TYPE_H264* = (2).video_data_type_e ## ```
                                                ##   2: H264
                                                ## ```
  VIDEO_DATA_TYPE_H265* = (3).video_data_type_e ## ```
                                                ##   3: H265
                                                ## ```
  VIDEO_DATA_TYPE_GENERIC* = (6).video_data_type_e ## ```
                                                   ##   6: generic
                                                   ## ```
  VIDEO_DATA_TYPE_GENERIC_JPEG* = (20).video_data_type_e ## ```
                                                         ##   20: generic JPEG
                                                         ## ```
  VIDEO_FRAME_AUTO_DETECT* = (0).video_frame_type_e ## ```
                                                    ##   0: unknow frame type
                                                    ##      If you set it ,the SDK will judge the frame type
                                                    ## ```
  VIDEO_FRAME_KEY* = (3).video_frame_type_e ## ```
                                            ##   3: key frame
                                            ## ```
  VIDEO_FRAME_DELTA* = (4).video_frame_type_e ## ```
                                              ##   4: delta frame, e.g: P-Frame
                                              ## ```
  VIDEO_FRAME_RATE_FPS_1* = (1).video_frame_rate_e ## ```
                                                   ##   1: 1 fps.
                                                   ## ```
  VIDEO_FRAME_RATE_FPS_7* = (7).video_frame_rate_e ## ```
                                                   ##   7: 7 fps.
                                                   ## ```
  VIDEO_FRAME_RATE_FPS_10* = (10).video_frame_rate_e ## ```
                                                     ##   10: 10 fps.
                                                     ## ```
  VIDEO_FRAME_RATE_FPS_15* = (15).video_frame_rate_e ## ```
                                                     ##   15: 15 fps.
                                                     ## ```
  VIDEO_FRAME_RATE_FPS_24* = (24).video_frame_rate_e ## ```
                                                     ##   24: 24 fps.
                                                     ## ```
  VIDEO_FRAME_RATE_FPS_30* = (30).video_frame_rate_e ## ```
                                                     ##   30: 30 fps.
                                                     ## ```
  VIDEO_FRAME_RATE_FPS_60* = (60).video_frame_rate_e ## ```
                                                     ##   60: 60 fps. Applies to Windows and macOS only.
                                                     ## ```
  VIDEO_STREAM_HIGH* = (0).video_stream_type_e ## ```
                                               ##   0: The high-quality video stream, which has a higher resolution and bitrate.
                                               ## ```
  VIDEO_STREAM_LOW* = (1).video_stream_type_e ## ```
                                              ##   1: The low-quality video stream, which has a lower resolution and bitrate.
                                              ## ```
  AUDIO_CODEC_DISABLED* = (0).audio_codec_type_e ## ```
                                                 ##   0: Disable
                                                 ## ```
  AUDIO_CODEC_TYPE_OPUS* = (1).audio_codec_type_e ## ```
                                                  ##   1: OPUS
                                                  ## ```
  AUDIO_CODEC_TYPE_G722* = (2).audio_codec_type_e ## ```
                                                  ##   2: G722
                                                  ## ```
  AUDIO_CODEC_TYPE_G711A* = (3).audio_codec_type_e ## ```
                                                   ##   3: G711A
                                                   ## ```
  AUDIO_CODEC_TYPE_G711U* = (4).audio_codec_type_e ## ```
                                                   ##   4: G711U
                                                   ## ```
  AUDIO_DATA_TYPE_OPUS* = (1).audio_data_type_e ## ```
                                                ##   1: OPUS
                                                ## ```
  AUDIO_DATA_TYPE_OPUSFB* = (2).audio_data_type_e ## ```
                                                  ##   2: OPUSFB
                                                  ## ```
  AUDIO_DATA_TYPE_PCMA* = (3).audio_data_type_e ## ```
                                                ##   3: PCMA
                                                ## ```
  AUDIO_DATA_TYPE_PCMU* = (4).audio_data_type_e ## ```
                                                ##   4: PCMU
                                                ## ```
  AUDIO_DATA_TYPE_G722* = (5).audio_data_type_e ## ```
                                                ##   5: G722
                                                ## ```
  AUDIO_DATA_TYPE_AACLC* = (8).audio_data_type_e ## ```
                                                 ##   8: AACLC
                                                 ## ```
  AUDIO_DATA_TYPE_HEAAC* = (9).audio_data_type_e ## ```
                                                 ##   9: HEAAC
                                                 ## ```
  AUDIO_DATA_TYPE_PCM* = (100).audio_data_type_e ## ```
                                                 ##   100: PCM (audio codec should be enabled)
                                                 ## ```
  AUDIO_DATA_TYPE_GENERIC* = (253).audio_data_type_e ## ```
                                                     ##   253: GENERIC
                                                     ## ```
  RTC_LOG_DEFAULT* = (0).rtc_log_level_e ## ```
                                         ##   the same as RTC_LOG_NOTICE
                                         ## ```
  RTC_LOG_EMERG* = (RTC_LOG_DEFAULT + 1).rtc_log_level_e ## ```
                                                         ##   system is unusable
                                                         ## ```
  RTC_LOG_ALERT* = (RTC_LOG_EMERG + 1).rtc_log_level_e ## ```
                                                       ##   action must be taken immediately
                                                       ## ```
  RTC_LOG_CRIT* = (RTC_LOG_ALERT + 1).rtc_log_level_e ## ```
                                                      ##   critical conditions
                                                      ## ```
  RTC_LOG_ERROR* = (RTC_LOG_CRIT + 1).rtc_log_level_e ## ```
                                                      ##   error conditions
                                                      ## ```
  RTC_LOG_WARNING* = (RTC_LOG_ERROR + 1).rtc_log_level_e ## ```
                                                         ##   warning conditions
                                                         ## ```
  RTC_LOG_NOTICE* = (RTC_LOG_WARNING + 1).rtc_log_level_e ## ```
                                                          ##   normal but significant condition, default level
                                                          ## ```
  RTC_LOG_INFO* = (RTC_LOG_NOTICE + 1).rtc_log_level_e ## ```
                                                       ##   informational
                                                       ## ```
  RTC_LOG_DEBUG* = (RTC_LOG_INFO + 1).rtc_log_level_e ## ```
                                                      ##   debug-level messages
                                                      ## ```
  AREA_CODE_DEFAULT* = (0x00000000).area_code_e ## ```
                                                ##   the same as AREA_CODE_GLOB
                                                ## ```
  AREA_CODE_CN* = (0x00000001).area_code_e ## ```
                                           ##   Mainland China.
                                           ## ```
  AREA_CODE_NA* = (0x00000002).area_code_e ## ```
                                           ##   North America.
                                           ## ```
  AREA_CODE_EU* = (0x00000004).area_code_e ## ```
                                           ##   Europe.
                                           ## ```
  AREA_CODE_AS* = (0x00000008).area_code_e ## ```
                                           ##   Asia, excluding Mainland China.
                                           ## ```
  AREA_CODE_JP* = (0x00000010).area_code_e ## ```
                                           ##   Japan.
                                           ## ```
  AREA_CODE_IN* = (0x00000020).area_code_e ## ```
                                           ##   India.
                                           ## ```
  AREA_CODE_OC* = (0x00000040).area_code_e ## ```
                                           ##   Oceania
                                           ## ```
  AREA_CODE_SA* = (0x00000080).area_code_e ## ```
                                           ##   South-American
                                           ## ```
  AREA_CODE_AF* = (0x00000100).area_code_e ## ```
                                           ##   Africa
                                           ## ```
  AREA_CODE_KR* = (0x00000200).area_code_e ## ```
                                           ##   South Korea
                                           ## ```
  AREA_CODE_OVS* = 0xFFFFFFFE ## ```
                                                        ##   The global area (except China)
                                                        ## ```
  AREA_CODE_GLOB* = 0xFFFFFFFF ## ```
                                                           ##   (Default) Global.
                                                           ## ```
  CLOUD_PROXY_NONE* = (0).cloud_proxy_type_e
  CLOUD_PROXY_UDP* = (1).cloud_proxy_type_e
  CLOUD_PROXY_TCP* = (3).cloud_proxy_type_e
  CLOUD_PROXY_AUTO* = (100).cloud_proxy_type_e
  NETWORK_EVENT_DOWN* = (0).network_event_type_e
  NETWORK_EVENT_UP* = (NETWORK_EVENT_DOWN + 1).network_event_type_e
  NETWORK_EVENT_CHANGE* = (NETWORK_EVENT_UP + 1).network_event_type_e
  CONNECTION_ID_ALL* = 0
  RTM_EVENT_TYPE_LOGIN* = (0).rtm_event_type_e ## ```
                                               ##   0: LOGIN
                                               ## ```
  RTM_EVENT_TYPE_KICKOFF* = (1).rtm_event_type_e ## ```
                                                 ##   1: KICKOFF
                                                 ## ```
  RTM_EVENT_TYPE_EXIT* = (2).rtm_event_type_e ## ```
                                              ##   2: EXIT
                                              ## ```
  ERR_RTM_OK* = (0).rtm_err_code_e ## ```
                                   ##   no error
                                   ## ```
  ERR_RTM_FAILED* = (1).rtm_err_code_e ## ```
                                       ##   general error
                                       ## ```
  ERR_RTM_LOGIN_REJECTED* = (2).rtm_err_code_e ## ```
                                               ##   Login is rejected by the server.
                                               ## ```
  ERR_RTM_INVALID_RTM_UID* = (3).rtm_err_code_e ## ```
                                                ##   invalid rtm uid
                                                ## ```
  ERR_RTM_LOGIN_INVALID_TOKEN* = (5).rtm_err_code_e ## ```
                                                    ##   The token is invalid.
                                                    ## ```
  ERR_RTM_LOGIN_NOT_AUTHORIZED* = (7).rtm_err_code_e ## ```
                                                     ##   Unauthorized login.
                                                     ## ```
  ERR_RTM_INVALID_APP_ID* = (ERR_INVALID_APP_ID).rtm_err_code_e ## ```
                                                                ##   invalid appid
                                                                ## ```
  WARN_RTM_LOOKUP_CHANNEL_REJECTED* = (ERR_LOOKUP_CHANNEL_REJECTED).rtm_err_code_e ## ```
                                                                                   ##   The server rejected the request to look up the channel
                                                                                   ## ```
  ERR_RTM_TOKEN_EXPIRED* = (ERR_TOKEN_EXPIRED).rtm_err_code_e ## ```
                                                              ##   Authorized Timestamp expired
                                                              ## ```
  ERR_RTM_INVALID_TOKEN* = (ERR_INVALID_TOKEN).rtm_err_code_e ## ```
                                                              ##   invalid token
                                                              ## ```
type
  video_frame_info_t* {.bycopy, importc, impagora_rtc_apiHdr.} = object ## ```
                                                                         ##   The definition of the video_frame_info_t struct.
                                                                         ## ```
    data_type*: video_data_type_e ## ```
                                  ##   The video data type: #video_data_type_e.
                                  ## ```
    stream_type*: video_stream_type_e ## ```
                                      ##   The video stream type: #video_stream_type_e
                                      ## ```
    frame_type*: video_frame_type_e ## ```
                                    ##   The frame type of the encoded video frame: #video_frame_type_e.
                                    ## ```
    frame_rate*: video_frame_rate_e ## ```
                                    ##   The number of video frames per second.
                                    ##      -This value will be used for calculating timestamps of the encoded image.
                                    ##      - If frame_per_sec equals zero, then real timestamp will be used.
                                    ##      - Otherwise, timestamp will be adjusted to the value of frame_per_sec set.
                                    ## ```
  
  audio_frame_info_t* {.bycopy, importc, impagora_rtc_apiHdr.} = object ## ```
                                                                         ##   The definition of the audio_frame_info_t struct.
                                                                         ## ```
    data_type*: audio_data_type_e ## ```
                                  ##   Audio data type, reference #audio_data_type_e.
                                  ## ```
  
  log_config_t* {.bycopy, importc, completeStruct,impagora_rtc_apiHdr.} = object ## ```
                                                                   ##   log config
                                                                   ## ```
    log_disable*: bool
    log_disable_desensitize*: bool
    log_level*: rtc_log_level_e
    log_path*: cstring

  rtc_service_option_t* {.bycopy, importc, completeStruct,impagora_rtc_apiHdr.} = object ## ```
                                                                           ##   The definition of the service option
                                                                           ## ```
    area_code*: uint32 ## ```
                       ##   area code for regional restriction, default is golbal, Supported areas refer to enum area_code_e
                       ##      and bit operations for multiple regions are supported
                       ## ```
    product_id*: array[(63) + typeof((63))(1), cchar] ## ```
                                                      ##   the  product_id (device name), the max product_id length is 63
                                                      ## ```
    log_cfg*: log_config_t   ## ```
                             ##   sdk log config
                             ## ```
    license_value*: array[32 + typeof(32)(1), cchar] ## ```
                                                     ##   license value return when license actived, the max license_value length is 32
                                                     ##      Supported character scopes are:
                                                     ##      - The 26 lowercase English letters: a to z
                                                     ##      - The 26 uppercase English letters: A to Z
                                                     ##      - The 10 numbers: 0 to 9
                                                     ## ```
  
  audio_codec_option_t* {.bycopy, importc, completeStruct, impagora_rtc_apiHdr.} = object
    audio_codec_type*: audio_codec_type_e ## ```
                                          ##   Configure sdk built-in audio codec
                                          ##      If AUDIO_CODEC_TYPE_OPUS is selected, your PCM data is encoded as OPUS and then streamed to Agora channel
                                          ##      If AUDIO_CODEC_TYPE_G722 is selected, your PCM data is encoded as G722 and then streamed to Agora channel
                                          ##      If you provide encoded audio data, such as AAC, instead of raw PCM, please disable audio codec by selecting AUDIO_CODEC_DISABLED
                                          ## ```
    pcm_sample_rate*: cint ## ```
                           ##   Pcm sample rate. Ignored if audio coded is diabled
                           ## ```
    pcm_channel_num*: cint ## ```
                           ##   Pcm channel number. Ignored if audio coded is diabled
                           ## ```
  
  rtc_channel_options_t* {.bycopy, importc, completeStruct, impagora_rtc_apiHdr.} = object ## ```
                                                                            ##   The definition of the rtc_channel_options_t struct.
                                                                            ## ```
    auto_subscribe_audio*: bool
    auto_subscribe_video*: bool
    subscribe_local_user*: bool
    enable_audio_jitter_buffer*: bool
    enable_audio_mixer*: bool
    audio_codec_opt*: audio_codec_option_t ## ```
                                           ##   audio encode and decode configuration when send pcm audio data by #agora_rtc_send_audio_data
                                           ## ```
    enable_aut_encryption*: bool

  connection_id_t* {.importc, impagora_rtc_apiHdr.} = uint32 ## ```
                                                             ##   Connection identification
                                                             ## ```
  connection_info_t* {.bycopy, importc, impagora_rtc_apiHdr.} = object ## ```
                                                                        ##   connection info
                                                                        ## ```
    conn_id*: connection_id_t ## ```
                              ##   Connection identification
                              ## ```
    uid*: uint32             ## ```
                             ##   user id
                             ## ```
    channel_name*: array[(64) + typeof((64))(1), cchar] ## ```
                                                        ##   channel name
                                                        ## ```
  
  rtc_event_handler_t* {.bycopy, impagora_rtc_apiHdr,
                         completeStruct,
                         importc: "agora_rtc_event_handler_t".} = object ## ```
                                                                          ##   Agora RTC SDK event handler
                                                                          ## ```
    on_join_channel_success*: proc (conn_id: connection_id_t; uid: uint32;
                                    elapsed_ms: cint) {.cdecl.} ## ```
                                                                ##   Occurs when local user joins channel successfully.
                                                                ##     
                                                                ##      @param[in] conn_id    Connection identification
                                                                ##      param[in] uid         local uid
                                                                ##      @param[in] elapsed_ms Time elapsed (ms) since channel is established
                                                                ## ```
    on_connection_lost*: proc (conn_id: connection_id_t) {.cdecl.} ## ```
                                                                   ##   Occurs when channel is disconnected from the server.
                                                                   ##     
                                                                   ##      @param[in] conn_id    Connection identification
                                                                   ## ```
    on_rejoin_channel_success*: proc (conn_id: connection_id_t; uid: uint32;
                                      elapsed_ms: cint) {.cdecl.} ## ```
                                                                  ##   Occurs when local user rejoins channel successfully after disconnect
                                                                  ##     
                                                                  ##      When channel loses connection with server due to network problems,
                                                                  ##      SDK will retry to connect automatically. If success, it will be triggered.
                                                                  ##     
                                                                  ##      @param[in] conn_id    Connection identification
                                                                  ##      @param[in] uid        local uid
                                                                  ##      @param[in] elapsed_ms Time elapsed (ms) since rejoin due to network
                                                                  ## ```
    on_error*: proc (conn_id: connection_id_t; code: cint; msg: cstring) {.cdecl.} ## ```
                                                                                   ##   Report error message during runtime.
                                                                                   ##     
                                                                                   ##      In most cases, it means SDK can't fix the issue and application should take action.
                                                                                   ##     
                                                                                   ##      @param[in] conn_id Connection identification
                                                                                   ##      @param[in] code    Error code, see #agora_err_code_e
                                                                                   ##      @param[in] msg     Error message
                                                                                   ## ```
    on_user_joined*: proc (conn_id: connection_id_t; uid: uint32;
                           elapsed_ms: cint) {.cdecl.} ## ```
                                                       ##   Occurs when a remote user joins channel successfully.
                                                       ##     
                                                       ##      @param[in] conn_id    Connection identification
                                                       ##      @param[in] uid        Remote user ID
                                                       ##      @param[in] elapsed_ms Time elapsed (ms) since channel is established
                                                       ## ```
    on_user_offline*: proc (conn_id: connection_id_t; uid: uint32; reason: cint) {.
        cdecl.} ## ```
                ##   Occurs when remote user leaves the channel.
                ##     
                ##      @param[in] conn_id Connection identification
                ##      @param[in] uid     Remote user ID
                ##      @param[in] reason  Reason, see #user_offline_reason_e
                ## ```
    on_user_mute_audio*: proc (conn_id: connection_id_t; uid: uint32;
                               muted: bool) {.cdecl.} ## ```
                                                      ##   Occurs when a remote user sends notification before enable/disable sending audio.
                                                      ##     
                                                      ##      @param[in] conn_id Connection identification
                                                      ##      @param[in] uid     Remote user ID
                                                      ##      @param[in] muted   Mute status:
                                                      ##                         - false(0): unmuted
                                                      ##                         - true (1): muted
                                                      ## ```
    on_user_mute_video*: proc (conn_id: connection_id_t; uid: uint32;
                               muted: bool) {.cdecl.} ## ```
                                                      ##   Occurs when a remote user sends notification before enable/disable sending video.
                                                      ##     
                                                      ##      @param[in] conn_id Connection identification
                                                      ##      @param[in] uid     Remote user ID
                                                      ##      @param[in] muted   Mute status:
                                                      ##                         - false(0): unmuted
                                                      ##                         - true (1): muted
                                                      ## ```
    on_audio_data*: proc (conn_id: connection_id_t; uid: uint32;
                          sent_ts: uint16; data_ptr: pointer; data_len: uint;
                          info_ptr: ptr audio_frame_info_t) {.cdecl.} ## ```
                                                                      ##   Occurs when receiving the audio frame of a remote user in the channel.
                                                                      ##     
                                                                      ##      @param[in] conn_id    Connection identification
                                                                      ##      @param[in] uid        Remote user ID to which data is sent
                                                                      ##      @param[in] sent_ts    Timestamp (ms) for sending data
                                                                      ##      @param[in] data_ptr   Audio frame buffer
                                                                      ##      @param[in] data_len   Audio frame buffer length (bytes)
                                                                      ##      @param[in] frame_info Audio frame info
                                                                      ## ```
    on_mixed_audio_data*: proc (conn_id: connection_id_t; data_ptr: pointer;
                                data_len: uint; info_ptr: ptr audio_frame_info_t) {.
        cdecl.} ## ```
                ##   Occurs every 20ms.
                ##     
                ##      @param[in] conn_id     Connection identification
                ##      @param[in] data_ptr    Audio frame buffer
                ##      @param[in] data_len    Audio frame buffer length (bytes)
                ##      @param[in] frame_info  Audio frame info
                ## ```
    on_video_data*: proc (conn_id: connection_id_t; uid: uint32;
                          sent_ts: uint16; data_ptr: pointer; data_len: uint;
                          info_ptr: ptr video_frame_info_t) {.cdecl.} ## ```
                                                                      ##   Occurs when receiving the video frame of a remote user in the channel.
                                                                      ##     
                                                                      ##      @param[in] conn_id      Connection identification
                                                                      ##      @param[in] uid          Remote user ID to which data is sent
                                                                      ##      @param[in] sent_ts      Timestamp (ms) for sending data
                                                                      ##      @param[in] data_ptr     Video frame buffer
                                                                      ##      @param[in] data_len     Video frame buffer lenth (bytes)
                                                                      ##      @param[in] frame_info   Video frame info
                                                                      ## ```
    on_target_bitrate_changed*: proc (conn_id: connection_id_t;
                                      target_bps: uint32) {.cdecl.} ## ```
                                                                    ##   Occurs when network bandwidth change is detected. User is expected to adjust encoder bitrate to |target_bps|
                                                                    ##     
                                                                    ##      @param[in] conn_id    Connection identification
                                                                    ##      @param[in] target_bps Target value (bps) by which the bitrate should update
                                                                    ## ```
    on_key_frame_gen_req*: proc (conn_id: connection_id_t; uid: uint32;
                                 stream_type: video_stream_type_e) {.cdecl.} ## ```
                                                                             ##   Occurs when a remote user requests a keyframe.
                                                                             ##     
                                                                             ##      This callback notifies the sender to generate a new keyframe.
                                                                             ##     
                                                                             ##      @param[in] conn_id      Connection identification
                                                                             ##      @param[in] uid          Remote user ID
                                                                             ##      @param[in] stream_type  Stream type for which a keyframe is requested
                                                                             ## ```
    on_token_privilege_will_expire*: proc (conn_id: connection_id_t;
        token: cstring) {.cdecl.} ## ```
                                  ##   Occurs when token will expired.
                                  ##     
                                  ##      @param[in] conn_id    Connection identification
                                  ##      @param[in] token      The token will expire
                                  ## ```
  
  rtm_handler_t* {.bycopy, impagora_rtc_apiHdr, importc: "agora_rtm_handler_t".} = object ## ```
                                                                                           ##   Agora RTC SDK RTM event handler
                                                                                           ## ```
    on_rtm_data*: proc (rtm_uid: cstring; msg: pointer; msg_len: uint) {.cdecl.} ## ```
                                                                                 ##   Occurs when data comes from RTM
                                                                                 ##      @param[in] rtm_uid    The remote rtm uid which the data come from.
                                                                                 ##      @param[in] msg        The Data received.
                                                                                 ##      @param[in] msg_len    Length of the data received.
                                                                                 ## ```
    on_rtm_event*: proc (rtm_uid: cstring; event_type: rtm_event_type_e;
                         err_code: rtm_err_code_e) {.cdecl.} ## ```
                                                             ##   Occurs when RTM event occurs
                                                             ##      @param[in] rtm_uid    RTM UID
                                                             ##      @param[in] event_type Event type
                                                             ##      @param[in] event_info Event info of event type
                                                             ## ```
    on_send_rtm_data_result*: proc (msg_id: uint32; error_code: rtm_err_code_e) {.
        cdecl.} ## ```
                ##   Report the result of the "agora_rtc_send_rtm_data" method call
                ##      @param[in] msg_id     Identify one message
                ##      @param[in] error_code Error code number
                ##                            - 0 : success
                ##                            - 1 : failure
                ## ```
  
proc rtc_get_version*(): cstring {.importc: "agora_rtc_get_version", cdecl,
                                   impagora_rtc_apiDyn.}
  ## ```
                                                        ##   @brief Get SDK version.
                                                        ##    @return A const static string describes the SDK version
                                                        ## ```
proc rtc_err_2_str*(err: cint): cstring {.importc: "agora_rtc_err_2_str", cdecl,
    impagora_rtc_apiDyn.}
  ## ```
                         ##   @brief Convert error code to const static string.
                         ##    @note You do not have to release the string after use.
                         ##    @param[in] err Error code
                         ##    @return Const static error string
                         ## ```
proc rtc_license_gen_credential*(credential: cstring; credential_len: ptr cuint): cint {.
    importc: "agora_rtc_license_gen_credential", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                             ##   @brief Generate a credential which is a unique device identifier.
                                                                             ##    @note It's authorizing smart devices license.
                                                                             ##          You can disregard it if license isn't used.
                                                                             ##    @param[out]    credential        Credential buffer holding the generated data
                                                                             ##    @param[in,out] credential_len    Credential buffer length (bytes), which should be larger than AGORA_CREDENTIAL_MAX_LEN
                                                                             ##    @return
                                                                             ##    - = 0: Success
                                                                             ##    - < 0: Failure
                                                                             ## ```
proc rtc_license_verify*(certificate: cstring; certificate_len: cint;
                         credential: cstring; credential_len: cint): cint {.
    importc: "agora_rtc_license_verify", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                     ##   @brief Authenticate the SDK licence.
                                                                     ##    @note
                                                                     ##    - It's authorizing smart devices license.
                                                                     ##      You can disregard it if you do not use a license.
                                                                     ##      Once the license is enabled, only the authenticated SDK can be used.
                                                                     ##    - This API should be invoked before agora_rtc_init
                                                                     ##    @param[in] certificate     Certificate buffer
                                                                     ##    @param[in] certificate_len Certificate buffer length
                                                                     ##    @param[in] credential      Credential buffer
                                                                     ##    @param[in] credential_len  Credential buffer length
                                                                     ##    @return
                                                                     ##    - = 0: Success
                                                                     ##    - < 0: Failure
                                                                     ## ```
proc rtc_init*(app_id: cstring; event_handler: ptr rtc_event_handler_t;
               option: ptr rtc_service_option_t): cint {.
    importc: "agora_rtc_init", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                           ##   @brief Initialize the Agora RTSA service.
                                                           ##    @note Each process can only be initialized once.
                                                           ##    @param[in] app_id          Application ID
                                                           ##                               If 'uid' is set as 0, SDK will assign a valid ID to the user
                                                           ##    @param[in] event_handler   A set of callback that handles Agora SDK events
                                                           ##    @param[in] option          RTC service option when init, If need't set option, set NULL
                                                           ##    @return
                                                           ##    - = 0: Success
                                                           ##    - < 0: Failure
                                                           ## ```
proc rtc_fini*(): cint {.importc: "agora_rtc_fini", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                                ##   @brief Release all resource allocated by Agora RTSA SDK
                                                                                ##    @return
                                                                                ##    - = 0: Success
                                                                                ##    - < 0: Failure
                                                                                ## ```
proc rtc_set_log_level*(level: rtc_log_level_e): cint {.
    importc: "agora_rtc_set_log_level", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                    ##   @brief Set the log level.
                                                                    ##    @param[in] level Log level. Range reference to rtc_log_level_e enum
                                                                    ##    @return
                                                                    ##    - = 0: Success
                                                                    ##    - < 0: Failure
                                                                    ## ```
proc rtc_config_log*(size_per_file: cint; max_file_count: cint): cint {.
    importc: "agora_rtc_config_log", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                 ##   @brief Sets the log file configuration.
                                                                 ##    @param[in] per_logfile_size The size (bytes) of each log file.
                                                                 ##                                The value range is [0, 10*1024*1024(10MB)], default 1*1024*1024(1MB).
                                                                 ##                                0 means set log off
                                                                 ##    @param[in] logfile_roll_count The maximum number of log file numbers.
                                                                 ##                                  The value range is [0, 100], default 10.
                                                                 ##                                  0 means set log off
                                                                 ##    @return
                                                                 ##    - 0: Success.
                                                                 ##    - <0: Failure.
                                                                 ## ```
proc rtc_create_connection*(conn_id: ptr connection_id_t): cint {.
    importc: "agora_rtc_create_connection", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                        ##   @brief Create a connection, connection can join channel
                                                                        ##    @param[out] conn_id: Store created connection id
                                                                        ##    @return
                                                                        ##     - =0: Success
                                                                        ##     - <0: Failure
                                                                        ## ```
proc rtc_destroy_connection*(conn_id: connection_id_t): cint {.
    importc: "agora_rtc_destroy_connection", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                         ##   @brief Destroy a connection
                                                                         ##    @param[in] conn_id    : Connection identification
                                                                         ##    @return
                                                                         ##     - =0: Success
                                                                         ##     - <0: Failure
                                                                         ## ```
proc rtc_get_connection_info*(conn_id: connection_id_t;
                              conn_info: ptr connection_info_t): cint {.
    importc: "agora_rtc_get_connection_info", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                          ##   @brief Get a connection info
                                                                          ##    @param[in] conn_id    : Connection identification
                                                                          ##    @param[out] conn_info : Connection info
                                                                          ##    @return
                                                                          ##     - =0: Success
                                                                          ##     - <0: Failure
                                                                          ## ```
proc rtc_join_channel*(conn_id: connection_id_t; channel_name: cstring;
                       uid: uint32; token: cstring;
                       options: ptr rtc_channel_options_t): cint {.
    importc: "agora_rtc_join_channel", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                   ##   @brief Local user joins channel.
                                                                   ##    @note Users in the same channel with the same App ID can send data to each other.
                                                                   ##          You can join more than one channel at the same time. All channels that
                                                                   ##          you join will receive the audio/video data stream that you send unless
                                                                   ##          you stop sending the audio/video data stream in a specific channel.
                                                                   ##    @param[in] conn_id      : Connection identification
                                                                   ##    @param[in] channel_name : Channel name
                                                                   ##               Length=strlen(channel_name) should be less than 64 bytes
                                                                   ##               Supported character scopes are:
                                                                   ##               - The 26 lowercase English letters: a to z
                                                                   ##               - The 26 uppercase English letters: A to Z
                                                                   ##               - The 10 numbers: 0 to 9
                                                                   ##               - The space
                                                                   ##               - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<",
                                                                   ##                 "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ","
                                                                   ##    @param[in] uid   : User ID.
                                                                   ##                      A 32-bit unsigned integer with a value ranging from 1 to 2^32-1. The uid must be unique.
                                                                   ##                      If a uid is set to 0, the SDK assigns and returns a uid in the on_join_channel_success callback.
                                                                   ##                        Your application must record and maintain the returned uid, because the SDK does not do so.
                                                                   ##    @param[in] token : Token string generated by the server, length=strlen(token) Range is [32, 512]
                                                                   ##                         - if token authorization is enabled on developer website, it should be set correctly
                                                                   ##                         - else token can be set as NULL
                                                                   ##    @param[in] options   channel options when create channel.
                                                                   ##                         If do not set channel options, set NULL
                                                                   ##    @return
                                                                   ##    - = 0: Success
                                                                   ##    - < 0: Failure
                                                                   ## ```
proc rtc_leave_channel*(conn_id: connection_id_t): cint {.
    importc: "agora_rtc_leave_channel", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                    ##   @brief Allow Local user leaves channel.
                                                                    ##    @note Local user should leave channel when data transmission is stopped
                                                                    ##    @param[in] conn_id   : Connection identification
                                                                    ##    @return
                                                                    ##    - = 0: Success
                                                                    ##    - < 0: Failure
                                                                    ## ```
proc rtc_renew_token*(conn_id: connection_id_t; token: cstring): cint {.
    importc: "agora_rtc_renew_token", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                  ##   @brief Renew token for specific channel OR all channels.
                                                                  ##    @note Token should be renewed when valid duration reached expiration.
                                                                  ##    @param[in] conn_id   Connection identification
                                                                  ##    @param[in] token     Token string, strlen(token) Range is [32, 512]
                                                                  ##    @return
                                                                  ##    - = 0: Success
                                                                  ##    - < 0: Failure
                                                                  ## ```
proc rtc_notify_network_event*(event: network_event_type_e): cint {.
    importc: "agora_rtc_notify_network_event", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                           ##   Set network state
                                                                           ##    @note It should only be used on systems where the SDK is not aware of network events, such as Android11 and later.
                                                                           ##    @param event : network event, ref@network_event_type_e
                                                                           ##    @return =0: success; <0: failure
                                                                           ## ```
proc rtc_mute_local_audio*(conn_id: connection_id_t; mute: bool): cint {.
    importc: "agora_rtc_mute_local_audio", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                       ##   @brief Decide whether to enable/disable sending local audio data to specific channel OR all channels.
                                                                       ##    @param[in] conn_id   Connection identification, if set CONNECTION_ID_ALL(0) is for all connections
                                                                       ##    @param[in] mute      Toggle sending local audio
                                                                       ##                         - false(0): unmuted
                                                                       ##                         - true (1): muted
                                                                       ##    @return
                                                                       ##    - = 0: Success
                                                                       ##    - < 0: Failure
                                                                       ## ```
proc rtc_mute_local_video*(conn_id: connection_id_t; mute: bool): cint {.
    importc: "agora_rtc_mute_local_video", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                       ##   @brief Decide whether to enable/disable sending local video data to specific channel OR all channels.
                                                                       ##    @param[in] conn_id   Connection identification, if set CONNECTION_ID_ALL(0) is for all connections
                                                                       ##    @param[in] mute      Toggle sending local video
                                                                       ##                         - false(0): unmuted
                                                                       ##                         - true (1): muted
                                                                       ##    @return
                                                                       ##    - = 0: Success
                                                                       ##    - < 0: Failure
                                                                       ## ```
proc rtc_mute_remote_audio*(conn_id: connection_id_t; remote_uid: uint32;
                            mute: bool): cint {.
    importc: "agora_rtc_mute_remote_audio", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                        ##   @brief Decide whether to enable/disable receiving remote audio data from specific channel OR all channels.
                                                                        ##    @param[in] conn_id      Connection identification, if set CONNECTION_ID_ALL(0) is for all connections
                                                                        ##    @param[in] remote_uid    Remote user ID
                                                                        ##                             - if remote_uid is set 0, it's for all users
                                                                        ##                             - else it's for specific user
                                                                        ##    @param[in] mute          Toggle receiving remote audio
                                                                        ##                             - false(0): unmuted
                                                                        ##                             - true (1): muted
                                                                        ##    @return
                                                                        ##    - = 0: Success
                                                                        ##    - < 0: Failure
                                                                        ## ```
proc rtc_mute_remote_video*(conn_id: connection_id_t; remote_uid: uint32;
                            mute: bool): cint {.
    importc: "agora_rtc_mute_remote_video", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                        ##   @brief Decide whether to enable/disable receiving remote video data from specific channel OR all channels.
                                                                        ##    @param[in] conn_id       Connection identification, if set CONNECTION_ID_ALL(0) is for all connections
                                                                        ##    @param[in] remote_uid    Remote user ID
                                                                        ##                             - if remote_uid is set 0, it's for all users
                                                                        ##                             - else it's for specific user
                                                                        ##    @param[in] mute          Toggle receiving remote video
                                                                        ##                             - false(0): unmuted
                                                                        ##                             - true (1): muted
                                                                        ##    @return
                                                                        ##    - = 0: Success
                                                                        ##    - < 0: Failure
                                                                        ## ```
proc rtc_request_video_key_frame*(conn_id: connection_id_t; remote_uid: uint32;
                                  stream_type: video_stream_type_e): cint {.
    importc: "agora_rtc_request_video_key_frame", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                              ##   @brief Request remote user to generate a keyframe for all video streams OR specific video stream.
                                                                              ##    @param[in] conn_id      Connection identification
                                                                              ##    @param[in] remote_uid   Remote user ID
                                                                              ##                            - if remote_uid is set 0, it's for all users
                                                                              ##                            - else it's for specific user
                                                                              ##    @param[in] stream_type    Stream type
                                                                              ##    @return
                                                                              ##    - = 0: Success
                                                                              ##    - < 0: Failure
                                                                              ## ```
proc rtc_send_audio_data*(conn_id: connection_id_t; data_ptr: pointer;
                          data_len: uint; info_ptr: ptr audio_frame_info_t): cint {.
    importc: "agora_rtc_send_audio_data", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                      ##   @brief Send an audio frame to all channels OR specific channel.
                                                                      ##           All remote users in this channel will receive the audio frame.
                                                                      ##    @note All channels that you joined will receive the audio frame that you send
                                                                      ##          unless you stop sending the local audio to a specific channel.
                                                                      ##    @param[in] conn_id   Connection identification
                                                                      ##    @param[in] data_ptr  Audio frame buffer
                                                                      ##    @param[in] data_len  Audio frame buffer length (bytes)
                                                                      ##    @param[in] info_ptr  Audio frame info, see #audio_frame_info_t
                                                                      ##    @return
                                                                      ##    - = 0: Success
                                                                      ##    - < 0: Failure
                                                                      ## ```
proc rtc_send_video_data*(conn_id: connection_id_t; data_ptr: pointer;
                          data_len: uint; info_ptr: ptr video_frame_info_t): cint {.
    importc: "agora_rtc_send_video_data", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                      ##   @brief Send a video frame to all channels OR specific channel.
                                                                      ##           All remote users in the channel will receive the video frame.
                                                                      ##    @note All channels that you join will receive the video frame that you send
                                                                      ##          unless you stop sending the local video to a specific channel.
                                                                      ##    @param[in] conn_id   Connection identification
                                                                      ##    @param[in] data_ptr  Video frame buffer
                                                                      ##    @param[in] data_len  Video frame buffer length (bytes)
                                                                      ##    @param[in] info_ptr  Video frame info
                                                                      ##    @return
                                                                      ##    - = 0: Success
                                                                      ##    - < 0: Failure
                                                                      ## ```
proc rtc_set_bwe_param*(conn_id: connection_id_t; min_bps: uint32;
                        max_bps: uint32; start_bps: uint32): cint {.
    importc: "agora_rtc_set_bwe_param", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                    ##   @brief Set network bandwdith estimation (bwe) param
                                                                    ##    @param[in] conn_id   : Connection identification, if set CONNECTION_ID_ALL(0) is for all connections
                                                                    ##    @param[in] min_bps   : bwe min bps
                                                                    ##    @param[in] max_bps   : bwe max bps
                                                                    ##    @param[in] start_bps : bwe start bps
                                                                    ##   
                                                                    ##    @return:
                                                                    ##    - = 0: Success
                                                                    ##    - < 0: Failure
                                                                    ## ```
proc rtc_set_params*(params: cstring): cint {.importc: "agora_rtc_set_params",
    cdecl, impagora_rtc_apiDyn.}
  ## ```
                                ##   Set config params
                                ##   
                                ##    @param [in] params : config params described by json
                                ##    @note  supported sets are shown below, they can be together in params json string
                                ##     - {"rtc.encryption": {"enable": true/false, "master_key": "xxx..."}}
                                ##     - {"rtc_network": { "type": INT_xx, "id": INT_xx, "update": true|false }}
                                ##    @return:
                                ##     - = 0: Success
                                ##     - < 0: Failure
                                ## ```
proc rtc_login_rtm*(rtm_uid: cstring; rtm_token: cstring;
                    handler: ptr rtm_handler_t): cint {.
    importc: "agora_rtc_login_rtm", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                ##   Login agora RTM service
                                                                ##    @param[in] rtm_uid   RTM user id (different from uid)
                                                                ##                         Length should be less than 64 bytes
                                                                ##                         Supported character scopes are:
                                                                ##                         - The 26 lowercase English letters: a to z
                                                                ##                         - The 26 uppercase English letters: A to Z
                                                                ##                         - The 10 numbers: 0 to 9
                                                                ##                         - The space
                                                                ##                         - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":",
                                                                ##                           ";", "<", "=", ".", ">", "?", "@", "[", "]", "^",
                                                                ##                           "_", " {", "}", "|", "~", ","
                                                                ##   @param[in] rtm_token  RTM token string generated by the token server (different from RTC token)
                                                                ##                         - if token authorization is enabled on developer website, it should be set correctly
                                                                ##                         - else token can be set as NULL
                                                                ##    @param[in] hanlder   A set of callback that handles Agora RTM events
                                                                ##   
                                                                ##    @return
                                                                ##    - = 0: Success
                                                                ##    - < 0: Failure
                                                                ## ```
proc rtc_logout_rtm*(): cint {.importc: "agora_rtc_logout_rtm", cdecl,
                               impagora_rtc_apiDyn.}
proc rtc_send_rtm_data*(rtm_uid: cstring; msg_id: uint32; msg: pointer;
                        msg_len: uint): cint {.
    importc: "agora_rtc_send_rtm_data", cdecl, impagora_rtc_apiDyn.}
  ## ```
                                                                    ##   Send data through Real-time Messaging (RTM) mechanism, which is a stable and reliable data channel
                                                                    ##    @note RTM channel is not available by default, unless login success and callback on_rtm_event
                                                                    ##            is triggered. The sending speed allowed is limited to 60 messages per second (60qps)
                                                                    ##   
                                                                    ##    @param[in] rtm_uid     RTM UID
                                                                    ##    @param[in] msg_id  Identify the message sent
                                                                    ##    @param[in] msg     Message to send
                                                                    ##    @param[in] msg_len Length of the message(max size: 32KB)
                                                                    ##   
                                                                    ##    @return:
                                                                    ##    - = 0: Success
                                                                    ##    - < 0: Failure
                                                                    ## ```
{.pop.}
