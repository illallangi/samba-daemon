FROM docker.io/library/debian:buster-20220228
ARG S6_OVERLAY_VERSION="3.0.0.2-2"

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    samba=2:4.9.5+dfsg-5+deb10u3 \
    xz-utils=5.2.4-1 \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/* \
  && \
  /usr/share/samba/update-apparmor-samba-profile \
  && \
  mkdir /data

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz

COPY root /

ENTRYPOINT ["/init"]
CMD ["/usr/sbin/smbd", "--foreground", "--no-process-group", "--log-stdout", "--configfile=/config/smb.conf"]
