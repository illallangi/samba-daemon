FROM docker.io/library/debian:buster-20220228

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    samba=2:4.9.5+dfsg-5+deb10u3 \
    tini=0.18.0-1 \
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
