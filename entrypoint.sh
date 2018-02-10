#!/bin/bash

set -e

if [ "$CONFIG_FILE" != '' ]; then

    if [ ! -f "$CONFIG_FILE" ]; then

        mkdir -p $(dirname "$CONFIG_FILE")
        
        tmpfile="$(mktemp)"
        env | grep ^DEFAULT_ | while IFS='=' read name value ; do
            name=${name#DEFAULT_}
            name=$(echo $name | tr '[:upper:]' '[:lower:]')
            CONF__DATABASES____="${CONF__DATABASES____}$name=$value "
            echo -n "$CONF__DATABASES____" > "$tmpfile"
        done
        tmpcontent="$(cat "$tmpfile")"
        if [ "$tmpcontent" != '' ]; then
            export CONF__DATABASES____="$tmpcontent"
        fi
        rm -f "$tmpfile"

        env | grep ^CONF_ | sort | while IFS='=' read name value ; do
            name=${name#CONF__}
            name=${name//__/.}
            name=$(echo $name | tr '[:upper:]' '[:lower:]')
            section=$(echo "$name" | cut -d. -f1)
            name=${name#${section}.}
            if [ "$section" != "$last_section" ]; then
                last_section="$section"
                echo >> "$CONFIG_FILE"
                echo "[$section]" >> "$CONFIG_FILE"
            fi
            if [ "$name" = '.' ]; then
                name='*'
            fi
            echo "$name = $value" >> "$CONFIG_FILE"
        done
    fi

    if [ "$CONF__PGBOUNCER__AUTH_FILE" != '' -a ! -f "$CONF__PGBOUNCER__AUTH_FILE" ]; then
        mkdir -p $(dirname "$CONF__PGBOUNCER__AUTH_FILE")
        env | grep ^AUTH__ | while IFS='=' read user pass ; do
            user=${user#AUTH__}
            user=$(echo $user | tr '[:upper:]' '[:lower:]')
            echo "\"$user\" \"$pass\"" >> "$CONF__PGBOUNCER__AUTH_FILE"
        done
        chmod 600 "$CONF__PGBOUNCER__AUTH_FILE"
    fi
fi

if [ $# -gt 0 ]; then
    if [ "${1#-}" != "$1" ] || [ "${1/#.ini}" != "$1" ]; then
        set -- pgbouncer "$@"
    fi
    exec "$@"
else
    exec pgbouncer "$CONFIG_FILE"
fi

# vim: ts=4 sts=4 sw=4 et:
