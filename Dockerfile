FROM alpine:3.7

MAINTAINER toph <toph@toph.fr>

ARG PGBOUNCER_VERSION=1.7.2
ARG PGBOUNCER_SHA256=de36b318fe4a2f20a5f60d1c5ea62c1ca331f6813d2c484866ecb59265a160ba

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

