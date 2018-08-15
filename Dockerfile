FROM alpine:3.8

MAINTAINER toph <toph@toph.fr>

ARG PGBOUNCER_VERSION=1.9.0
ARG PGBOUNCER_SHA256=39eca9613398636327e79cbcbd5b41115035bca9ca1bd3725539646468825f04

ENV PGBOUNCER_VERSION $PGBOUNCER_VERSION
RUN apk add --no-cache libevent openssl c-ares \
    && apk add --no-cache --virtual .build-deps git build-base automake libtool m4 autoconf libevent-dev openssl-dev c-ares-dev \
    && wget https://pgbouncer.github.io/downloads/files/$PGBOUNCER_VERSION/pgbouncer-$PGBOUNCER_VERSION.tar.gz \
    && echo "$PGBOUNCER_SHA256  pgbouncer-$PGBOUNCER_VERSION.tar.gz" | sha256sum -c - \
    && tar xzf pgbouncer-$PGBOUNCER_VERSION.tar.gz \
    && cd pgbouncer-$PGBOUNCER_VERSION \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local --with-libevent=/usr/lib \
    && make \
    && make install \
    && cd .. \
    && rm -Rf pgbouncer-$PGBOUNCER_VERSION* \
    && apk del .build-deps

RUN apk add --no-cache bash

# default config values
ENV CONFIG_FILE /etc/pgbouncer/pgbouncer.ini
ENV CONF__PGBOUNCER__LISTEN_ADDR *
ENV CONF__PGBOUNCER__LISTEN_PORT 5432
ENV CONF__PGBOUNCER__USER postgres
ENV CONF__PGBOUNCER__AUTH_FILE /etc/pgbouncer/auth.txt

COPY ./entrypoint.sh /usr/local/bin/docker-pgbouncer-entrypoint.sh

EXPOSE $CONF__PGBOUNCER__LISTEN_PORT

ENTRYPOINT ["/usr/local/bin/docker-pgbouncer-entrypoint.sh"]

