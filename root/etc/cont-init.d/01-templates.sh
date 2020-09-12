#!/usr/bin/with-contenv bash

mkdir -p "$TEMPLATES_INPUT_DIR"
touch "$TEMPLATES_INPUT_DIR/configs.yaml" "$TEMPLATES_INPUT_DIR/secrets.yaml"

if [ "$WATCH_TEMPLATES" = true ]; then
  echo setting up template watcher
  rm -f /etc/services.d/watchman/down
else
  build-openhab-configs
fi
