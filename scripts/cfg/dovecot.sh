#!/bin/bash -x
echo "Configuring Dovecot"

source /host/settings.sh

# Copy Dovecot configuration files
mv /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.old
cp $APP_DIR/src/dovecot/dovecot.conf /etc/dovecot/dovecot.conf

# Replace omb.one with our custom domain
sed -i /etc/dovecot/dovecot.conf -e "s#proxy.omb.one#$FQDN#g"
