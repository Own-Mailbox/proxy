#!/bin/bash -x
### Configure bind.

echo "Configuring Bind9"

source /host/settings.sh

# setup your domain zone (omb.one file) in /var/lib/bind so that it can be updated
# Install dnsutils in order to have nsupdate.
# Allow your Ip to update domaines.

cat <<EOF >> /etc/bind/named.conf.local
zone "$MASTER_DOMAIN" IN {
    type master;
    file "/var/lib/bind/$MASTER_DOMAIN";
    allow-update { $SERVER_IP; };
};
EOF

cat <<EOF >> /var/lib/bind/$MASTER_DOMAIN
\$ORIGIN .
\$TTL 30 ; 30 seconds
$MASTER_DOMAIN                 IN SOA  $FQDN. email\@omb.one. (
                                2011042162 ; serial
                                30         ; refresh (30 seconds)
                                900        ; retry (15 minutes)
                                1209600    ; expire (2 weeks)
                                180        ; minimum (3 minutes)
                                )
                        NS      $FQDN.
\$ORIGIN $MASTER_DOMAIN.
*                       A       $SERVER_IP
                        MX      50 $FQDN
                        TXT     "v=spf1 a:$FQDN -all"
EOF

service bind9 restart
