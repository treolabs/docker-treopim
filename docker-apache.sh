#!/bin/sh

container=$(grep -Po 'APACHE_CONTAINER_NAME=\K(.*)' ./.containerid)

docker exec -it ${container} bash
