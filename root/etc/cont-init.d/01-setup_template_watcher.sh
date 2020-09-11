#!/usr/bin/with-contenv bash

if [ "$WATCH_TEMPLATES" = true ]; then
  echo setting up template watcher
  useradd --no-create-home --shell=/usr/sbin/nologin --home-dir=/usr/local/var/run/watchman watchman
  rm -f /etc/services.d/watcher/down
fi
