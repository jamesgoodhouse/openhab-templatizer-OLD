#!/usr/bin/with-contenv bash

if [ "$WATCH_TEMPLATES" = true ]; then
  echo setting up template watcher
  rm -f /etc/services.d/watcher/down
fi
