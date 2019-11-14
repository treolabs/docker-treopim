FROM debian:buster

# Install base packages
RUN echo "deb http://ftp.de.debian.org/debian/ stable main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://ftp.de.debian.org/debian/ stable-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ stable/updates main" >> /etc/apt/sources.list && \
    echo "deb http://ftp.debian.org/debian buster-backports main" >> /etc/apt/sources.list && \
    apt-get -yq update && apt-get -yq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    curl wget mc apache2 gettext mc locales bzip2 apt-transport-https lsb-release ca-certificates gpg && \
    /usr/sbin/a2enmod rewrite &&\
    mkdir -p /var/www/html
    

#Remove unnecessary files
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -ri 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf


# Add image configuration and scripts
ADD run.sh /run.sh

RUN [ -d /var/www/html ] || mkdir -p /var/www/html

CMD ["/bin/bash", "/run.sh"]