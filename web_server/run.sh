#!/bin/bash

source /scripts/b-log.sh
LOG_LEVEL_ALL

DIR=/autostart

DEBUG "Execute customs srirpts from  $DIR"
if [[ -d "$DIR" ]]; then
	/bin/run-parts --verbose --regex '\.sh$' "$DIR"
fi

exec "$@"

service cron restart

tail -F /var/log/apache2/*.log
