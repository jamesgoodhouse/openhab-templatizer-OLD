ARG GOMPLATE_VERSION=3.8.0
ARG OPENHAB_VERSION=2.5.8
ARG S6_OVERLAY_VERSION=2.0.0.1
ARG WATCHMAN_VERSION=2020.09.07.00

################################################################################

# would skip this but COPY --from doesn't do interpolation of ARGs
FROM hairyhenderson/gomplate:v${GOMPLATE_VERSION}-slim as gomplate

################################################################################

# patch entrypoint.sh to remove "s6-style" cont-init.d stuff that conflicts with actual s6
FROM openhab/openhab:$OPENHAB_VERSION as patched_entrypoint
COPY entrypoint.patch /
RUN apt-get update && \
    apt-get install -y patch && \
    patch /entrypoint.sh < /entrypoint.patch

################################################################################

FROM busybox:latest as s6
ARG S6_OVERLAY_TARBALL=s6-overlay-amd64.tar.gz
ARG S6_OVERLAY_VERSION
ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/$S6_OVERLAY_TARBALL /
RUN mkdir /s6 && tar xzf /$S6_OVERLAY_TARBALL -C /s6

################################################################################

FROM busybox:latest as watchman
ARG WATCHMAN_VERSION
ARG WATCHMAN_PATH=watchman-v$WATCHMAN_VERSION-linux
ARG WATCHMAN_ZIP=$WATCHMAN_PATH.zip
RUN wget https://github.com/facebook/watchman/releases/download/v$WATCHMAN_VERSION/$WATCHMAN_ZIP && \
    unzip $WATCHMAN_ZIP && mv $WATCHMAN_PATH watchman

################################################################################

FROM openhab/openhab:$OPENHAB_VERSION

COPY root /

# setup s6 overlay
COPY --from=s6 /s6 /
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# setup template stuff
COPY --from=gomplate /gomplate /usr/local/bin/gomplate
ENV CONFIGS_INPUT_DIR=/usr/local/etc/openhab
ENV CONFIGS_OUTPUT_DIR=$OPENHAB_CONF
ENV VERBOSE_CONFIG_BUILD=false
ENV WATCH_CONFIGS=false

# add patched entrypoint.sh
COPY --from=patched_entrypoint /entrypoint.sh /entrypoint.sh

# setup watchman
COPY --from=watchman /watchman /usr/local
RUN mkdir -p /usr/local/var/run/watchman && \
    chmod 755 /usr/local/bin/watchman && \
    chmod 2777 /usr/local/var/run/watchman

ENTRYPOINT ["/init"]

CMD ["gosu", "openhab", "tini", "-s", "/openhab/start.sh", "server"]
