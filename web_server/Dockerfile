FROM debian:buster

RUN echo "deb http://ftp.de.debian.org/debian/ stable main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://ftp.de.debian.org/debian/ stable-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ stable/updates main" >> /etc/apt/sources.list && \
    echo "deb http://ftp.debian.org/debian buster-backports main" >> /etc/apt/sources.list && \
    apt-get update && apt-get -yq upgrade &&\
    DEBIAN_FRONTEND=noninteractive apt-get -yq install wget apt-transport-https lsb-release ca-certificates

# Install base packages
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &&\
 echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list &&\
 apt-get update &&\
 DEBIAN_FRONTEND=noninteractive apt-get -yq install \
 fonts-freefont-ttf \
 curl \
 unzip \
 nodejs \
 npm \
 apt-utils \
 wget \
 zip \
 gnupg \
 ghostscript \
 imagemagick \
 libmcrypt4 \
 apache2 \
 php5.6 \
 php7.0 \
 php7.1 \
 php7.2 \
 php7.3 \
 php5.6-common \
 php7.0-common \
 php7.1-common \
 php7.2-common \
 php7.3-common \
 libapache2-mod-php5.6 \
 php5.6-mysql \
 php5.6-pgsql \
 php5.6-gd \
 php5.6-curl \
 php5.6-apc \
 php5.6-mbstring \
 php5.6-intl \
 php5.6-json \
 php5.6-zmq \
 php5.6-apc \
 php5.6-dom \
 php5.6-xsl \
 php5.6-xml \
 php5.6-soap \
 php5.6-zip \
 php5.6-ldap \
 php5.6-bcmath \
 php5.6-mcrypt \
 libapache2-mod-php7.0 \
 php7.0-mysql \
 php7.0-pgsql \
 php7.0-gd \
 php7.0-curl \
 php7.0-apc \
 php7.0-mbstring \
 php7.0-intl \
 php7.0-json \
 php7.0-zmq \
 php7.0-apcu \
 php7.0-dom \
 php7.0-xsl \
 php7.0-xml \
 php7.0-soap \
 php7.0-zip \
 php7.0-ldap \
 php7.0-bcmath \
 php7.0-mcrypt \
 libapache2-mod-php7.1 \
 php7.1-mysql \
 php7.1-pgsql \
 php7.1-gd \
 php7.1-curl \
 php7.1-apc \
 php7.1-mbstring \
 php7.1-intl \
 php7.1-json \
 php7.1-zmq \
 php7.1-apc \
 php7.1-dom \
 php7.1-xsl \
 php7.1-xml \
 php7.1-soap \
 php7.1-zip \
 php7.1-ldap \
 php7.1-bcmath \
 php7.1-mcrypt \
 libapache2-mod-php7.2 \
 php7.2-mysql \
 php7.2-pgsql \
 php7.2-gd \
 php7.2-curl \
 php7.2-apc \
 php7.2-mbstring \
 php7.2-intl \
 php7.2-json \
 php7.2-zmq \
 php7.2-apc \
 php7.2-dom \
 php7.2-xsl \
 php7.2-xml \
 php7.2-soap \
 php7.2-zip \
 php7.2-ldap \
 php7.2-bcmath \
 libapache2-mod-php7.3 \
 php7.3-mysql \
 php7.3-pgsql \
 php7.3-gd \
 php7.3-curl \
 php7.3-apc \
 php7.3-mbstring \
 php7.3-intl \
 php7.3-json \
 php7.3-zmq \
 php7.3-apc \
 php7.3-dom \
 php7.3-xsl \
 php7.3-xml \
 php7.3-soap \
 php7.3-zip \
 php7.3-bcmath \
 php7.3-ldap \
 php-mailparse \
 php-imagick \
 php-font-lib \
 php-memcache \
 php-xdebug \
 gettext \
 pv \
 sudo \
 default-mysql-client \
 msmtp-mta \
 mc \
 cron \
 dialog \
 git-core && \
 rm -rf /var/lib/apt/lists/*

RUN npm install -g grunt-cli

ENV ALLOW_OVERRIDE **False**

RUN  /usr/sbin/a2enmod rewrite &&\
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -ri 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf


# composer stuff
RUN php -r 'readfile("https://getcomposer.org/installer");' > composer-setup.php \
  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
  && rm -f composer-setup.php \
  && chown www-data:www-data /var/www \
  && echo 'export ENV=DOCKER' >> /etc/apache2/envvars \
  && echo 'export SHOPWARE_ENV=dev' >> /etc/apache2/envvars

#install ION Cube, Zend Guard
COPY ./php7.0/ioncube_loader_lin_7.0.so /usr/lib/php/20151012
COPY ./php7.1/ioncube_loader_lin_7.1.so /usr/lib/php/20160303
COPY ./php7.2/ioncube_loader_lin_7.2.so /usr/lib/php/20170718
COPY ./php7.3/ioncube_loader_lin_7.3.so /usr/lib/php/20180731


COPY ./php5.6/ioncube_loader_lin_5.6.so	/usr/lib/php/20131226
COPY ./php5.6/ZendGuardLoader.so /usr/lib/php/20131226
COPY ./php5.6/opcache.so /usr/lib/php/20131226

#replase sendmail to msmtp
COPY ./msmtprc /etc/msmtprc
COPY ./aliases /etc/aliases
RUN mkdir /scripts
COPY ./scripts/b-log.sh /scripts/b-log.sh
COPY ./scripts/utils.sh /scripts/utils.sh


# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh


RUN mkdir /entrypoint.d && mkdir /var/log/docker
COPY ./entrypoint.sh /entrypoint.sh
COPY ./entrypoint.d/* /entrypoint.d/
RUN chmod 777 /entrypoint.d/*


WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
CMD ["/run.sh"]
