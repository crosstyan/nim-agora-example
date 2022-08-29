# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import agora as agora

when isMainModule:
  let version = $agora.rtc_get_version()
  echo "Agora version ", version
