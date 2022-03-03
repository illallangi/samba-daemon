FROM docker.io/library/debian:buster-20220228

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    samba \
    tini \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/* \
  && \
  /usr/share/samba/update-apparmor-samba-profile \
  && \
  mkdir /data

COPY root /

ENTRYPOINT ["tini", "-g", "--", "custom-entrypoint"]
CMD ["/usr/sbin/smbd", "--foreground", "--no-process-group", "--log-stdout", "--configfile=/config/smb.conf"]
