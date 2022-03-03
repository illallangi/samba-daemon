FROM docker.io/library/debian:buster-20220125

RUN \
  apt-get update \
  && \
  apt-get install -y samba \
  && \
  apt-get clean

RUN /usr/share/samba/update-apparmor-samba-profile

CMD ["/usr/sbin/smbd", "--foreground", "--no-process-group", "--log-stdout"]
