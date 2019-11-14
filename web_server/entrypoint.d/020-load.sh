#!/bin/bash

source /scripts/b-log.sh
LOG_LEVEL_ALL

source /scripts/utils.sh



INFO "We are using " ${MYSQL_DATABASE}" for "${PLATTFORM}

INFO "Config a cronjob"

crontab -l -u www-data | { cat;	printf "MAILFROM=cron@domain.com\nMAILTO=root@treolabs.com\n"; } | crontab -u www-data -

if CheckBb; then
	empty_database=true

	INFO "Try to load a dump from /data/dumps"

	databases=$(ls /home/*.sql) >/dev/null
	for file in $databases; do
		if [[ -f $file && $(wc -c <$file) > 0 ]]; then
			echo "Found some SQL dumps in /docker/data/dumps"
			echo "$(ls -la /home/*.sql)"
			echo "Try to load dump of "$file
			mysql -h database_server -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} <$file 2>/var/log/docker/mysql.err
			if [ $? -eq 0 ]; then
				echo "Dump $file has been success load in ${MYSQL_DATABASE}"
				mv $file $file.load
				empty_database=false
			else
				ERROR "Error load file $file to database server "
			fi
		else
			WARN "Any dump found in the directory /docker/data/dumps"
		fi
	done

	if $empty_database; then

		INFO "Try to load a dump from remote MySQL server"

		mysqldump -h${MYSQL_REMOTE_HOST} -u ${MYSQL_REMOTE_USER} --password=${MYSQL_REMOTE_PASSWORD} ${MYSQL_REMOTE_DATABASE} >/home/db.sql 2>/var/log/docker/mysql.err
		if [[ "$?" -eq 0 && $(wc -c <"/home/db.sql") > 0 ]]; then
			echo "mysqldump successfully finished at $(date +'%d-%m-%Y %H:%M:%S')"$'\r'
			mysql -h database_server -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} </home/db.sql 2>/var/log/docker/mysql.err
			if [ $? -eq 0 ]; then
				echo "Dump /home/db.sql  has been success load in ${MYSQL_DATABASE}"
				mv /home/db.sql /home/db.sql.load
				empty_database=false
			else
				ERROR "Error load the file /home/db.sql from Apache container to database server. Check file content."
			fi

		else
			WARN "Any dump found on the remote server $(cat /var/log/docker/mysql.err)"
		fi

	fi



	if [[ ${PLATTFORM} == "TREOPIM" || ${PLATTFORM} == "TREOCORE" || ${PLATTFORM} == "TREODAM" ]] && $empty_database; then
		DIR="/var/www/html/${DOMAIN}"
		if [ "$(ls -A $DIR)" ]; then
			WARN "The project for ${PLATTFORM} is not empty in $DIR"
		else

			NOTICE "Install ${PLATTFORM}"

			cd /var/www/html && sudo -u www-data composer create-project treolabs/skeleton ${DOMAIN} --no-dev --prefer-dist &&
			cd ${DOMAIN} && sudo -u www-data composer require --no-update treolabs/pim:* && sudo -u www-data composer update --no-dev
			sed -ri 's/DocumentRoot \/var\/www\/html$/DocumentRoot \/var\/www\/html\/'${DOMAIN}'/g' /etc/apache2/sites-available/000-default.conf
			cd /var/www/html/${DOMAIN} && sudo -u www-data chmod +x ./bin/cron.sh

			crontab -l -u www-data | { cat; printf "\n* * * * * /var/www/html/${DOMAIN}/bin/cron.sh process-treocore php\n"; } | crontab -u www-data -
			INFO "Current crontab is $(crontab -l -u www-data)"

			sed -ri "s/'localhost'/'database_server'/g" /var/www/html/${DOMAIN}/data/config.php
			sed -ri "s/'dbname'\s*=>\s*'\s*'/'dbname' => '${MYSQL_DATABASE}'/g" /var/www/html/${DOMAIN}/data/config.php
			sed -ri "s/'user'\s*=>\s*'\s*'/'user' => 'root'/g" /var/www/html/${DOMAIN}/data/config.php
			sed -ri "s/'password'\s*=>\s*'\s*'/'password' => '${MYSQL_ROOT_PASSWORD}'/g" /var/www/html/${DOMAIN}/data/config.php

			echo '###########################'
			NOTICE "Open in the browser http://localhost:${WEB_PORT} for continue installation"
			echo '###########################'

		fi

	fi


else
	NOTICE "Database ${PLATTFORM} already load"
fi

INFO "Update alies for sendmail"
newaliases
