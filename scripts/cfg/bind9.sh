#!/bin/bash -x
### Configure bind.

source /host/settings.sh

# setup your domain zone (omb.one file) in /var/lib/bind so that it can be updated
# Install dnsutils in order to have nsupdate.
# Allow your Ip to update domaines.

cat <<EOF >> /etc/bind/named.conf.local
zone "$MASTER_DOMAIN" IN {
    type master;
    file "/var/lib/bind/$MASTER_DOMAIN";
    allow-update { 164.132.40.32; };
};
EOF
service bind9 restart
