#!/bin/sh

container=$(grep -Po 'MYSQL_CONTAINER_NAME=\K(.*)' ./.containerid)

docker exec -it ${container} bash