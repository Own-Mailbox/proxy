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

# Edit /etc/config/transport.mysql and add your login to the database
sed -i /etc/postfix/transport.mysql \
    -e "s#root#$DBUSER#" \
    -e "s#xxxxxxx#$DBPASS#" \

cp scripts/* /usr/lib/postfix/

cp /usr/lib/postfix/smtp_tor /usr/lib/postfix/sbin/
sed -i /usr/lib/postfix/sbin/smtp_tor \ 
    -e 's#/usr/lib/postfix/smtp#/usr/lib/postfix/sbin/smtp#'

sed -i /etc/postfix/master.cf \
    -e '/^smtptor unix - - - - - smtp_tor$/d' \
    -e "s/#submission/submission/"

echo "smtptor unix - - - - - smtp_tor" >> /etc/postfix/master.cf

sed -i /etc/postfix/main.cf \
    -e "s#proxy.omb.one-0003#$FQDN#g" \
    -e "s#proxy.omb.one#$FQDN#g" \

domain=$(cut -d '.' -f 1 <<< "$MASTER_DOMAIN")
region=$(cut -d '.' -f 2 <<< "$MASTER_DOMAIN")

# not removing the FQDN line as someone may change the term 'proxy'
sed -i /etc/postfix/mydestinations \
    -e "s#omb#$domain#"\
    -e "s#one#$region#" \
    -e "s#proxy.omb.one#$FQDN#" \

sed -i /etc/postfix/virtual -e "s#omb.one#$MASTER_DOMAIN#g"

#############################################################
#The next lines apply changes needed only for postfix > v2.2#
#############################################################

sed -i /etc/postfix/main.cf \
    -e "s#smtpd_sasl_application_name = smtpd##" \
    -e "s#virtual_domains#virtual_alias_domains#" \
    -e "s#transport = mysql:/etc/postfix/transport.mysql##" \
