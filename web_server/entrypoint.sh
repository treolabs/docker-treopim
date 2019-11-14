#!/usr/bin/env bash
set -e

source /scripts/b-log.sh
LOG_LEVEL_ALL

DEBUG "Set version for PHP = $PHP_VER"

service apache2 stop
rm -rf /var/run/apache2/

a2dismod php5.6 php7.0 php7.1 php7.2 php7.3

a2enmod php$PHP_VER

update-alternatives --set php /usr/bin/php$PHP_VER

usermod -u $USER_UID www-data && groupmod -g $USER_GID www-data

DEBUG 'Restart Apache, Cron'

service apache2 start


DIR=/entrypoint.d

DEBUG "Execute require srirpts from  $DIR"

if [[ -d "$DIR" ]]; then
	/bin/run-parts --verbose --regex '\.sh$' "$DIR"
fi

exec "$@"
