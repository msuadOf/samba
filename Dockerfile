FROM alpine:3.12
MAINTAINER David Personette <dperson@gmail.com>

# Install samba
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash samba shadow tini tzdata && \
    echo -e "123424\n123424" | smbpasswd -s -a root && \
    useradd zz && echo -e "123424\n123424" | smbpasswd -s -a  zz  && \
    rm -rf /tmp/*

COPY samba.sh /usr/bin/

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --interval=60s --timeout=15s \
            CMD smbclient -L \\localhost -U % -m SMB3

VOLUME ["/etc", "/var/cache/samba", "/var/lib/samba", "/var/log/samba",\
            "/run/samba"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/samba.sh"]
