FROM debian:stable-slim@sha256:bd62e440b609d33ee4236b181383380ddc6890572de5cea1249a43cd596fff42
LABEL maintainer="docker@ix.ai" \
      ai.ix.repository="ix.ai/mariadb-backup"

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
