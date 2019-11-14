#!/bin/sh

container=$(grep -Po 'PROXY_CONTAINER_NAME=\K(.*)' ./.containerid)

docker exec -it ${container} bash