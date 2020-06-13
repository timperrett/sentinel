#!/bin/bash

OUTPUT_FILE="/tmp/sentinel.jpg"
OUTPUT_TITLE="eventually.house"
OUTPUT_RESOLUTION="1920x1080"

fswebcam -r "${OUTPUT_RESOLUTION}" \
  --jpeg 85 -F 80 \
  --banner-colour \#000000 \
  --line-colour \#ffffff \
  --title "${OUTPUT_TITLE} ($(date +%B))" \
  "${OUTPUT_FILE}"
