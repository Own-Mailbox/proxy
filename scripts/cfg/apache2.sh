#!/bin/bash -x
echo "Configuring Apache"

source /host/settings.sh

mkdir -p /var/log/apache2

### create a configuration file
mkdir -p /var/www/html

rm /etc/apache2/apache2.conf
cp $APP_DIR/src/apache2/apache2.conf /etc/apache2/

cp $APP_DIR/src/apache2/default.conf /etc/apache2/sites-available/
cp $APP_DIR/src/apache2/ssl.conf /etc/apache2/sites-available/
cp $APP_DIR/src/apache2/ports.conf /etc/apache2/

sed -i /etc/apache2/sites-available/default.conf \
    -e "s#ServerAdmin.*#ServerAdmin $EMAIL#" \
    -e "s#ServerName.*#ServerName $FQDN#" \
    -e "s#proxy.omb.one#$FQDN#"

sed -i /etc/apache2/sites-available/ssl.conf \
    -e "s#ServerName.*#ServerName $FQDN#" \
    -e "s#proxy.omb.one#$FQDN#"

### copy letsencrypt.cgi
mkdir -p /usr/lib/cgi-bin/
cp $APP_DIR/src/letsencrypt.cgi /usr/lib/cgi-bin/
chmod +x /usr/lib/cgi-bin/letsencrypt.cgi

### Create ok file
echo "OK"> /var/www/html/OK

### Allow omb customers to get letsencrypt certificates
sed -i $APP_DIR/src/apache2/.htaccess \
    -e "s#proxy.omb.one#$FQDN#"

mkdir -p /var/www/html/.well-known/acme-challenge/
cp $APP_DIR/src/apache2/.htaccess /var/www/html/.well-known/acme-challenge/

#Add phpmyadmin
ln -s  /usr/share/phpmyadmin/ /var/www/html/

### this fixes .htaccess files being ignored in /.well-known
a2disconf letsencrypt

### enable ssl etc.
a2enmod ssl
a2enmod rewrite
a2ensite default
a2ensite ssl
a2dissite 000-default
rm /etc/apache2/sites-available/000-default.conf

service apache2 restart
