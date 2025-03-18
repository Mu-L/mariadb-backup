FROM public.ecr.aws/docker/library/debian:stable-slim@sha256:a11850f246c52f46d46e985b707eeff6a658fd4909bf6d4a72ba620d12df6ea7
LABEL maintainer="docker@ix.ai" \
      ai.ix.repository="ix.ai/mariadb-backup" \
      org.opencontainers.image.source="https://gitlab.com/ix.ai/mariadb-backup"

VOLUME ["/backup"]
WORKDIR /backup

RUN set -xeu; \
    export DEBIAN_FRONTEND=noninteractive; \
    export TERM=linux; \
    groupadd -g 666 mybackup; \
    useradd -u 666 -g 666 -d /backup -c "MariaDB Backup User" mybackup; \
    apt-get update; \
    apt-get -y dist-upgrade; \
    apt-get install -y mydumper; \
    apt-get -y --purge autoremove; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*; \
    find /var/log -type f | while read f; do echo -ne '' > $f; done;

COPY mariadb-backup.sh /usr/local/bin/mariadb-backup

ENV DB_PORT=3306 DB_USER=root

ENTRYPOINT ["/usr/local/bin/mariadb-backup"]
