#!/bin/bash -x
### Configure postfix.

echo "Configuring postfix"

source /host/settings.sh

# setup hostname
echo "own-mailbox-proxy" > /etc/hostname
echo "127.0.0.1 own-mailbox-proxy" >> /etc/hosts

dir=/opt/Own-Mailbox/postfix-smpt2tor-relay
rm -rf $dir
git clone https://github.com/Own-Mailbox/postfix-smpt2tor-relay.git $dir
cd $dir
cp postfix-cfg/* /etc/postfix/

# ToDo: Edit /etc/config/transport.mysql and add your login to the database
sed -i /etc/postfix/transport.mysql \
    -e "s#root#$DBUSER#" \
    -e "s#xxxxxxx#$DBPASS#" \
    -e "s#postfix#$DBNAME#" \

cp scripts/* /usr/lib/postfix/

sed -i /etc/postfix/master.cf -e '/^smtptor unix - - - - - smtp_tor$/d'
echo "smtptor unix - - - - - smtp_tor" >> /etc/postfix/master.cf

sed -i /etc/postfix/main.cf \
    -e "s#proxy.omb.one-0003#$FQDN#g" \
    -e "s#proxy.omb.one#$FQDN#g" \

sed -i /etc/postfix/mydestinations -e "s#proxy.omb.one#$FQDN#"

sed -i /etc/postfix/virtual -e "s#omb.one#$MASTER_DOMAIN#g"
