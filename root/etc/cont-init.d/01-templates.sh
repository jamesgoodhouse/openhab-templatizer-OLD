#!/usr/bin/with-contenv bash

set -euo pipefail

mkdir -p "$CONFIGS_INPUT_DIR"
touch "$CONFIGS_INPUT_DIR/configs.yaml" "$CONFIGS_INPUT_DIR/secrets.yaml"

if [ "$WATCH_CONFIGS" = true ]; then
  echo setting up config watcher
  rm -f /etc/services.d/watchman/down
else
  build-openhab-configs
fi
