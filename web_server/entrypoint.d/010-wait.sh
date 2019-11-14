#!/bin/bash


source /scripts/b-log.sh
LOG_LEVEL_ALL

DEBUG "Waiting for mysql"
until mysql -h database_server -P 3306 -uroot -p"$MYSQL_ROOT_PASSWORD" &> /dev/null
do
  printf "."
  sleep 1
done

DEBUG  "mysql ready"