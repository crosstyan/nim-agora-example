toast -o src/agora.nim \
  --preprocess -m:c \
  -E_ -F_ \
  -E__ -F__ \
  -Eagora_ \
  -EAGORA_ \
  --pnim \
  --dynlib "agora_sdk/lib/aarch64/libagora-rtc-sdk.so" \
  agora_sdk/include/agora_rtc_api.h 
