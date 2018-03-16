#!/bin/bash -x

source /host/settings.sh

mkdir -p /var/log/apache2

### create a configuration file
mkdir -p /var/www/html
cp $APP_DIR/src/site-apache2-default.conf /etc/apache2/sites-available/default.conf
cp $APP_DIR/src/site-apache2-default.conf /etc/apache2/sites-available/ssl.conf
sed -i /etc/apache2/sites-available/default.conf \
    -e "s#ServerAdmin.*#ServerAdmin $EMAIL#" \
    -e "s#ServerName.*#ServerName $FQDN#" \
    -e "s#proxy.omb.one#$FQDN#"

    
### copy letsencrypt.cgi
mkdir -p /usr/lib/cgi-bin/
cp $APP_DIR/src/letsencrypt.cgi /usr/lib/cgi-bin/
chmod +x /usr/lib/cgi-bin/letsencrypt.cgi

### Create ok file
echo "OK"> /var/www/html/OK

### enable ssl etc.
a2enmod ssl
a2enmod rewrite
a2ensite default
a2dissite 000-default
rm /etc/apache2/sites-available/ 000-default
service apache2 restart
