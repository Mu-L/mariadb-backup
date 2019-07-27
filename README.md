About
=====

The mysql-backup Docker image will provide you a container to backup and restore a [MySQL](https://hub.docker.com/_/mysql/) or [MariaDB](https://hub.docker.com/_/mariadb/) database container.

The backup is made with [mydumper](http://centminmod.com/mydumper.html), a fast MySQL backup utility.

Usage
=====

To backup a [MySQL](https://hub.docker.com/_/mysql/) or [MariaDB](https://hub.docker.com/_/mariadb/) database, you simply specify the credentials and the host. You can optionally specify the database as well.

Environment variables
=====================

* `DB_HOST` (mandatory, no default): The host to connect to
* `DB_PASS` (mandatory, no default): The password to use
* `DB_NAME` (optional, no default): If specified, only this database will be backed up
* `DB_PORT` (optional, default `3306`): The password for the SQL server
* `DB_USER` (optional, default `root`): The user to connect to the SQL server

Please note the backup will be written to `/backup` by default, so you might want to mount that directory from your host.

Example Docker CLI client
-------------------------

To __create a backup__ from a MySQL container via `docker` CLI client:

```bash
docker run --name my-backup -e DB_HOST=mariadb -e DB_PASS=amazing_pass -v /var/mysql_backups:/backup registry.gitlab.com/ix.ai/mariadb-backup
```

The container will stop automatically as soon as the backup has finished.
To create more backups in the future simply start your container again:

```bash
docker start my-backup
```

To __restore a backup__ into a MySQL container via `docker` CLI client:

```bash
docker run --name my-restore -e DB_HOST=mariadb -e DB_PASS=amazing_pass -v /var/mysql_backups:/backup registry.gitlab.com/ix.ai/mariadb-backup
```

Configuration
=============

Mode
----

By default the container backups the database.
However, you can change the mode of the container by setting the following environment variable:

* `MODE`: Sets the mode of the backup container while [`BACKUP`|`RESTORE`]

Base directory
--------------

By default the base directory `/backup` is used.
However, you can overwrite that by setting the following environment variable:

* `BASE_DIR`: Path of the base directory (aka working directory)

Restory directory
-----------------

By default the container will automatically restore the latest backup found in `BASE_DIR`.
However, you can manually set the name of a backup directory underneath `BASE_DIR`:

* `RESTORE_DIR`: Name of a backup directory to restore

_This option is only required when the container runs in in `RESTORE` mode._

UID and GID
-----------

By default the backup will be written with UID and GID `666`.
However, you can overwrite that by setting the following environment variables:

* `BACKUP_UID`: UID of the backup
* `BACKUP_GID`: GID of the backup

umask
-----

By default a `umask` of `0022` will be used.
However, you can overwrite that by setting the following environment variable:

* `UMASK`: Umask which should be used to write the backup files

mydumper / myloader CLI options
-------------------------------

By default `mydumper` is invoked with the `-c` (compress backup) and `myloader` with the `-o` (overwrite tables) CLI option.
However, you can modify the CLI options by setting the following environment variable:

* `OPTIONS`: Options passed to `mydumper` (when `MODE` is `BACKUP`) or `myloader` (when `MODE` is `RESTORE`)

Credits
=======

Special thanks to [confirm/docker-mysql-backup](https://github.com/confirm/docker-mysql-backup), which this project uses heavily.
