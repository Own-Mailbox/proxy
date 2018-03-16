#!/bin/bash -x

source /host/settings.sh

mkdir -p /var/log/apache2

### create a configuration file
mkdir -p /var/www/html
cp $APP_DIR/src/apache/default.conf /etc/apache2/sites-available/
cp $APP_DIR/src/apache/ssl.conf /etc/apache2/sites-available/
cp $APP_DIR/src/apache/ports.conf /etc/apache2/
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

### Allow omb customers to get letsencrypt certificates
mkdir -p /var/www/html/.well-known/acme-challenge/


#Add phpmyadmin
ln -s  /usr/share/phpmyadmin/ /var/www/html/

### enable ssl etc.
a2enmod ssl
a2enmod rewrite
a2ensite default
a2dissite 000-default
rm /etc/apache2/sites-available/000-default.conf 

service apache2 restart


cat <<EOF >> /var/www/html/.well-known/acme-challenge/.htaccess
        RewriteEngine On
        RewriteBase /
        RewriteRule  "^(.*)"  "/cgi-bin/letsencrypt.cgi"   [L]
        Redirect "/test/gloups.html" "http://proxy.omb.one/"
EOF
