FROM docker.io/library/debian:buster-20220125

RUN \
  apt-get update \
  && \
  apt-get install -y \
    samba \
    tini \
  && \
  apt-get clean \
  && \
  /usr/share/samba/update-apparmor-samba-profile \
  && \
  mkdir /data

COPY root /

ENTRYPOINT ["tini", "-g", "--"]
CMD ["/usr/sbin/smbd", "--foreground", "--no-process-group", "--log-stdout", "--configfile=/etc/samba/smb.conf"]
