#!/bin/bash

service apache2 stop
rm /var/log/apache2/*.log

if [ ! -z ${DOMAIN} ] ; then
if [ -z ${SITE_PROXY_DOMAIN} ] ; then export SITE_PROXY_DOMAIN="localhost:${PROXY_PORT}"; fi
a2enmod proxy proxy_http headers substitute
a2dissite 000-default
cat <<PROXY_HOST > /etc/apache2/sites-available/zs-proxy-host.conf
<VirtualHost *:80>
  AddOutputFilterByType INFLATE;SUBSTITUTE;DEFLATE text/html text/plain text/xml text/css text/javascript
  Substitute "s|${DOMAIN}|${SITE_PROXY_DOMAIN}|n"
  Header edit Location ${DOMAIN} ${SITE_PROXY_DOMAIN}

  RequestHeader set Host ${DOMAIN}
  ProxyPreserveHost On

  ProxyTimeout 900
  ProxyPass / http://web_server/
  ProxyPassReverse / http://web_server/
   <Proxy *>
    allow from all
   </Proxy>
</VirtualHost>

PROXY_HOST
a2ensite zs-proxy-host
else
a2dissite zs-proxy-host
fi

echo "Starting apache2"
service apache2 start

tail -F /var/log/apache2/*.log