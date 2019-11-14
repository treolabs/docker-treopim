#!/bin/bash

source ./web_server/scripts/b-log.sh
LOG_LEVEL_ALL

domain=$(grep -Po 'DOMAIN=\K(.*)' ./.env)
platform=$(grep -Po 'PLATTFORM=\K(.*)' ./.env)

echo $platform

if [[ $platform =~ 'TREO'  ]]; then
if [[ ! -d ../$domain ]]; then
	mkdir -m777 -p ../$domain
	if [ $? -ne 0 ]; then
		FATAL "Check righs for create direcroty $(dirname "$(pwd)")/$domain"
		exit
	fi
fi

if [[ -w ../$domain ]]; then
	INFO "Directory $domain is writable"
else
	FATAL "Directory $domain is not writable. Check rights for the directory $(dirname "$(pwd)")/$domain "
	exit
fi

fi

if [ ! -f ./.env ]; then
	FATAL "File .env is not found. You must have a .env file in directory"
	exit
fi

if [ ! -f ./.containerid ]; then
	INFO "File .containerid is not found.containerid file in directory"
	INFO "Create .containerid file in directory"
	touch .containerid
	printf "MYSQL_CONTAINER_NAME=\nAPACHE_CONTAINER_NAME=\nPROXY_CONTAINER_NAME=\n" >.containerid
fi

if grep "MYSQL_CONTAINER_NAME\|APACHE_CONTAINER_NAME\|PROXY_CONTAINER_NAME" ./.containerid; then

	project_name=$(git rev-parse --show-toplevel)
	project_name=${project_name##*/}

	if [ -z $project_name ]; then

		project_name="${PWD##*/}"
		commit='treolabs'

	else
		commit=$(git rev-parse HEAD | awk '{print substr($0,1,7);exit}')
	fi

	hash=$project_name-$commit

	sed -i 's/^MYSQL_CONTAINER_NAME=.*/MYSQL_CONTAINER_NAME='$hash-DB'/' ./.containerid
	export MYSQL_CONTAINER_NAME=$hash-DB
	sed -i 's/^APACHE_CONTAINER_NAME=.*/APACHE_CONTAINER_NAME='$hash-WEB'/' ./.containerid
	export APACHE_CONTAINER_NAME=$hash-WEB
	sed -i 's/^PROXY_CONTAINER_NAME=.*/PROXY_CONTAINER_NAME='$hash-PROXY'/' ./.containerid
	export PROXY_CONTAINER_NAME=$hash-PROXY
else
	FATAL "The .containerid file has corrupted."
	rm -i ./.containerid
fi

export UID_U=$UID
export GID_U=$(id -g)

DEBUG "###### Down dockers container #####"
docker-compose down

DEBUG "###### Up dockers container #####"
docker-compose build
docker-compose up
