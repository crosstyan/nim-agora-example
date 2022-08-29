# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import agora as agora
import gintro/gst as gst
import gintro/gstapp as gstapp

when isMainModule:
  let version = $agora.rtc_get_version()
  let gstVersion = gst.versionString()
  echo "Agora version ", version
  echo gstVersion
