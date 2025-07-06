#!/bin/bash

USE_SWAPPY=false
TAKE_FULLSCREEN=false
PLAIN_SAVE_PATH="/home/dragsbruh/Pictures/screenshots/$(date +"screenshot-%Y%m%d-%H%M%S.png")"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --swappy)
      USE_SWAPPY=true
      shift
      ;;
    --fullscreen)
      TAKE_FULLSCREEN=true
      shift
      ;;
    *)
      shift
      ;;
  esac
done

if [[ "$TAKE_FULLSCREEN" == true ]]; then
  grim - | tee "$PLAIN_SAVE_PATH" | wl-copy --type image/png
else
  grim -g "$(slurp)" - | tee "$PLAIN_SAVE_PATH" | wl-copy --type image/png
fi

if [ "$USE_SWAPPY" = true ]; then
  swappy -f "$PLAIN_SAVE_PATH"
  rm "$PLAIN_SAVE_PATH"
fi
