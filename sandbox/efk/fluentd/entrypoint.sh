#!/bin/sh

# Source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r "$DEFAULT" ]; then
    set -o allexport
    . "$DEFAULT"
    set +o allexport
fi

# If the user has supplied only arguments, prepend `fluentd`
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then
    if ! echo "$@" | grep -q -e ' -c' -e ' --config' ; then
        set -- "$@" --config /fluentd/etc/${FLUENTD_CONF:-fluent.conf}
    fi

    if ! echo "$@" | grep -q -e ' -p' -e ' --plugin' ; then
        set -- "$@" --plugin /fluentd/plugins
    fi
fi

exec "$@"
