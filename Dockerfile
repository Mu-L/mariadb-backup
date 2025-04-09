FROM public.ecr.aws/docker/library/debian:stable-slim@sha256:70b337e820bf51d399fa5bfa96a0066fbf22f3aa2c3307e2401b91e2207ac3c3
LABEL maintainer="mariadb-backup@docker.egos.tech" \
      org.opencontainers.image.source="https://gitlab.com/ix.ai/mariadb-backup" \
      org.opencontainers.image.url="https://egos.tech/mariadb-backup"

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
