# Docker Containers Configuration Description

These Docker images are designed for faster deployment of TreoPIM than LAMP or other method of local deployment. Having executed `docker-run`, the script will automatically put up containers with Apache and PHP, MySQL, PphMyadmin, and MailHog. Also, it will automatically clone the latest TreoPIM version from GitHub.

If that script is completed successfully, you will have to open the http://localhost:8081 link to continue the [installation](#installation-and-setup) via the web installer.

## Project Structure

| Folder/File               | Description              |
|:--------------------------|:-------------------------| 
|**``docker-run.sh``**      | main script for starting all containers  |     
|**``.env``**                | main configuration file				|  
| ``data``                   | folder with user data          | 
|``web_server``              | list files for web server (Apache + PHP)   |     
|``docker-apache.sh``       | connection to the container with web server  |    
|``docker-mysql.sh``        | connection to the container with MySQL server  |       
|``docker-clean.sh``        | script for cleaning downloaded Docker images |     
|``docker-compose.yml``     | settings for Docker compose   |     
|``.dockerignore``          | the list of files to be ignored by the Docker container  | 
|``.gitattributes``         | Git settings  |     
|``.gitignore``              | the list of files to be ignored by Git | 

## Installation and Setup

1. Install [Docker](https://docs.docker.com/install/linux/docker-ce/debian/) and be sure to follow the post-installation instructions given [here](https://docs.docker.com/install/linux/linux-postinstall/). This will allow Docker and Apache in Docker to run from the main user in the system, and there will be no issues with access rights.

2. For start and restart it is convenient to use the `docker-run.sh` script, since it rebuilds and launches the Docker containers.

3. When you encounter any problems, you can use the `docker-clean.sh` script to delete all images, containers, and sections.

4. The initial Docker setup is to configure the `.env` file parameters.

### Main Parameters Description
 
**DOMAIN** – indicates the target folder for the cloned project. In case of cloning, this folder will be indicated as _DocumentRoot_. 

Without cloning projects in the container, _DocumentRoot_ has the _/var/www/html_ path.

> DOMAIN=localhost

> The default value is _localhost_

**PLATFORM** – indicates the platform type, influences the teams after the container deployment. Platforms TREOPIM, TREOCORE, TREODAM should be defined.

> PLATFORM=TREOPIM

> The default value is _TREOPIM_

> Allowed values are TREOPIM, TREOCORE, TREODAM.

**APACHE_PORT** – port, on which the Apache web server is available. The address is http://localhost:8081. 

> APACHE_PORT=8081

> The default value is _8081_
 
**MAILHOG_PORT** – port for MailHog, available on http://localhost:8025, assigned for viewing mail. Also all system errors in the container will be sent to MailHog.

> MAILHOG_PORT=8025

> The default value is _8025_

**PHPMYADMIN_PORT** – port for connecting to phpMyAdmin, available on http://localhost:8084.

> PHPMYADMIN_PORT=8084

> The default value is _8084_

**MYSQL_PORT** – port for external connection to the MySQL server, for instance, through  MySQL Workbench. The connection settings are `host:localhost port:13306`.

> MYSQL_PORT=1306

> The default value is _1306_

**PHP_VER** – the PHP version in the container; for Apache and CLI.

> PHP_VER=7.3

> The default value is _7.3_

> Allowed values are 7.1, 7.2, 7.3.

**MYSQL_DATABASE** – the local DB name in the `database_server` container.
 
> MYSQL_DATABASE=db

> The default value is _db_

**MYSQL_USER** – the name of the local DB user in the `database_server` container. 

> MYSQL_USER=db

> The default value is _db_

**MYSQL_PASSWORD** – the password of the local DB user in the `database_server` container. 

> MYSQL_PASSWORD=db

> The default value is _db_

**MYSQL_ROOT_PASSWORD** – the password of the root user to the local DB in the `database_server` container. This password can be used for external connection. 

> MYSQL_ROOT_PASSWORD=root

**MYSQL_REMOTE_DATABASE** – the remote DB name, which is to be defined for downloading the DB from the remote server. 

> MYSQL_REMOTE_DATABASE=docker

**MYSQL_REMOTE_USER** – the name of the DB user for connecting to the `MYSQL_REMOTE_HOST` remote server. 

> MYSQL_REMOTE_USER=docker

**MYSQL_REMOTE_PASSWORD** – the password of the DB user for connecting to the `MYSQL_REMOTE_HOST` remote server.  

> MYSQL_REMOTE_PASSWORD=docker

**MYSQL_REMOTE_HOST** – the remote host for DB cloning. A standard `3306` port is used. 

> MYSQL_REMOTE_HOST=db.treotest.com

On the startup, the system will automatically check if the DB has been previously deployed, and if it hasn't, the system will try to receive the latest backup from the `/data/dumps/*.sql` folder. If no backup is found in the folder, there will be an attempt to receive the DB from the MySQL remote server.

On the first launch of Docker, this process takes several minutes, so the first Docker launch may take up to 10 minutes. The DB is stored locally in the `/data/mysql` folder. 

### Project Structure in Docker

The main project must be stored in the root folder, i.e. the project folder must be `/home/project`, and the Docker folder must be located in the `/home/project/docker` folder.

```./
└── home
    └── localhost - There is Treo family project folder
        └── docker - Docker folder
        │   ├── data
        │   │   ├── dumps
        │   │   ├── images
        │   │   ├── logs
        │   │   └── mysql
        │   └── web_server
        │       ├── php7.1
        │       ├── php7.2
        │       ├── php7.3
        │       └── scripts
        └── index.php - project file located in the `project1` folder
```

- Database host to connect to within Docker: `database_server`.
- Mail sending server: `mail.server:1025`.
- Environment variables in order to understand that we are in Docker: `ENV=DOCKER`.

### Connecting to Docker Containers

The following helping scripts are available in the system: `docker-apache(mysql).sh`. These scripts are aimed at connecting to the corresponding container.

### Features of Containers Launched in Docker

1. To enable redirecting of mail to MailHog, the SMTP server must be configured in the system: `mail.server:1025`.

2. The PHP settings are located in the `./web_server/phpX.X/config` folder. Having made any changes, the container should be reloaded.

3. Adding crons to the www-data user should be done in the following format:
			`crontab -l -u www-data | {
				cat;
				printf "\n* * * * * COMMAND\n";
			} | crontab -u www-data -`

### Troubleshooting

1. Validation in PhpStorm is completed, but breakpoints don't work. In the Xdebug settings we have `xdebug.remote_connect_back = 1`, which means that Xdebug is automatically connecting to the same IP, from which the request has been sent. If validation in PhpStorm works, but there is no connection, it is necessary to check if the 9000 port is open on the host machine.

	The port can be opened via the ``ufw allow 9900`` command.

2. Also the PhpStorm configuration is to be checked:  

![Xdebug](./data/images/xdebugconfig_2.png)

![Xdebug](./data/images/xdebugconfig.png)

