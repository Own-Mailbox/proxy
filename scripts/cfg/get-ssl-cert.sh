#!/bin/bash -x

### get FQDN and EMAIL
source /host/settings.sh

# install certbot (for getting ssl certs with letsencrypt)
wget https://dl.eff.org/certbot-auto
chmod +x certbot-auto
mv certbot-auto /usr/local/bin/certbot
certbot --os-packages-only --non-interactive
certbot --version

### configure apache2 for letsencrypt
mkdir -p /var/www/.well-known/acme-challenge/
cat <<EOF > /etc/apache2/conf-available/letsencrypt.conf
Alias /.well-known/acme-challenge /var/www/.well-known/acme-challenge

<Directory /var/www/.well-known/acme-challenge>
    Options None
    AllowOverride None
    ForceType text/plain
</Directory>
EOF
a2enconf letsencrypt
service apache2 reload

# get a ssl cert
certbot certonly --webroot -m $EMAIL --agree-tos -w /var/www -d $FQDN || exit 1

# fix the apache configuration to use the new ssl cert
certdir=/etc/letsencrypt/live/$FQDN
sed -i /etc/apache2/sites-available/default.conf -r \
    -e "s|#?SSLCertificateFile .*|SSLCertificateFile      $certdir/cert.pem|" \
    -e "s|#?SSLCertificateKeyFile .*|SSLCertificateKeyFile   $certdir/privkey.pem|" \
    -e "s|#?SSLCertificateChainFile .*|SSLCertificateChainFile $certdir/chain.pem|"
service apache2 reload

### setup a cron job for renewing the ssl cert periodically
cat <<EOF > /etc/cron.weekly/renew-ssl-cert
#!/bin/bash
certbot renew --webroot --quiet --post-hook='/etc/init.d/apache2 reload'
EOF
chmod +x /etc/cron.weekly/renew-ssl-cert

