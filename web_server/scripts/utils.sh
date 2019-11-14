#!/usr/bin/env bash


function CheckBb() {

	if [ ${PLATTFORM} == 'OXID' ] || [ ${PLATTFORM} == 'OXID6' ]; then
		MYSQL_CHECKDATA=$(mysql -h database_server -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} --skip-column-names -e "SHOW TABLES FROM ${MYSQL_DATABASE} LIKE '%oxconfig';")
	fi

	if [ ${PLATTFORM} == "SHOPWARE" ]; then
		MYSQL_CHECKDATA=$(mysql -h database_server -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} --skip-column-names -e "SHOW TABLES FROM ${MYSQL_DATABASE} LIKE '%core_config_elements';")
	fi

	if [ ${PLATTFORM} == "MAGENTO" ]; then
		MYSQL_CHECKDATA=$(mysql -h database_server -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} --skip-column-names -e "SHOW TABLES FROM ${MYSQL_DATABASE} LIKE '%core_config_data';")
	fi

	if [ ${PLATTFORM} == "ESPO" ]; then
		MYSQL_CHECKDATA=$(mysql -h database_server -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} --skip-column-names -e "SHOW TABLES FROM ${MYSQL_DATABASE} LIKE '%account_portal_user';")
	fi

	if [ ${PLATTFORM} == "TREOPIM" ] || [ ${PLATTFORM} == "TREOCORE" ] || [ ${PLATTFORM} == "TREODAM" ]; then
		MYSQL_CHECKDATA=$(mysql -h database_server -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} --skip-column-names -e "SHOW TABLES FROM ${MYSQL_DATABASE} LIKE '%entity_team';")
	fi

	if [[ -z $MYSQL_CHECKDATA ]]; then
		true
	else
		false
	fi

}