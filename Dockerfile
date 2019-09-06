FROM debian:buster
LABEL MAINTAINER="docker@ix.ai"
ENV DEBIAN_FRONTEND=noninteractive TERM=linux DB_PORT=3306 DB_USER=root

COPY src/ /app

RUN chmod 755 /app/*.sh && \
    groupadd -g 666 mybackup && \
    useradd -u 666 -g 666 -d /backup -c "MariaDB Backup User" mybackup && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y mydumper && \
    apt-get -y --purge autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    find /var/log -type f | while read f; do echo -ne '' > $f; done;

VOLUME ["/backup"]
WORKDIR /backup

ENTRYPOINT ["/app/mariadb-backup.sh"]
