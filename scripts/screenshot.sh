#!/bin/bash

USE_SWAPPY=false
PLAIN_SAVE_PATH=$(date +"screenshot-%Y%m%d-%H%M%S.png")

while [[ $# -gt 0 ]]; do
  case "$1" in
    --swappy)
      USE_SWAPPY=true
      shift
      ;;
    *)
  esac
done

grim -g "$(slurp)" - | tee "$PLAIN_SAVE_PATH" | wl-copy --type image/png

if [ "$USE_SWAPPY" = true ]; then
  swappy -f "$PLAIN_SAVE_PATH"
  rm "$PLAIN_SAVE_PATH"
fi
