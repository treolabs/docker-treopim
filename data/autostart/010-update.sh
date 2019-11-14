#!/bin/bash

source /scripts/b-log.sh
LOG_LEVEL_ALL

source /scripts/utils.sh

NOTICE "We are using database ${MYSQL_DATABASE} for  platform ${PLATTFORM}"

#uncomment for cron

#crontab -l -u www-data | {
#	cat
#	printf "\n* * * * * php COMMAND \n"
#} | crontab -u www-data -

