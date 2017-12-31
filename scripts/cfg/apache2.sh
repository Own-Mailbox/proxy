#!/bin/bash -x

source /host/settings.sh

mkdir -p /var/log/apache2

### create a configuration file
mkdir -p /var/www/html
cp $APP_DIR/src/apache2.conf /etc/apache2/sites-available/default.conf
sed -i /etc/apache2/sites-available/default.conf \
    -e "s#ServerAdmin.*#ServerAdmin $EMAIL#" \
    -e "s#ServerName.*#ServerName $FQDN#"

### enable ssl etc.
a2enmod ssl
a2ensite default
a2dissite 000-default
service apache2 restart
