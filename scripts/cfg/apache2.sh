#!/bin/bash -x

source /host/settings.sh

mkdir -p /var/log/apache2

### create a configuration file
mkdir -p /var/www/html
cat <<EOF > /etc/apache2/sites-available/default.conf
<VirtualHost *:6565>
       ServerAdmin $EMAIL
       ServerName $FQDN
       #ServerAlias $FQDN
       DirectoryIndex index.html
       DocumentRoot /var/www/html/
       <Directory />
               Options FollowSymLinks
               AllowOverride None
       </Directory>
       <Directory /var/www/>
               Options Indexes FollowSymLinks MultiViews
               AllowOverride None
               Order allow,deny
               allow from all
       </Directory>
       ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
       <Directory "/usr/lib/cgi-bin">
               AllowOverride None
               Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
               Order allow,deny
               Allow from all
       </Directory>
       ErrorLog ${APACHE_LOG_DIR}/error.log
       LogLevel debug
       CustomLog ${APACHE_LOG_DIR}/ssl_access.log combined

       SSLEngine on
       SSLProtocol all -SSLv2 -SSLv3
       SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
       SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
       #SSLCertificateChainFile /etc/ssl/certs/ssl-cert-snakeoil.pem

       <FilesMatch "\.(cgi|shtml|phtml|php)$">
               SSLOptions +StdEnvVars
       </FilesMatch>
       <Directory /usr/lib/cgi-bin>
               SSLOptions +StdEnvVars
       </Directory>
       BrowserMatch "MSIE [2-6]" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0
       # MSIE 7 and newer should be able to use keepalive
       BrowserMatch "MSIE [17-9]" \
               ssl-unclean-shutdown
</VirtualHost>
EOF

### enable ssl etc.
a2enmod ssl
a2ensite default
a2dissite 000-default
service apache2 restart
