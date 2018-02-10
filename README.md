# mailcatcher docker image

Here is an unofficial Dockerfile for [PgBouncer][pgbouncer].

It is a very small image (~XX MB uncompressed) available on [docker hub][dockerhubpage] based on [Alpine Linux][alpinehubpage] and using the last available release from the official Github repo of [PgBouncer][pgbouncer].


## Changelog

- 2018-02-08 Initial version: PgBouncer 1.8.1 on Alpine Linux 3.7


## Usage

Get it:

    docker pull tophfr/pgbouncer

Run it:

    docker run --rm -it tophfr/pgbouncer -h
    docker run -d -e DEFAULT_HOST=db -e AUTH__POSTGRES=password tophfr/pgbouncer
    docker run -d -v $PWD:$PWD tophfr/pgbouncer $PWD/pgbouncer.ini

Environment variables:

| Variable name                  | Default value                | Description
| ------------------------------ | ---------------------------- | -----------
| `CONFIG_FILE`                  | /etc/pgbouncer/pgbouncer.ini |
| `DEFAULT_*i`                   |                              | Configuration for the defaut (`*`) database. See database section in [PgBouncer doc][pgbdoc_db] for available variable names.
| `CONF__DATABASES__*`           |                              | Variable name has to end with DB name and value should be populated as described in the [PgBouncer doc][pgbdoc_db].
| `CONF__DATABASES____`          |                              | Special value for `*` database. Generated if `DEFAULT_*` vars are defined.
| `CONF__PGBOUNCER__LISTEN_ADDR` | *                            | You should'nt touch this if you want pgbouncer to work in the docker world.
| `CONF__PGBOUNCER__LISTEN_PORT` | 5432                         |
| `CONF__PGBOUNCER__USER`        | postgres                     |
| `CONF__PGBOUNCER__AUTH_FILE`   | /etc/pgbouncer/auth.txt      |
| `CONF__PGBOUNCER__*`           | see [PgBouncer doc][pgbdoc]  | Variable name has to end with any PgBouncer setting. Please refer to [PgBouncer doc][pgbdoc_db].
| `CONF__USERS__*`               |                              | Will fill the users section of the config file. Please refer to [PgBouncer doc][pgbdoc_usr].
| `AUTH__*`                      |                              | Allow you to define a list of user/password tha will be put in the auth file.

/If you encounter any limitation by using env vars, please use your own config file and not the generated one./


## Build

Just clone this repo and run:

    docker-compose build pgbouncer


  [pgbouncer]: https://pgbouncer.github.io/ "Lightweight connection pooler for PostgreSQL"
  [pgbdoc]: https://pgbouncer.github.io/config.html "Lightweight connection pooler for PostgreSQL"
  [pgbdoc_db]: https://pgbouncer.github.io/config.html#section-databases "Lightweight connection pooler for PostgreSQL"
  [pgbdoc_usr]: https://pgbouncer.github.io/config.html#section-users "Lightweight connection pooler for PostgreSQL"
  [dockerhubpage]: https://hub.docker.com/r/tophfr/pgbouncer/ "PgBouncer docker hub page"
  [alpinehubpage]: https://hub.docker.com/_/alpine/ "A minimal Docker image based on Alpine Linux with a complete package index and only 5 MB in size!"
